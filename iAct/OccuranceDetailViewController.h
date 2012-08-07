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

@interface OccuranceDetailViewController : UIViewController

@property (strong, nonatomic) Thought *thought;
@property (strong, nonatomic) ThoughtOccurance *occurance;


@property (strong, nonatomic) IBOutlet MKMapView *ThoughtOccuranceMap;
@property (strong, nonatomic) IBOutlet UILabel *thoughtDescriptionLabel;
@property (strong, nonatomic) IBOutlet UILabel *thoughtRatingLabel;

@end
