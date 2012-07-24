//
//  ThoughtDetailViewController.h
//  iAct
//
//  Created by Giovanni Paolo Coia on 03/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#import "ThoughtInstance.h"
#import "ThoughtHistoryViewController.h"
#import <MapKit/MapKit.h>
#import "AppDelegate.h"

@interface ThoughtDetailViewController : UIViewController

@property (strong, nonatomic) IBOutlet MKMapView *thoughtMap;
@property (strong, nonatomic) IBOutlet UITextView *thoughtDescription;
@property (strong, nonatomic) IBOutlet UILabel *thoughtRating;

@property (strong, nonatomic) ThoughtInstance *thought;


@end
