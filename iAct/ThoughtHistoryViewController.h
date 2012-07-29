//
//  ThoughtHistoryViewController.h
//  iAct
//
//  Created by Giovanni Paolo Coia on 02/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "ThoughtDetailViewController.h"
#import "Thought.h"
#import "PullToRefreshView.h"


@interface ThoughtHistoryViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, PullToRefreshViewDelegate>

- (IBAction)editThoughtList:(UIBarButtonItem *)sender;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *editButton;

@end
