//
//  ThoughtDetailViewController.h
//  iAct
//
//  Created by Giovanni Paolo Coia on 03/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#import "ThoughtHistoryViewController.h"
#import "RecordAgainViewController.h"
#import <MapKit/MapKit.h>
#import "AppDelegate.h"
#import "Thought.h"
#import "ThoughtOccurance.h"

@interface ThoughtDetailViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet MKMapView *thoughtMap;
@property (strong, nonatomic) IBOutlet UITextView *thoughtDescription;
@property (strong, nonatomic) IBOutlet UITableView *thoughtOccuranceTable;
@property (strong, nonatomic) Thought *thought;


-(void)getInstances;
@end
