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

@property (strong, nonatomic) CLLocation *currentLocation; /**< GPS Location of thought  */
@property Thought *thought; /**< Thought being recorded.  */
@property ThoughtOccurance *occurance; /**< Occurence of thought being recorded.  */

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
@synthesize newThought;
@synthesize managedObjectContext = __managedObjectContext;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
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
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

/**
 Hides keyboard if user taps screen.
 */
- (IBAction)hideKeyboard:(id)sender {
    
    [self.thoughtDescription resignFirstResponder];
}

/**
Method updates rating label in real time as user changes rating slider.
 */
- (IBAction)userChangedThoughtRating:(id)sender {
    //update number output for thought when slider value is changed
    self.thoughtRating.text = [NSString stringWithFormat:@"%1.1f", self.thoughtRatingSlider.value];
}

/**
Gets thought parameters and constructs the thought object for saving to the CoreData model. Also creates that thought's
 first occurence. A segue to the manipulate thought view is then performed. First performs a search to see if this thought has
 been entered before, and if it has just creates a new occurence. If this is the first time this thought has been created, both thought
 and occurence will be created.
 */
- (IBAction)recordThought:(id)sender {
    AppDelegate *sharedData = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.managedObjectContext = sharedData.managedObjectContext;
    
    //If users input is valid, proceed
    if([self validateInput]) {
        //1. get the current time
        NSDate *thoughtTime = [NSDate date];
        //2. save the thought name
        NSString *thoughtDesc = self.thoughtDescription.text;
        //3. Save the thought rating
        float thoughtScore = self.thoughtRatingSlider.value;
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
                newThought = NO;
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
                                
                [self performSegueWithIdentifier:@"manipulateThought" sender:self];  
                
            } else {
                //save the thought to the model
                //create the thought
                newThought = YES;
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
                [self performSegueWithIdentifier:@"manipulateThought" sender:self];  
            }
        }
    }
}

#pragma mark - location manager methods

/**
This location manager protocol method gets location updates. As each update arrives the currentLocation instance variable is updated
 to record new position.
 */
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

/**
 Prepares data for sending to next view controller. Passes thought and occurence to next view controller.
 */
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[ segue identifier] isEqualToString:@"manipulateThought"]) {
        //pass the created thought and occurance to the next view
        ACTManipilationViewController *manipulationViewController = [segue destinationViewController];
        manipulationViewController.thought = self.thought;
        manipulationViewController.occurance = self.occurance;
        manipulationViewController.newThought = self.newThought;
    }
} 

/**
 Validates user's input to ensure all fields filled. If not, an error message is displayed.
 @return BOOL Boolean indicating whether data was valid or not.
 */
- (BOOL)validateInput {
    if ([self.thoughtDescription.text isEqualToString:@""]) {
        UIAlertView *incompleteThoughtDialog;
        incompleteThoughtDialog = [[UIAlertView alloc] initWithTitle:@"Incomplete Thought"
                                                             message:@"You forgot to enter a thought description!"
                                                            delegate:nil
                                                   cancelButtonTitle:@"Ok"
                                                   otherButtonTitles: nil];
        [incompleteThoughtDialog show];
        return NO;
    }
        else
            return YES;
}

/**
 Applies custom formatting to UIButtons.
 */
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
