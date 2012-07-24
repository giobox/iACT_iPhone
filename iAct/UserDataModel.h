//
//  UserDataModel.h
//  iAct
//
//  Created by Giovanni Paolo Coia on 02/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ThoughtInstance.h"

@interface UserDataModel : NSObject <NSCoding>




- (void)addThought:(ThoughtInstance *)thought;
- (int)getThoughtCount;
- (ThoughtInstance *)getThought:(int)thoughtIndex;
- (void)saveModelToDisk;
- (void)loadModelFromDisk;
- (void)deleteModelFromDisk;

@end
