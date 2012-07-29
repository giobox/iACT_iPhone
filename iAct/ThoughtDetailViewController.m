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
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)setupMap {
    //center the map on the thoughts location
    //ThoughtInstance *thought = [sharedData.model getThought:thoughtIndex];
    //MKCoordinateRegion mapRegion;
    //mapRegion.center = thought.currentLocation.coordinate;
    //mapRegion.span.latitudeDelta=0.007;
    //mapRegion.span.longitudeDelta=0.007;
    //[self.thoughtMap setRegion:mapRegion animated:YES]; 
    
    //drop a pin on it
    //MKPlacemark *thoughtPin = [[MKPlacemark alloc] initWithCoordinate:thought.currentLocation.coordinate addressDictionary:nil];
    //[thoughtMap addAnnotation:thoughtPin];
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
    thoughtCell.detailTextLabel.text = [NSString stringWithFormat:@"You rated this %@", occurance.initialRating];
    return thoughtCell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"recordAgainSegue"]) {
        //the segue sender is the row on the table, we cast this to get its index
        RecordAgainViewController *recordAgainController = [segue destinationViewController];
        recordAgainController.thought=self.thought;
    }
}



@end
