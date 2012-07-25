//
//  ViewController.m
//  iAct
//
//  Created by Giovanni Paolo Coia on 02/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

@interface ViewController  ()

@end

@implementation ViewController
@synthesize emailAddressField;
@synthesize passwordField;


-(void)viewDidAppear:(BOOL)animated {
    
        
    
    //check if user is already logged in - no need to show login screen again
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if ([userDefaults boolForKey:@"loginStatus"] == YES) {  
        [self performSegueWithIdentifier:@"toMainMenu" sender:self];
        
        //if already logged in loadthe mdoel
        AppDelegate *sharedData = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [sharedData loadModelFromDisk];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [self setEmailAddressField:nil];
    [self setPasswordField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


//handle login checking once button is pressed
- (IBAction)LoginButton:(id)sender {
    
    //get the username and password the user has entered.
    NSString *email = emailAddressField.text;
    NSString *password = passwordField.text;
    
    //validate using restkit to server
    [self validateLogin:email withPassword:password];
}

- (void)userIsLoggedIn {
    //method to confirm user logged in?
}
- (IBAction)hideKeyboard:(id)sender {
    [self.emailAddressField resignFirstResponder];
    [self.passwordField resignFirstResponder];
}


//this method validates login with server
- (void)validateLogin:(NSString *)userName withPassword:(NSString *)password {
    //construct parameter dictionary for the login attempt
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:userName, @"email", password, @"password", nil];
    //POST login deets
    [[RKClient sharedClient] post:@"/iphonelogin" params:params delegate:self]; 
}

//this method listens for the server response - handled because we set the delegate to self
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
    
    if ([request isGET]) {  
         NSLog(@"gRetrieved XML: %@", [response bodyAsString]);  
        
        if ([response isOK]) {  
            // Success! Let's take a look at the data  
            NSLog(@"oRetrieved XML: %@", [response bodyAsString]);  
        }  
        
    } else if ([request isPOST]) {  
         NSLog(@"server response: %@", [response bodyAsString]);
        // Handling POST /other.json          
        if ([response isJSON]) {  
            NSLog(@"Got a JSON response back from our POST!:");
            [userDefaults setObject:emailAddressField.text forKey:@"username"];
            [userDefaults setObject:passwordField.text forKey:@"password"];
            [userDefaults setBool:YES forKey:@"loginStatus"];
            
            
            //get all user parameters from the JSON
            id parsedResponse = [response parsedBody:NULL];
            //get the auth token and use it for future requests!
            NSString *token = [parsedResponse valueForKey:@"remember_token"];
            [[RKClient sharedClient] setValue:token forHTTPHeaderField:@"remember_token"];
            
            //get the user's name and ID
            NSString *userName = [parsedResponse valueForKey:@"name"];
            NSString *userID = [parsedResponse valueForKey:@"id"];
            //store them
            [userDefaults setObject:userName forKey:@"name"];
            [userDefaults setObject:userID forKey:@"ID"];
            
            
            //load the users data model
            AppDelegate *sharedData = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            [sharedData loadModelFromDisk];
            
            [self performSegueWithIdentifier:@"toMainMenu" sender:self];
        }  
        
    } else if ([request isDELETE]) {  
        
        // Handling DELETE /missing_resource.txt  
        if ([response isNotFound]) {  
            NSLog(@"The resource path '%@' was not found.", [request resourcePath]);  
        }  
    }  
}  

@end
