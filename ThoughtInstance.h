//
//  ThoughtInstance.h
//  iAct
//
//  Created by Giovanni Paolo Coia on 26/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Thought;

@interface ThoughtInstance : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSNumber * initialRating;
@property (nonatomic, retain) NSNumber * postRating;
@property (nonatomic, retain) Thought *relationship;

@end
