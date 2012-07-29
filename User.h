//
//  User.h
//  iAct
//
//  Created by Giovanni Paolo Coia on 27/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Thought;

@interface User : NSManagedObject

@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSNumber * id;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSString * remember_token;
@property (nonatomic, retain) NSSet *hasThought;
@end

@interface User (CoreDataGeneratedAccessors)

- (void)addHasThoughtObject:(Thought *)value;
- (void)removeHasThoughtObject:(Thought *)value;
- (void)addHasThought:(NSSet *)values;
- (void)removeHasThought:(NSSet *)values;

@end
