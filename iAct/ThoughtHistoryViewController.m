//
//  ThoughtHistoryViewController.m
//  iAct
//
//  Created by Giovanni Paolo Coia on 02/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ThoughtHistoryViewController.h"


#define kSectionCount 2
#define kNewThoughtSection 0
#define kHistoricalThoughtSection 1

@interface ThoughtHistoryViewController ()

@property (strong, nonatomic) NSMutableArray *thoughtArray;
@property (strong, nonatomic) AppDelegate *sharedData;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) Thought *thought;

@property (nonatomic) BOOL editing;


@end

@implementation ThoughtHistoryViewController
{
    PullToRefreshView *pull;
}

@synthesize editButton;
@synthesize editing;

@synthesize sharedData;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize fetchedResultsController = __fetchedResultsController;
@synthesize thoughtArray;
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
    //when view loads point to the model so we can start getting some data
    sharedData = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.managedObjectContext = sharedData.managedObjectContext;
    [self getThoughtData];
    //setup pull to refresh
    
    pull = [[PullToRefreshView alloc] initWithScrollView:(UIScrollView *) self.tableView];
    [pull setDelegate:self];
    [self.tableView addSubview:pull];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setSharedData:nil];
    [self setManagedObjectContext:nil];
    [self setFetchedResultsController:nil];
    [self setThoughtArray:nil];
    [self setThought:nil];
    [self setEditButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}	

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)getThoughtData
{
    NSError *error = nil;
    // 1 - Decide what Entity you want
    NSString *entityName = @"Thought"; // Put your entity name here
    NSLog(@"Setting up a Fetched Results Controller for the Entity named %@", entityName);
    
    // 2 - Request that Entity
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    
    // 3 - Filter it if you want
    [request setPredicate:[NSPredicate predicateWithFormat:@"hasUser == %@", sharedData.loggedInUser]];
    
    // 4 - Sort it if you want
    //request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name"
    //                                                                               ascending:YES
    //                                                                              selector:@selector(localizedCaseInsensitiveCompare:)]];
    
    // 5 - Fetch it
    
    NSArray *tempArray = [self.managedObjectContext executeFetchRequest:request error:&error];
    thoughtArray = [NSMutableArray arrayWithArray:tempArray];
    NSLog(@"the number of thoughts is %d", [thoughtArray count]);
}




#pragma mark - protocol methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return kSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch (section) {
        case kNewThoughtSection:
            return 1;
        case kHistoricalThoughtSection:
            return [thoughtArray count];
        default:
            return 0;
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    switch (section) {
        case kNewThoughtSection:
            return @"New Thoughts";
        case kHistoricalThoughtSection:
            return @"Previous Thoughts";
        default:
            return @"Unknown";
    }
}

//MAKE SOME CELLS
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //define the two cell types
    UITableViewCell *newThoughtCell = [tableView dequeueReusableCellWithIdentifier:@"recordThought"];
    UITableViewCell *thoughtCell = [tableView dequeueReusableCellWithIdentifier:@"thoughtListing"];
    
    switch (indexPath.section) {
        case kNewThoughtSection:
            newThoughtCell.textLabel.text=@"Record a New Thought...";
            
            return newThoughtCell;
        case kHistoricalThoughtSection:
        {
            Thought *tableThought = [thoughtArray objectAtIndex:indexPath.row];
            thoughtCell.textLabel.text=tableThought.content;
        }
            break;
        default:
            thoughtCell.textLabel.text=@"Unknown";
    }
    
    return thoughtCell;
}

//what to do when a cell is chosen!
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //if user chose a cell in the first section do nothing, as the segue will always trigger anyway
    //get the chosen thought and pass to the display window
    if(indexPath.section!=0) {
        //stick the chosen cell in the communal data store, so that next view knows about it
        //sharedData.tempThought = [[ThoughtInstance alloc] init];
        thought = [thoughtArray objectAtIndex:indexPath.row];
        sharedData.tempThought = thought;
    }
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[ segue identifier] isEqualToString:@"occuranceSegue"]) {
        //the segue sender is the row on the table, we cast this to get its index
        UITableViewCell *cell = (UITableViewCell*)sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        
        ThoughtDetailViewController *detailViewController = [segue destinationViewController];
        detailViewController.thought = [thoughtArray objectAtIndex:indexPath.row];
    }
}

#pragma mark - thought deletion

//this method disables deletion button on the create thought button!
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case kNewThoughtSection:
            return UITableViewCellEditingStyleNone;
            
        case kHistoricalThoughtSection:
            return UITableViewCellEditingStyleDelete;
    }
    return UITableViewCellEditingStyleDelete;
}

- (IBAction)editThoughtList:(UIBarButtonItem *)sender {
    if (!editing) {
        [sender setTitle:@"Done"];
        [self.tableView setEditing:YES animated:YES];
        editing = TRUE;
    } else {
        [sender setTitle:@"Edit"];
        [self.tableView setEditing:NO animated:YES];
        editing = FALSE;
    }
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //get the thought and remove it from the model
        Thought *thoughtToDelete = [thoughtArray objectAtIndex:indexPath.row];
        [self.managedObjectContext deleteObject:thoughtToDelete];
        [self.managedObjectContext save:nil];
        
        //remove from the display array and refresh
        [thoughtArray removeObjectAtIndex:indexPath.row];
        [self.tableView reloadData];
    }
}

#pragma mark - pull to refresh


- (void)pullToRefreshViewShouldRefresh:(PullToRefreshView *)view;
{
    //launch as background thread
    [self performSelectorInBackground:@selector(getNewThoughtData) withObject:nil];
}


-(void) getNewThoughtData
{
    
    [self.tableView reloadData];
    [pull finishedLoading];
}

- (void)dealloc {
    [pull removeFromSuperview];
}

@end
