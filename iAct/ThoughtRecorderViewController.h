//
//  ThoughtRecorderViewController.h
//  iAct
//
//  Created by Giovanni Paolo Coia on 02/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
//need core location for GPS fix
#import <CoreLocation/CoreLocation.h>
#import "AppDelegate.h"
#import <RestKit/RestKit.h>

#import "ThoughtDisplayViewController.h"

@interface ThoughtRecorderViewController : UIViewController <CLLocationManagerDelegate, RKRequestDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (strong, nonatomic) IBOutlet UITextField *thoughtDescription;
@property (strong, nonatomic) IBOutlet UISlider *thoughtRatingSlider;
@property (strong, nonatomic) IBOutlet UILabel *thoughtRating;
@property (strong, nonatomic) IBOutlet UIButton *recordThoughtButton;
@property (strong, nonatomic) CLLocationManager *locMan;
//recent location

- (IBAction)hideKeyboard:(id)sender;
- (IBAction)userChangedThoughtRating:(id)sender;
- (IBAction)recordThought:(id)sender;

@end
