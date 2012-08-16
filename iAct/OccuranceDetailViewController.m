//
//  OccuranceDetailViewController.m
//  iAct
//
//  Created by Giovanni Paolo Coia on 06/08/2012.
//
//

#import "OccuranceDetailViewController.h"

@implementation OccuranceDetailViewController

@synthesize ThoughtOccuranceMap;
@synthesize thoughtDescriptionLabel;
@synthesize thoughtRatingLabel;
@synthesize thought;
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
    thoughtDescriptionLabel.text = thought.content;
    thoughtRatingLabel.text = [occurance.postRating stringValue];
    [self setupMap];
    [super viewDidLoad];
}



- (void)viewDidUnload
{
    [self setOccurance:nil];
    [self setThought:nil];
    [self setThoughtOccuranceMap:nil];
    [self setThoughtDescriptionLabel:nil];
    [self setThoughtRatingLabel:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - Mapping

/**
Helper method to setup the map. Drops a placemark pin on the location of the occurence.
 */
- (void)setupMap {
        CLLocationCoordinate2D tempLoc;
        tempLoc.latitude = [self.occurance.latitude doubleValue];
        tempLoc.longitude = [self.occurance.longitude doubleValue];
        
        
        //get the date for placemark pin title
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
        [dateFormat setDateFormat:@"dd/MM hh:mm a"];
        
        PlaceMark *placeMark = [[PlaceMark alloc]
                                initWithCoordinate:tempLoc
                                andMarkTitle:[dateFormat stringFromDate:self.occurance.date]
                                andMarkSubTitle:[NSString stringWithFormat:@"You rated this %@", self.occurance.postRating]];
        
        
        [ThoughtOccuranceMap addAnnotation:placeMark];
    
    
    [self zoomMapViewToFitAnnotations:ThoughtOccuranceMap animated:YES];
}

//the following code obtained from: http://brianreiter.org/2012/03/02/size-an-mkmapview-to-fit-its-annotations-in-ios-without-futzing-with-coordinate-systems/
#define MINIMUM_ZOOM_ARC 0.014 //approximately 1 miles (1 degree of arc ~= 69 miles)
#define ANNOTATION_REGION_PAD_FACTOR 1.15
#define MAX_DEGREES_ARC 360
//size the mapView region to fit its annotations

/**
Helper method to resize map to fit occurence location pin.
 */
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

@end
