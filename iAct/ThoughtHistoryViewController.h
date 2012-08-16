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
#import <RestKit/CoreData.h>

/**
Class displays a UITable of all previously recorded thoughts. Also facilites refreshing the thought history with new thoughts added
 by service user's therapist.
 */
@interface ThoughtHistoryViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, PullToRefreshViewDelegate, RKRequestDelegate>

- (IBAction)editThoughtList:(UIBarButtonItem *)sender;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *editButton; /**< Edit thought history button  */

@end
