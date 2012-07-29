//
//  ThoughtRecorderViewController.m
//  iAct
//
//  Created by Giovanni Paolo Coia on 02/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ThoughtRecorderViewController.h"
#import "Thought.h"
#import "ThoughtOccurance.h"


@interface ThoughtRecorderViewController ()

//Location manager instance

@property (strong, nonatomic) CLLocation *currentLocation;

//thought and thought occurance being recorded
@property Thought *thought;
@property ThoughtOccurance *occurance;

@end

@implementation ThoughtRecorderViewController
@synthesize thoughtDescription;
@synthesize thoughtRatingSlider;
@synthesize thoughtRating;
@synthesize recordThoughtButton;
@synthesize locMan;
@synthesize currentLocation;
@synthesize thought;
@synthesize occurance;


@synthesize managedObjectContext = __managedObjectContext;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    //once we load the view start locating the user.
    //gives some time to get an accurate location fix, without leaving on for ages and killing battery.
    [self customButtons];
    self.locMan = [[CLLocationManager alloc] init];
    self.locMan.delegate = self;
    //self.locMan.desiredAccuracy = kCLLocationAccuracyBest;
    locMan.distanceFilter= 200;
    
    [locMan startUpdatingLocation];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setThoughtDescription:nil];
    [self setThoughtRatingSlider:nil];
    [self setThoughtRating:nil];
    [self setRecordThoughtButton:nil];
    [self setLocMan:nil];
    [self setCurrentLocation:nil];
    [self setThought:nil];
    [self setOccurance:nil];
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)hideKeyboard:(id)sender {
    
    [self.thoughtDescription resignFirstResponder];
    
}

- (IBAction)userChangedThoughtRating:(id)sender {
    //update number output for thought when slider value is changed
    self.thoughtRating.text = [NSString stringWithFormat:@"%1.1f", self.thoughtRatingSlider.value];
}

