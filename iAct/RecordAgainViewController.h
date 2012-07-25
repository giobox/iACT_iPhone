//
//  RecordAgainViewController.h
//  iAct
//
//  Created by Giovanni Paolo Coia on 25/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import <CoreLocation/CoreLocation.h>
#import <RestKit/RestKit.h>

@interface RecordAgainViewController : UIViewController <CLLocationManagerDelegate, RKRequestDelegate>
@property (strong, nonatomic) IBOutlet UILabel *thoughtDescriptionLabel;
@property (strong, nonatomic) ThoughtInstance *thought;
@property (strong, nonatomic) CLLocationManager *locMan;
@property (strong, nonatomic) IBOutlet UISlider *thoughtRatingSlider;

- (IBAction)saveThought:(id)sender;
@end