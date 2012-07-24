//
//  ThoughtDetailViewController.m
//  iAct
//
//  Created by Giovanni Paolo Coia on 03/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ThoughtDetailViewController.h"

@interface ThoughtDetailViewController ()

@property (strong, nonatomic) AppDelegate *sharedData;

@end

@implementation ThoughtDetailViewController
@synthesize thoughtMap;
@synthesize thoughtDescription;
@synthesize thoughtRating;
@synthesize thought;
@synthesize sharedData;


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

-(void) viewDidAppear:(BOOL)animated {
    //get the chosen thought
    sharedData = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.thought = sharedData.tempThought;
    //update the map
    [self setupMap];
    self.thoughtDescription.text = thought.thoughtDescription;
    self.thoughtRating.text = [NSString stringWithFormat:@"%1.1f",thought.thoughtRating];
}

- (void)viewDidUnload
{
    [self setThoughtMap:nil];
    [self setThoughtDescription:nil];
    [self setThoughtRating:nil];
    [self setThought:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)setupMap {
    //center the map on the thoughts location
    MKCoordinateRegion mapRegion;
    mapRegion.center = thought.currentLocation.coordinate;
    mapRegion.span.latitudeDelta=0.007;
    mapRegion.span.longitudeDelta=0.007;
    [self.thoughtMap setRegion:mapRegion animated:YES]; 
    
    //drop a pin on it
    MKPlacemark *thoughtPin = [[MKPlacemark alloc] initWithCoordinate:thought.currentLocation.coordinate addressDictionary:nil];
    [thoughtMap addAnnotation:thoughtPin];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
