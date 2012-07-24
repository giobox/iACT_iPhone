//
//  ThoughtDisplayViewController.m
//  iAct
//
//  Created by Giovanni Paolo Coia on 02/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ThoughtDisplayViewController.h"

@interface ThoughtDisplayViewController ()

@property (strong, nonatomic) MKPlacemark *thoughtPin;

@end

@implementation ThoughtDisplayViewController

@synthesize thoughtTextDisplay;
@synthesize thoughtRatingDisplay;
@synthesize thoughtLocationDisplay;
@synthesize thought;
@synthesize thoughtPin;

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
   
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void) viewWillAppear:(BOOL)animated {
    //hide the bar
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    //update the map
    [self setupMap];
    self.thoughtTextDisplay.text = thought.thoughtDescription;
    self.thoughtRatingDisplay.text = [NSString stringWithFormat:@"%1.1f",thought.thoughtRating];
    
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
    
    //bring the bar back
	[self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewDidUnload
{
    [self setThought:nil];
    [self setThoughtTextDisplay:nil];
    [self setThoughtRatingDisplay:nil];
    [self setThoughtLocationDisplay:nil];
    [self setThoughtPin:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)finishViewing:(id)sender {
    //return to root of the navigation menu
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)setupMap {
    //center the map on the thoughts location
    MKCoordinateRegion mapRegion;
    mapRegion.center = thought.currentLocation.coordinate;
    mapRegion.span.latitudeDelta=0.007;
    mapRegion.span.longitudeDelta=0.007;
    [self.thoughtLocationDisplay setRegion:mapRegion animated:YES];    
   
    //drop a pin on it
    thoughtPin = [[MKPlacemark alloc] initWithCoordinate:thought.currentLocation.coordinate addressDictionary:nil];
    [thoughtLocationDisplay addAnnotation:thoughtPin];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    MKPinAnnotationView *pinDrop=[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myspot"];
    pinDrop.animatesDrop=YES;
    pinDrop.canShowCallout=YES;
    pinDrop.pinColor=MKPinAnnotationColorGreen;
    return pinDrop;
}
@end
