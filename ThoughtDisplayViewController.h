//
//  ThoughtDisplayViewController.h
//  iAct
//
//  Created by Giovanni Paolo Coia on 02/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ThoughtInstance.h"
#import <MapKit/MapKit.h>

@interface ThoughtDisplayViewController : UIViewController


@property (strong, nonatomic) IBOutlet UITextView *thoughtTextDisplay;
@property (strong, nonatomic) IBOutlet UILabel *thoughtRatingDisplay;
@property (strong, nonatomic) IBOutlet MKMapView *thoughtLocationDisplay;



@property (strong, nonatomic) ThoughtInstance *thought;



- (IBAction)finishViewing:(id)sender;

@end
