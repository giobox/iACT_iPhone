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
#import "ThoughtOccurance.h"
#import "ACTManipilationViewController.h"

@interface RecordAgainViewController : UIViewController <CLLocationManagerDelegate>
@property (strong, nonatomic) IBOutlet UILabel *thoughtDescriptionLabel;
@property (strong, nonatomic) Thought *thought;
@property (strong, nonatomic) CLLocationManager *locMan;
@property (strong, nonatomic) IBOutlet UISlider *thoughtRatingSlider;
@property (strong, nonatomic) IBOutlet UIButton *saveButton;
@property (strong, nonatomic) IBOutlet UILabel *thoughtRatingLabel;


- (IBAction)thoughtRatingValueChanged:(id)sender;
@end
