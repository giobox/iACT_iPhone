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
#import "PlaceMark.h"
#import "OccuranceDetailViewController.h"

/**
 Class which displays a view containing details of a selected thought
 */
@interface ThoughtDetailViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) IBOutlet MKMapView *thoughtMap; /**< Map of thought occurence locations  */
@property (strong, nonatomic) IBOutlet UITextView *thoughtDescription; /**< Text output displaying thought description  */
@property (strong, nonatomic) IBOutlet UITableView *thoughtOccuranceTable; /**< Table displaying history of all occurences of this thought  */
@property (strong, nonatomic) Thought *thought; /**< Thought object being shown  */

@property (strong, nonatomic) IBOutlet UIButton *recordAgainButton; /**< Button to trigger new occurence of this thought  */

-(void)getInstances;
@end
