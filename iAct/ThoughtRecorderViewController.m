//
//  ThoughtRecorderViewController.m
//  iAct
//
//  Created by Giovanni Paolo Coia on 02/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ThoughtRecorderViewController.h"


@interface ThoughtRecorderViewController ()

//Location manager instance

@property (strong, nonatomic) CLLocation *currentLocation;

@end

@implementation ThoughtRecorderViewController
@synthesize thoughtDescription;
@synthesize thoughtRatingSlider;
@synthesize thoughtRating;
@synthesize recordThoughtButton;
@synthesize locMan;
@synthesize currentLocation;
@synthesize enteredThought;



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
    [self setEnteredThought:nil];
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
    
    //4. get the thought location
    //handled in the location manager listener method which then stores location in currentlocation
    //however must shut GPS down
    [self.locMan stopUpdatingLocation];
    
    //finally build the thought!
    enteredThought = [[ThoughtInstance alloc] init];
    [enteredThought setThoughtWithName:thoughtDesc andTime:thoughtTime withRating:thoughtScore andLocation:currentLocation];
        
    //save the thought to the model
        
        AppDelegate *sharedData = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [[sharedData getUserDataModel] addThought:enteredThought];
    
    [self performSegueWithIdentifier:@"showThought" sender:self];      
    }
    
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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 
    
    //going to pass the recorded thought to next view
    //because we can segue in two directions, need to check that destination view controller supports setthought.
    //also reduces coupling.
    if ([segue.destinationViewController respondsToSelector:@selector(setThought:)]) {
        [segue.destinationViewController performSelector:@selector(setThought:) 
                                              withObject:enteredThought];
    } 
}

@end
