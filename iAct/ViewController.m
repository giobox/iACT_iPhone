//
//  ViewController.m
//  iAct
//
//  Created by Giovanni Paolo Coia on 02/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

@interface ViewController  ()

@property AppDelegate *sharedData; /**< Singleton class containing the model */

@end

@implementation ViewController

@synthesize emailAddressField;
@synthesize passwordField;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize signInButton;
@synthesize fetchedResultsController = __fetchedResultsController;
@synthesize sharedData;


/**
Sets up link to CoreData and user defaults property list when view appears. If the user has already logged in,
 an automatic transition to the main menu will take place.
 */
-(void)viewDidAppear:(BOOL)animated {
    
    //get the database
    sharedData = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.managedObjectContext = sharedData.managedObjectContext;
    
    //check if user is already logged in - no need to show login screen again
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults boolForKey:@"loginStatus"] == YES) {  
        [self performSegueWithIdentifier:@"toMainMenu" sender:self];
        
        //if already logged in load the user
        [self modelLoginWithEmail:[userDefaults stringForKey:@"username"] andName:nil];
    }
}

- (void)viewDidLoad
{
    [self customButtons];
    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [self setFetchedResultsController:nil];
    [self setManagedObjectContext:nil];
    [self setSharedData:nil];
    [self setEmailAddressField:nil];
    [self setPasswordField:nil];
    [self setSignInButton:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

/**
handles login checking once login button is pressed
 */
- (IBAction)LoginButton:(id)sender {
    
    //get the username and password the user has entered.
    NSString *email = emailAddressField.text;
    NSString *password = passwordField.text;
    
    //validate login details using restkit connection to server
    [self validateLogin:email withPassword:password];
}

/**
 Hides keyboard if user taps screen.
 */
- (IBAction)hideKeyboard:(id)sender {
    [self.emailAddressField resignFirstResponder];
    [self.passwordField resignFirstResponder];
}

#pragma mark - Online user validation

/**
 Validates user's login details with iACT server
 @param userName The user email
 @param password The user's password
 */
- (void)validateLogin:(NSString *)userName withPassword:(NSString *)password {
    //construct parameter dictionary for the login attempt
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:userName, @"email", password, @"password", nil];
    //POST login deets
    [[RKClient sharedClient] post:@"/iphonelogin" params:params delegate:self]; 
}



/**
 This method responds to login attempt response from iACT server. If login fails, error message displayed. If
 successful login proceeds and segues to main menu view controller.
 */
- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response {    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if ([response statusCode]==403) {
        NSLog(@"log in failed");
        //Display login failure dialog
        [userDefaults setBool:NO forKey:@"loginStatus"];
        UIAlertView *incorrectPasswordDialog;
        incorrectPasswordDialog = [[UIAlertView alloc] initWithTitle:@"Incorrect Details"   
                                                             message:@"You entered your email address or password incorrectly, please try again"
                                                            delegate:nil
                                                   cancelButtonTitle:@"Ok"
                                                   otherButtonTitles: nil];
        [incorrectPasswordDialog show];
    }
    
    if ([request isPOST]) {  
        NSLog(@"server response: %@", [response bodyAsString]);
        // Handling POST /other.json          
        if ([response isJSON]) {  
            NSLog(@"Got a JSON response back from our POST!:");
            [userDefaults setObject:emailAddressField.text forKey:@"username"];
            [userDefaults setObject:passwordField.text forKey:@"password"];
            [userDefaults setBool:YES forKey:@"loginStatus"];
            
            
            //get all user parameters from the JSON
            id parsedResponse = [response parsedBody:NULL];
            //get the auth token and use it for future requests
            NSString *token = [parsedResponse valueForKey:@"remember_token"];
            [[RKClient sharedClient] setValue:token forHTTPHeaderField:@"remember_token"];
            
            //get the user's name and ID
            NSString *userName = [parsedResponse valueForKey:@"name"];
            NSString *userID = [parsedResponse valueForKey:@"id"];
            //store them
            [userDefaults setObject:userName forKey:@"name"];
            [userDefaults setObject:userID forKey:@"ID"];
            
            //login or create new db object if required
            [self modelLoginWithEmail:self.emailAddressField.text andName:userName];
            
            //transition to main menu
            [self performSegueWithIdentifier:@"toMainMenu" sender:self];
        }  
        
    } 
}  

#pragma mark - Database setup/login

/**
 Creates a user entry in the data model. First checks to see if user already present, if not adds to to model
 @param email The user email
 @param name The user's password
 */
- (void)modelLoginWithEmail:(NSString *)email andName:(NSString *)name {
    NSError *error = nil;
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"User"];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"email MATCHES %@", email]];
    [fetchRequest setFetchLimit:1];
    
    NSInteger count = [self.managedObjectContext countForFetchRequest:fetchRequest error:&error];
    
    if (!error){
        if (count > 0){
            NSArray *userArray = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
            User *user = [userArray objectAtIndex:0];
            sharedData.loggedInUser = user; 
        }
        //if user not in the DB, add the user
        else {
            User *user = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:self.managedObjectContext];
            user.name = name;
            user.email = self.emailAddressField.text;
            user.password = self.passwordField.text;
            sharedData.loggedInUser = user;
            [self.managedObjectContext save:nil];
        }
    }    
    
}

/**
 Applies custom formatting to UIButtons.
 */
- (void)customButtons {
    UIImage *blueButtonImage = [[UIImage imageNamed:@"blueButton.png"]
                                resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    UIImage *blueButtonImageHighlight = [[UIImage imageNamed:@"blueButtonHighlight.png"]
                                         resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    
    [signInButton setBackgroundImage:blueButtonImage forState:UIControlStateNormal];
    [signInButton setBackgroundImage:blueButtonImageHighlight forState:UIControlStateHighlighted];
}

@end
