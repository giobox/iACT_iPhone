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

@interface AppDelegate : UIResponder <UIApplicationDelegate>

//core data model

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong, nonatomic) User *loggedInUser;

- (void)saveContext;
-(NSURL *)applicationDocumentsDirectory;



@property (strong, nonatomic) Thought *tempThought;





@property (strong, nonatomic) UIWindow *window;


@end
