//
//  ThoughtDisplayViewController.h
//  iAct
//
//  Created by Giovanni Paolo Coia on 02/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "Thought.h"
#import "ThoughtOccurance.h"

@interface ThoughtDisplayViewController : UIViewController


@property (strong, nonatomic) IBOutlet UITextView *thoughtTextDisplay;
@property (strong, nonatomic) IBOutlet UILabel *thoughtRatingDisplay;
@property (strong, nonatomic) IBOutlet MKMapView *thoughtLocationDisplay;

//This is passed both the thought and its newly recorded occurance
@property (strong, nonatomic) Thought *thought;
@property (strong, nonatomic) ThoughtOccurance *occurance;


- (IBAction)finishViewing:(id)sender;

@end
