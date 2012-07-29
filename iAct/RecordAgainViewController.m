//
//  RecordAgainViewController.m
//  iAct
//
//  Created by Giovanni Paolo Coia on 25/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RecordAgainViewController.h"

@interface RecordAgainViewController ()

@property (strong, nonatomic) CLLocation *currentLocation;
@property (strong, nonatomic) AppDelegate *sharedData;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@end

@implementation RecordAgainViewController
@synthesize thoughtDescriptionLabel;
@synthesize sharedData;
@synthesize thought;
@synthesize locMan;
@synthesize thoughtRatingSlider;
@synthesize currentLocation;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize fetchedResultsController = __fetchedResultsController;

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
    sharedData = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.managedObjectContext = sharedData.managedObjectContext;
    self.locMan = [[CLLocationManager alloc] init];
    self.locMan.delegate = self;
    locMan.distanceFilter= 200;
    [locMan startUpdatingLocation];

    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setLocMan:nil];
    [self setThought:nil];
    [self setThoughtDescriptionLabel:nil];
    [self setThoughtRatingSlider:nil];
    [self setCurrentLocation:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) viewDidAppear:(BOOL)animated {

    //load the description into the view
    self.thoughtDescriptionLabel.text = self.thought.content;
}
- (IBAction)saveThought:(id)sender {
    float thoughtScore = self.thoughtRatingSlider.value;
    NSDate *thoughtTime = [NSDate date];
    //4. get the thought location
    //handled in the location manager listener method which then stores location in currentlocation
    //however must shut GPS down
    [self.locMan stopUpdatingLocation];
   
    //create the occurence
    ThoughtOccurance *occurance = [NSEntityDescription insertNewObjectForEntityForName:@"ThoughtOccurance" inManagedObjectContext:self.managedObjectContext];
    occurance.date = thoughtTime;
    occurance.initialRating = [NSNumber numberWithFloat:thoughtScore];
    occurance.latitude = [NSNumber numberWithDouble:currentLocation.coordinate.latitude];
    occurance.longitude = [NSNumber numberWithDouble:currentLocation.coordinate.longitude];
    
    [occurance setHasThought:thought];
    [thought addHasOccuranceObject:occurance];
    [self.managedObjectContext save:nil];
    
    //pop back to root of controller
    [self.navigationController popToRootViewControllerAnimated:YES];
}

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
@end
