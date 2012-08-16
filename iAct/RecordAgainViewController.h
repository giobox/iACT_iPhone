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

/**
Record again view controller. Sets up a thought for recording a new occurence from the thought history screen.
 */
@interface RecordAgainViewController : UIViewController <CLLocationManagerDelegate>

@property (strong, nonatomic) IBOutlet UILabel *thoughtDescriptionLabel; /**< Label containing thought description.  */
@property (strong, nonatomic) Thought *thought; /**< The thought having a new occurence recorded.  */
@property (strong, nonatomic) CLLocationManager *locMan; /**< Location manager to record GPS position of occurence.  */
@property (strong, nonatomic) IBOutlet UISlider *thoughtRatingSlider; /**< Rating slider for intial thought rating.  */
@property (strong, nonatomic) IBOutlet UIButton *saveButton; /**< Button to trigger segue to manipulation screen.  */
@property (strong, nonatomic) IBOutlet UILabel *thoughtRatingLabel; /**< Label displaying the thought's rating.  */


- (IBAction)thoughtRatingValueChanged:(id)sender;
@end
