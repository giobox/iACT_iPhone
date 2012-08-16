//
//  OccuranceDetailViewController.h
//  iAct
//
//  Created by Giovanni Paolo Coia on 06/08/2012.
//
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "PlaceMark.h"
#import "ThoughtOccurance.h"
#import "Thought.h"

/**
This class controls a view displaying details of an idividual thought occurrence.
 */
@interface OccuranceDetailViewController : UIViewController

@property (strong, nonatomic) Thought *thought; /**< Thought to which the occurence belongs.  */
@property (strong, nonatomic) ThoughtOccurance *occurance; /**< occurence being displayed.  */
@property (strong, nonatomic) IBOutlet MKMapView *ThoughtOccuranceMap; /**< Map displaying the occurence. */
@property (strong, nonatomic) IBOutlet UILabel *thoughtDescriptionLabel; /**< Label with thought content. */
@property (strong, nonatomic) IBOutlet UILabel *thoughtRatingLabel; /**< Label displaying thought rating. */

@end
