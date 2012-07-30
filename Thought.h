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

@interface Thought : NSManagedObject

@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSSet *hasOccurance;
@property (nonatomic, retain) User *hasUser;
@end

@interface Thought (CoreDataGeneratedAccessors)

- (void)addHasOccuranceObject:(ThoughtOccurance *)value;
- (void)removeHasOccuranceObject:(ThoughtOccurance *)value;
- (void)addHasOccurance:(NSSet *)values;
- (void)removeHasOccurance:(NSSet *)values;

@end
