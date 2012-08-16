//
//  RecordAgainViewController.m
//  iAct
//
//  Created by Giovanni Paolo Coia on 25/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RecordAgainViewController.h"

@interface RecordAgainViewController ()

@property (strong, nonatomic) CLLocation *currentLocation; /**< GPS Location of thought  */
@property (strong, nonatomic) AppDelegate *sharedData;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) ThoughtOccurance *occurance; /**< New occurence  */

@end

@implementation RecordAgainViewController
@synthesize thoughtDescriptionLabel;
@synthesize sharedData;
@synthesize thought;
@synthesize locMan;
@synthesize thoughtRatingSlider;
@synthesize saveButton;
@synthesize thoughtRatingLabel;
@synthesize currentLocation;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize fetchedResultsController = __fetchedResultsController;
@synthesize occurance;

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
    sharedData = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.managedObjectContext = sharedData.managedObjectContext;
    [self customButtons];
    
    self.locMan = [[CLLocationManager alloc] init];
    self.locMan.delegate = self;
    locMan.distanceFilter= 200;
    [locMan startUpdatingLocation];

    [super viewDidLoad];
}

- (void)viewDidUnload
{
    [self setLocMan:nil];
    [self setThought:nil];
    [self setThoughtDescriptionLabel:nil];
    [self setThoughtRatingSlider:nil];
    [self setCurrentLocation:nil];
    [self setSharedData:nil];
    [self setThought:nil];
    [self setManagedObjectContext:nil];
    [self setFetchedResultsController:nil];
    [self setOccurance:nil];
    [self setSaveButton:nil];
    [self setThoughtRatingLabel:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) viewDidAppear:(BOOL)animated {
    //load the description into the view
    self.thoughtDescriptionLabel.text = self.thought.content;
}

/**
Helper method saves new occurence to CoreData model in preparation for segue to manipulation screen.
 */
- (void)saveThoughtOccurance {
    float thoughtScore = self.thoughtRatingSlider.value;
    NSDate *thoughtTime = [NSDate date];
    //4. get the thought location
    //handled in the location manager listener method which then stores location in currentlocation
    //however must shut GPS down
    [self.locMan stopUpdatingLocation];
    
    //create the occurence
    self.occurance = [NSEntityDescription insertNewObjectForEntityForName:@"ThoughtOccurance" inManagedObjectContext:self.managedObjectContext];
    self.occurance.date = thoughtTime;
    self.occurance.initialRating = [NSNumber numberWithFloat:thoughtScore];
    self.occurance.latitude = [NSNumber numberWithDouble:currentLocation.coordinate.latitude];
    self.occurance.longitude = [NSNumber numberWithDouble:currentLocation.coordinate.longitude];
    
    [self.occurance setHasThought:thought];
    [thought addHasOccuranceObject:self.occurance];
    [self.managedObjectContext save:nil];
}

/**
 Prepares data for sending to next view controller. Passes thought and occurence to next view controller.
 */
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[ segue identifier] isEqualToString:@"recordNewOcurranceSegue"]) {
        //pass the created thought and occurance to the next view
        [self saveThoughtOccurance];
        ACTManipilationViewController *manipulationViewController = [segue destinationViewController];
        manipulationViewController.thought = self.thought;
        manipulationViewController.occurance = self.occurance;
        manipulationViewController.newThought = NO;
    }
}

#pragma mark - Core Location

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

/**
 Applies custom formatting to UIButtons.
 */
- (void)customButtons {
    //load the images
    UIImage *blueButtonImage = [[UIImage imageNamed:@"blueButton.png"]
                                resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    UIImage *blueButtonImageHighlight = [[UIImage imageNamed:@"blueButtonHighlight.png"]
                                         resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    
    [saveButton setBackgroundImage:blueButtonImage forState:UIControlStateNormal];
    [saveButton setBackgroundImage:blueButtonImageHighlight forState:UIControlStateHighlighted];
}

/**
 Method updates rating label in real time as user changes rating slider.
 */
- (IBAction)thoughtRatingValueChanged:(id)sender {
        //update number output for thought when slider value is changed
        self.thoughtRatingLabel.text = [NSString stringWithFormat:@"%1.1f", self.thoughtRatingSlider.value];
}
@end
