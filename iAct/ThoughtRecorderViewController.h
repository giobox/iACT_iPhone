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
#import "ACTManipilationViewController.h"

/**
 Class to display the intial thought recording view.
 */
@interface ThoughtRecorderViewController : UIViewController <CLLocationManagerDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext; /**< CoreData model.  */

@property (strong, nonatomic) IBOutlet UITextField *thoughtDescription; /**< Text entry field for thought description.  */
@property (strong, nonatomic) IBOutlet UISlider *thoughtRatingSlider; /**< Rating slider for intial thought rating.  */
@property (strong, nonatomic) IBOutlet UILabel *thoughtRating; /**< Label displaying presently selected rating.  */
@property (strong, nonatomic) IBOutlet UIButton *recordThoughtButton; /**< Button to segue to manipulation screen.  */
@property (strong, nonatomic) CLLocationManager *locMan; /**< Location manager to record GPS position of thought.  */
@property BOOL newThought; /**< Boolean indicating that this is a new thought, and not a new occurence. This informs next whether to create a new thought entity or new thought occurence entity. */

- (IBAction)hideKeyboard:(id)sender;
- (IBAction)userChangedThoughtRating:(id)sender;
- (IBAction)recordThought:(id)sender;

@end
