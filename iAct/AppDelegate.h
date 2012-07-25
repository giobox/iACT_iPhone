//
//  AppDelegate.h
//  iAct
//
//  Created by Giovanni Paolo Coia on 02/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserDataModel.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UserDataModel *model;

@property (strong, nonatomic) ThoughtInstance *tempThought;

@property (strong, nonatomic) UIWindow *window;

- (UserDataModel *)getUserDataModel;
- (void)loadModelFromDisk;
- (void)saveModelToDisk;
- (void)resetIACT;

@end
