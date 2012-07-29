//
//  ThoughtOccurance.h
//  iAct
//
//  Created by Giovanni Paolo Coia on 27/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Thought;

@interface ThoughtOccurance : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * initialRating;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSNumber * postRating;
@property (nonatomic, retain) Thought *hasThought;

@end
