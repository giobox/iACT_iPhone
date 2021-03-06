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

@property (strong, nonatomic) NSMutableArray *thoughtArray; /**< Array of thoughts retrieved from CoreData model. */
@property (strong, nonatomic) AppDelegate *sharedData; /**< App delegate class containing the CoreData model. */
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext; /**< CoreData model.  */
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController; /**< CoreData model.  */
@property (strong, nonatomic) Thought *thought; /**< Selected thought. */
@property (strong, nonatomic) PullToRefreshView *pull; /**< Pull to refresh functionality.  */
@property (nonatomic) BOOL editing; /**< Boolean indicating whether history editing is in progress */

@end

@implementation ThoughtHistoryViewController

@synthesize editButton;
@synthesize editing;
@synthesize pull;
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
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    //setup pull to refresh
    pull = [[PullToRefreshView alloc] initWithScrollView:(UIScrollView *) self.tableView];
    [pull setDelegate:self];
    [self.tableView addSubview:pull];
}

-(void) viewDidDisappear:(BOOL)animated {
    [pull removeFromSuperview];
    //need the dealloc method on Pull to trigger- overwise KVO is left watching a table that isn't there anymore and causes memory
    //addressing fault.
    [self setPull:nil];
}

- (void)viewDidUnload
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [pull removeFromSuperview];
    [self setSharedData:nil];
    [self setManagedObjectContext:nil];
    [self setFetchedResultsController:nil];
    [self setThoughtArray:nil];
    [self setThought:nil];
    [self setEditButton:nil];
    [self setPull:nil];
    
    [super viewDidUnload];
}	

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

/**
 Method returns gets all user's thoughts to populate table with.
 */
- (void)getThoughtData
{
    NSError *error = nil;
    // 1 Decide what Entity you want
    NSString *entityName = @"Thought"; // Put your entity name here
    
    // 2 Request that Entity
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:entityName];
    
    // 3 Filter it
    [request setPredicate:[NSPredicate predicateWithFormat:@"hasUser == %@", sharedData.loggedInUser]];
    
    // 4 Fetch it
    
    NSArray *tempArray = [self.managedObjectContext executeFetchRequest:request error:&error];
    thoughtArray = [NSMutableArray arrayWithArray:tempArray];
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
       NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *userID = [userDefaults objectForKey:@"ID"];
        
        NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys: userID, @"id", thoughtToDelete.content ,@"content" , nil];
        [[RKClient sharedClient] post:@"/deletethought" params:params delegate:self];
        
        
        [self.managedObjectContext deleteObject:thoughtToDelete];
        [self.managedObjectContext save:nil];
        
        //remove from the display array and refresh
        [thoughtArray removeObjectAtIndex:indexPath.row];
        [self.tableView reloadData];
    }
}

#pragma mark - pull to refresh

/**
 Called when user pulls to refresh. Triggers syncing of new thoughts.
 */
- (void)pullToRefreshViewShouldRefresh:(PullToRefreshView *)view;
{
    //launch as background thread
    [self performSelectorInBackground:@selector(getNewThoughtData) withObject:nil];
}

/**
 Helper method to obtain new thoughts from iACT website using restkit.
 */
-(void) getNewThoughtData
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *userID = [userDefaults objectForKey:@"ID"];
    
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:userID ,@"id" , nil];
    [[RKClient sharedClient] post:@"/getthoughts" params:params delegate:self];
}






- (void)dealloc {
    [pull removeFromSuperview];
}
 

//this method listens for the server response - handled because we set the delegate to self
/**
 Method waits for response from pull to refresh request, updates table when response arrives and dismisses pull to refresh indicator.
 */
- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if ([response statusCode]==403) {
        NSLog(@"log in failed");
        //Display login failure dialog
        [userDefaults setBool:NO forKey:@"loginStatus"];
        UIAlertView *incorrectPasswordDialog;
        incorrectPasswordDialog = [[UIAlertView alloc] initWithTitle:@"Incorrect Details"
                                                             message:@"You entered your email address or password incorrectly, please try again"
                                                            delegate:nil
                                                   cancelButtonTitle:@"Ok"
                                                   otherButtonTitles: nil];
        [incorrectPasswordDialog show];
    }
    
    
    if ([request isPOST]) {
        NSLog(@"server response: %@", [response bodyAsString]);
        // Handling POST /other.json
        if ([response isJSON]) {
            NSLog(@"Got a JSON response back from our thought HISTORY POST!:");
            NSError *error;
            //get raw json
            NSString *jsonString = [response bodyAsString];
            //parse it
            NSData *jsonData = [jsonString dataUsingEncoding:NSASCIIStringEncoding];
            NSArray *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                     options:kNilOptions
                                                                       error:&error];
            
           //itterate through the new thoughts and add them!
            for(int x=0;x<jsonDict.count;x++) {
                NSLog(@"The thought is %@", [[jsonDict objectAtIndex:x] objectForKey:@"content"]);
                NSString *content = [[jsonDict objectAtIndex:x] objectForKey:@"content"];
                Thought *newthought = [NSEntityDescription insertNewObjectForEntityForName:@"Thought" inManagedObjectContext:self.managedObjectContext];
                
                newthought.content=content;
                newthought.hasUser=sharedData.loggedInUser;
                [sharedData.loggedInUser addHasThoughtObject:newthought];
            }
            [self.managedObjectContext save:nil];
            [self getThoughtData];
            [self.tableView reloadData];
            [pull finishedLoading];
        }
    }
}


//Pull to refresh occasionally throwing an unhandled exception - Not one I need to worry about, this method stub listens for it and
//doe nothing with it.
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
}

@end
