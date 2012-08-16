//
//  AppDelegate.h
//  iAct
//
//  Created by Giovanni Paolo Coia on 02/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "Thought.h"

/**
App delegate class. This is a class common to all iOS applications. As it is a singleton class, very useful place to store the model.
 Also contains method for handling application launching and termination, these are used to save/load the CoreData model.
 Additionally it configures the RestKit singleton class so it can be used to transmit and recieve data from iACT website.
 */
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext; /**< CoreData Model. */
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel; /**< CoreData Model. */
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator; /**< CoreData Model. */
@property (strong, nonatomic) User *loggedInUser; /**< Object representing presently logged in user entity from CoreData model. */

- (void)saveContext;
-(NSURL *)applicationDocumentsDirectory;

@property (strong, nonatomic) Thought *tempThought;
@property (strong, nonatomic) UIWindow *window;


@end