- (IBAction)recordThought:(id)sender {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    AppDelegate *sharedData = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.managedObjectContext = sharedData.managedObjectContext;
    
    //first check user has filled all required info, error message if not
    if ([self.thoughtDescription.text isEqualToString:@""]) {
        UIAlertView *incompleteThoughtDialog;
        incompleteThoughtDialog = [[UIAlertView alloc] initWithTitle:@"Incomplete Thought"   
                                                             message:@"You forgot to enter a thought description!"
                                                            delegate:nil
                                                   cancelButtonTitle:@"Ok"
                                                   otherButtonTitles: nil];
        [incompleteThoughtDialog show];
    } else {
        
        //if input valid begin process of recording the thought
        //1. get the current time
        NSDate *thoughtTime = [NSDate date];
        
        //2. save the thought name
        NSString *thoughtDesc = self.thoughtDescription.text;
        
        //3. Save the thought rating
        float thoughtScore = self.thoughtRatingSlider.value;
        NSInteger scoreInt = (int) thoughtScore;
        NSNumber *integer = [NSNumber numberWithInt:scoreInt]; 
        
        
        //4. get the thought location
        //handled in the location manager listener method which then stores location in currentlocation
        //however must shut GPS down
        [self.locMan stopUpdatingLocation];
        
        //5. before saving check to see if this thought has been recorded before. if so just add an occurance
        NSError *error = nil;
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Thought"];
        [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"content MATCHES %@", thoughtDesc]];
        [fetchRequest setFetchLimit:1];
        NSInteger count = [self.managedObjectContext countForFetchRequest:fetchRequest error:&error];
        if (!error){
            if (count > 0){
                //it was found
                //get the thought and just add another instance rather than a new thought
                NSArray *userArray = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
                thought = [userArray objectAtIndex:0];
                
                occurance = [NSEntityDescription insertNewObjectForEntityForName:@"ThoughtOccurance" inManagedObjectContext:self.managedObjectContext];
                occurance.date = thoughtTime;
                occurance.initialRating = [NSNumber numberWithFloat:thoughtScore];
                occurance.latitude = [NSNumber numberWithDouble:currentLocation.coordinate.latitude];
                occurance.longitude = [NSNumber numberWithDouble:currentLocation.coordinate.longitude];
                
                [occurance setHasThought:thought];
                [thought addHasOccuranceObject:occurance];
                [self.managedObjectContext save:nil];
                
                //send occurance to iACT online
                
                [self performSegueWithIdentifier:@"showThought" sender:self];  
                
            } else {
                //send the thought to iACT Online   
                //construct parameter dictionary for the login attempt
                //NSString *sharedSecret = [userDefaults objectForKey:@"remember_token"];
                NSString *userID = [userDefaults objectForKey:@"ID"];
                NSDictionary* parameters = [NSDictionary dictionaryWithObjectsAndKeys:userID, @"id", thoughtDesc, @"content", integer, @"InitialRating",  nil];
                
                //POST login details. REPLACE with new thread - no point locking UI while waiting on slow data connection
                [[RKClient sharedClient] post:@"/iphonerecordthought" params:parameters delegate:self];
                
                
                
                
                
                //save the thought to the model
                //create the thought
                
                thought = [NSEntityDescription insertNewObjectForEntityForName:@"Thought" inManagedObjectContext:self.managedObjectContext];
                NSLog(@"this user is called %@", sharedData.loggedInUser.name);
                thought.content=thoughtDesc;
                thought.hasUser=sharedData.loggedInUser;
                
                //create the occurence
                occurance = [NSEntityDescription insertNewObjectForEntityForName:@"ThoughtOccurance" inManagedObjectContext:self.managedObjectContext];
                occurance.date = thoughtTime;
                occurance.initialRating = [NSNumber numberWithFloat:thoughtScore];
                occurance.latitude = [NSNumber numberWithDouble:currentLocation.coordinate.latitude];
                occurance.longitude = [NSNumber numberWithDouble:currentLocation.coordinate.longitude];
                
                [occurance setHasThought:thought];
                [thought addHasOccuranceObject:occurance];
                [sharedData.loggedInUser addHasThoughtObject:thought];
                
                //save to coredata
                [self.managedObjectContext save:nil];
                NSInteger thoughtCount = [sharedData.loggedInUser.hasThought count];
                NSLog(@"This user now has %d thoughts", thoughtCount);
            }
            
            
        }
        
        
    }
    
}

#pragma mark - location manager methods

//This protocol method gets location updates
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    self.currentLocation=newLocation;
}


//Protocol methods for handeling core location errors
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if(error.code == kCLErrorLocationUnknown) {
        NSLog(@"Currently unable to retrieve location.");
    } if(error.code == kCLErrorNetwork) {
        NSLog(@"Network used to retrieve location is unavailable.");
    } if(error.code == kCLErrorDenied) {
        NSLog(@"Permission to retrieve location is denied.");
        //user has denied access, so shutdown the GPS
        [self.locMan stopUpdatingLocation];
        [self setLocMan:nil];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[ segue identifier] isEqualToString:@"showThought"]) {
        //pass the created thought and occurance to the next view
        ThoughtDisplayViewController *displayViewController = [segue destinationViewController];
        displayViewController.thought = self.thought;
        displayViewController.occurance=self.occurance;
    }
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
            NSLog(@"server response: %@", [response bodyAsString]);
            
            //if we logged the thought successfully, move on!
            [self performSegueWithIdentifier:@"showThought" sender:self];  
            
            
        }  
        
    } else if ([request isDELETE]) {  
        
        // Handling DELETE /missing_resource.txt  
        if ([response isNotFound]) {  
            NSLog(@"The resource path '%@' was not found.", [request resourcePath]);  
        }  
    }  
}  
    
    


- (void)customButtons {
    //load the images
    UIImage *blueButtonImage = [[UIImage imageNamed:@"blueButton.png"]
                                resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    UIImage *blueButtonImageHighlight = [[UIImage imageNamed:@"blueButtonHighlight.png"]
                                         resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    
    [recordThoughtButton setBackgroundImage:blueButtonImage forState:UIControlStateNormal];
    [recordThoughtButton setBackgroundImage:blueButtonImageHighlight forState:UIControlStateHighlighted];
    
    
}

@end
