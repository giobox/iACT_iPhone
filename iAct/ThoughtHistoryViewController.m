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

@property (strong, nonatomic) AppDelegate *sharedData;
@property (strong, nonatomic) ThoughtDisplayViewController *thoughtDisplay;
@property (strong, nonatomic) ThoughtInstance *chosenThought;
@end

@implementation ThoughtHistoryViewController

@synthesize sharedData;
@synthesize chosenThought;
@synthesize thoughtDisplay;

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
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [self setSharedData:nil];
    [self setChosenThought:nil];
    [self setThoughtDisplay:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}	

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma protocol methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return kSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    switch (section) {
        case kNewThoughtSection:
            return 1;
        case kHistoricalThoughtSection:
            return [[self.sharedData getUserDataModel] getThoughtCount];
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
            thoughtCell.textLabel.text=[[self.sharedData getUserDataModel] getThought:indexPath.row].thoughtDescription;
            
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
    chosenThought = [[self.sharedData getUserDataModel] getThought:indexPath.row];
    //stick the chosen cell in the communal data store, so that next view knows about it
    //sharedData.tempThought = [[ThoughtInstance alloc] init];
    sharedData.tempThought = chosenThought;
    }
}




@end
