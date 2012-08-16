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

/**
 Controller for the final thought rating view. Saves comepleted thought and occurence to the CoreData model and submits to 
 iACT website using restKit.
 */
@interface PostRatingViewController : UIViewController <RKRequestDelegate>

@property Thought *thought; /**< Thought being manipulated. This is passed by previous view's prepareForSegue method */
@property ThoughtOccurance *occurance; /**< Occurance ofhought being manipulated. This is passed by previous view's prepareForSegue method */
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property BOOL newThought; /**< Boolean indicating that this is a new thought, and not a new occurence. This informs next whether to create a new thought entity or new thought occurence entity. */
@property (strong, nonatomic) IBOutlet UISlider *secondRatingSlider; /**< Slider to input second thought rating.  */
@property (strong, nonatomic) IBOutlet UIButton *doneButton; /**< Button to finish thought. Saves all data to model. */
@property (strong, nonatomic) IBOutlet UILabel *thoughtRatingLabel; /**< Label displaying presently entered rating.  */

- (IBAction)finishedRating:(id)sender;
- (IBAction)userChangedThoughtRating:(id)sender;

@end
