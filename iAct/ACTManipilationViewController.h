//
//  ACTManipilationViewController.h
//  iAct
//
//  Created by Giovanni Paolo Coia on 05/08/2012.
//
//

#import <UIKit/UIKit.h>
#import "Thought.h"
#import "ThoughtOccurance.h"
#import "PostRatingViewController.h"
#import "UIView+Animation.h"

/**
 Controller for the ACT manipulation view.
 */
@interface ACTManipilationViewController : UIViewController <UIGestureRecognizerDelegate>

@property Thought *thought; /**< Thought being manipulated. This is passed by previous view's prepareForSegue method */
@property ThoughtOccurance *occurance; /**< Occurance ofhought being manipulated. This is passed by previous view's prepareForSegue method */
@property BOOL newThought; /**< Boolean indicating that this is a new thought, and not a new occurence. This informs next whether to create a new thought entity or new thought occurence entity. */
@property  float lastRotation; /**< Float value used to store rotation amount */
@property float lastScale; /**< Float value used to store scaling amount  */

@property (nonatomic,weak) IBOutlet UIButton *movingButton;
- (IBAction) btnMoveTo:(id)sender;
- (IBAction)moveToTap:(id)sender;

@property (strong, nonatomic) IBOutlet UILabel *thoughtDescriptionLabel; /**< Label containing the thought description for manipulation  */

@end
