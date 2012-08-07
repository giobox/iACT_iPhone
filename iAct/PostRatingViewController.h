//
//  PostRatingViewController.h
//  iAct
//
//  Created by Giovanni Paolo Coia on 05/08/2012.
//
//

#import <UIKit/UIKit.h>
#import "Thought.h"
#import "ThoughtOccurance.h"
#import <RestKit/RestKit.h>
#import "AppDelegate.h"

@interface PostRatingViewController : UIViewController <RKRequestDelegate>

@property Thought *thought;
@property ThoughtOccurance *occurance;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property BOOL newThought;
@property (strong, nonatomic) IBOutlet UISlider *secondRatingSlider;
@property (strong, nonatomic) IBOutlet UIButton *doneButton;
@property (strong, nonatomic) IBOutlet UILabel *thoughtRatingLabel;

- (IBAction)finishedRating:(id)sender;
- (IBAction)userChangedThoughtRating:(id)sender;

@end
