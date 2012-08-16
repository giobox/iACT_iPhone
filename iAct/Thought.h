//
//  Thought.h
//  iAct
//
//  Created by Giovanni Paolo Coia on 27/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@class ThoughtOccurance, User;

/**
 Class representing thought entities in the CoreData model.
 */
@interface Thought : NSManagedObject

@property (nonatomic, retain) NSString * content; /**< The thought content */
@property (nonatomic, retain) NSSet *hasOccurance; /**< One to many relationship with thought occurence */
@property (nonatomic, retain) User *hasUser; /**< Relationship with parent user entity. */
@end

@interface Thought (CoreDataGeneratedAccessors)

- (void)addHasOccuranceObject:(ThoughtOccurance *)value;
- (void)removeHasOccuranceObject:(ThoughtOccurance *)value;
- (void)addHasOccurance:(NSSet *)values;
- (void)removeHasOccurance:(NSSet *)values;

@end
