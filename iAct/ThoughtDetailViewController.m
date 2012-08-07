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
@property (strong, nonatomic) NSArray *occuranceArray;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@end

@implementation ThoughtDetailViewController
@synthesize thoughtMap;
@synthesize thoughtDescription;
@synthesize thoughtOccuranceTable;
@synthesize sharedData;
@synthesize occuranceArray;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize fetchedResultsController = __fetchedResultsController;
@synthesize thought;
@synthesize recordAgainButton;


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
    [self customButtons];
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated {
    sharedData = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.managedObjectContext = sharedData.managedObjectContext;
    self.thoughtDescription.text = thought.content;
    [self getInstances];
    [self.thoughtOccuranceTable reloadData];
    
}

-(void) viewDidAppear:(BOOL)animated {
    
    //update the map
    [self setupMap];
    //insert text update here
}

- (void)viewDidUnload
{
    [self setOccuranceArray:nil];
    [self setThoughtMap:nil];
    [self setThoughtDescription:nil];
    [self setThoughtOccuranceTable:nil];
    [self setSharedData:nil];
    [self setManagedObjectContext:nil];
    [self setFetchedResultsController:nil];
    [self setThought:nil];
    [self setRecordAgainButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

//Methods for table view
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [occuranceArray count];
}


-(void)getInstances {
    NSError *error = nil;
    // 1 - Decide what Entity you want
    NSString *entityName = @"ThoughtOccurance"; // Put your entity name here
    NSLog(@"Setting up a Fetched Results Controller for the Entity named %@", entityName);
    
    // 2 - Request that Entity
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    
    // 3 - Filter it if you want
    [request setPredicate:[NSPredicate predicateWithFormat:@"hasThought == %@", thought]];
    
    // 4 - Sort it if you want
    //request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name"
    //                                                                               ascending:YES
    //                                                                              selector:@selector(localizedCaseInsensitiveCompare:)]];
    
    // 5 - Fetch it
    occuranceArray = [self.managedObjectContext executeFetchRequest:request error:&error];
    NSLog(@" %@ ", thought.content);
    NSLog(@"the number of thoughts is %d", [occuranceArray count]);
}


-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"History";
}

//MAKE SOME CELLS
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //define the one cell type
    UITableViewCell *thoughtCell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    //thoughtCell.textLabel.text=[[self.thought.instanceArray objectAtIndex:indexPath.row] objectForKey:@"rating"];
    ThoughtOccurance *occurance = [occuranceArray objectAtIndex:indexPath.row];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setDateFormat:@"dd/MM hh:mm a"];
    thoughtCell.textLabel.text = [dateFormat stringFromDate:occurance.date];
    thoughtCell.detailTextLabel.text = [NSString stringWithFormat:@"You rated this %@", occurance.postRating];
    return thoughtCell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"recordAgainSegue"]) {
        //the segue sender is the row on the table, we cast this to get its index
        RecordAgainViewController *recordAgainController = [segue destinationViewController];
        recordAgainController.thought=self.thought;
    }
    
    if([[segue identifier] isEqualToString:@"occuranceViewSegue"]) {
        //get the chosen cell and pass it to next view
        UITableViewCell *cell = (UITableViewCell*)sender;
        NSIndexPath *indexPath = [self.thoughtOccuranceTable indexPathForCell:cell];
        
        OccuranceDetailViewController *occuranceDetail = [segue destinationViewController];
        occuranceDetail.occurance = [occuranceArray objectAtIndex:indexPath.row];
        occuranceDetail.thought = self.thought;
    }
}


#pragma mark - Mapping methods

