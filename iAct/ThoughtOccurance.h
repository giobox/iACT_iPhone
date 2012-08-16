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

/**
 Class representing thought occurence entities in the CoreData model.
 */
@interface ThoughtOccurance : NSManagedObject

@property (nonatomic, retain) NSDate * date; /**< The date thought is recorded. */
@property (nonatomic, retain) NSNumber * initialRating; /**< The pre-ACT manipulation thought rating. */
@property (nonatomic, retain) NSNumber * latitude; /**< Latitude of thought location. */
@property (nonatomic, retain) NSNumber * longitude; /**< Longitude of thought location. */
@property (nonatomic, retain) NSNumber * postRating; /**< The post-ACT manipulation thought rating. */
@property (nonatomic, retain) Thought *hasThought; /**< Relationship with parent thought entity. */

@end
