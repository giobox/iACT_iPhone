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

/**
 Class representing user entities in the CoreData model.
 */
@interface User : NSManagedObject

@property (nonatomic, retain) NSString * email; /**< User's email address */
@property (nonatomic, retain) NSNumber * id; /**< User's ID number */
@property (nonatomic, retain) NSString * name; /**< User's full name */
@property (nonatomic, retain) NSString * password; /**< User's password */
@property (nonatomic, retain) NSString * remember_token; /**< User's remember token, used for authentication */
@property (nonatomic, retain) NSSet *hasThought; /**< One to many relationship with Thought objects */
@end

@interface User (CoreDataGeneratedAccessors)

- (void)addHasThoughtObject:(Thought *)value;
- (void)removeHasThoughtObject:(Thought *)value;
- (void)addHasThought:(NSSet *)values;
- (void)removeHasThought:(NSSet *)values;

@end