- (void)setupMap {
    //loop through all occurances and generate pins for map
    NSMutableArray *mapPinArray = [[NSMutableArray alloc] init];
    for (int x=0; x<occuranceArray.count; x++) {
        ThoughtOccurance *tempThought = [occuranceArray objectAtIndex:x];
        CLLocationCoordinate2D tempLoc;
        tempLoc.latitude = [tempThought.latitude doubleValue];
        tempLoc.longitude = [tempThought.longitude doubleValue];
        
        
        //get the date for placemark pin title
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
        [dateFormat setDateFormat:@"dd/MM hh:mm a"];
        
        PlaceMark *placeMark = [[PlaceMark alloc]
                                initWithCoordinate:tempLoc
                                andMarkTitle:[dateFormat stringFromDate:tempThought.date]
                                andMarkSubTitle:[NSString stringWithFormat:@"You rated this %@", tempThought.postRating]];
        
        //add to mappin array
        [mapPinArray addObject:placeMark];
    }
    
    //loop through map pin array and drop the pins on the map
    for (int x=0; x<mapPinArray.count; x++) {
        [thoughtMap addAnnotation:[mapPinArray objectAtIndex:x]];
    }
    
    [self zoomMapViewToFitAnnotations:self.thoughtMap animated:YES];
}

//the following code obtained from: http://brianreiter.org/2012/03/02/size-an-mkmapview-to-fit-its-annotations-in-ios-without-futzing-with-coordinate-systems/
#define MINIMUM_ZOOM_ARC 0.014 //approximately 1 miles (1 degree of arc ~= 69 miles)
#define ANNOTATION_REGION_PAD_FACTOR 1.15
#define MAX_DEGREES_ARC 360
//size the mapView region to fit its annotations
- (void)zoomMapViewToFitAnnotations:(MKMapView *)mapView animated:(BOOL)animated
{
    NSArray *annotations = mapView.annotations;
    int count = [mapView.annotations count];
    if ( count == 0) { return; } //bail if no annotations
    
    //convert NSArray of id <MKAnnotation> into an MKCoordinateRegion that can be used to set the map size
    //can't use NSArray with MKMapPoint because MKMapPoint is not an id
    MKMapPoint points[count]; //C array of MKMapPoint struct
    for( int i=0; i<count; i++ ) //load points C array by converting coordinates to points
    {
        CLLocationCoordinate2D coordinate = [(id <MKAnnotation>)[annotations objectAtIndex:i] coordinate];
        points[i] = MKMapPointForCoordinate(coordinate);
    }
    //create MKMapRect from array of MKMapPoint
    MKMapRect mapRect = [[MKPolygon polygonWithPoints:points count:count] boundingMapRect];
    //convert MKCoordinateRegion from MKMapRect
    MKCoordinateRegion region = MKCoordinateRegionForMapRect(mapRect);
    
    //add padding so pins aren't scrunched on the edges
    region.span.latitudeDelta  *= ANNOTATION_REGION_PAD_FACTOR;
    region.span.longitudeDelta *= ANNOTATION_REGION_PAD_FACTOR;
    //but padding can't be bigger than the world
    if( region.span.latitudeDelta > MAX_DEGREES_ARC ) { region.span.latitudeDelta  = MAX_DEGREES_ARC; }
    if( region.span.longitudeDelta > MAX_DEGREES_ARC ){ region.span.longitudeDelta = MAX_DEGREES_ARC; }
    
    //and don't zoom in stupid-close on small samples
    if( region.span.latitudeDelta  < MINIMUM_ZOOM_ARC ) { region.span.latitudeDelta  = MINIMUM_ZOOM_ARC; }
    if( region.span.longitudeDelta < MINIMUM_ZOOM_ARC ) { region.span.longitudeDelta = MINIMUM_ZOOM_ARC; }
    //and if there is a sample of 1 we want the max zoom-in instead of max zoom-out
    if( count == 1 )
    {
        region.span.latitudeDelta = MINIMUM_ZOOM_ARC;
        region.span.longitudeDelta = MINIMUM_ZOOM_ARC;
    }
    [mapView setRegion:region animated:animated];
}

- (void)customButtons {
    //load the images
    UIImage *blackButtonImage = [[UIImage imageNamed:@"blueButton.png"]
                                resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    UIImage *blackButtonImageHighlight = [[UIImage imageNamed:@"blueButtonHighlight.png"]
                                         resizableImageWithCapInsets:UIEdgeInsetsMake(18, 18, 18, 18)];
    
    [recordAgainButton setBackgroundImage:blackButtonImage forState:UIControlStateNormal];
    [recordAgainButton setBackgroundImage:blackButtonImageHighlight forState:UIControlStateHighlighted];
}

@end
