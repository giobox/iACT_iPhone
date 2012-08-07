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


@interface ACTManipilationViewController : UIViewController <UIGestureRecognizerDelegate>

@property Thought *thought;
@property ThoughtOccurance *occurance;
@property BOOL newThought;
@property  float lastRotation;
@property float lastScale;

@property (nonatomic,weak) IBOutlet UIButton *movingButton;
- (IBAction) btnMoveTo:(id)sender;
- (IBAction)moveToTap:(id)sender;


@property (strong, nonatomic) IBOutlet UILabel *thoughtDescriptionLabel;



@end
