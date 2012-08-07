//
//  ThoughtInstance.h
//  iAct
//
//  Created by Giovanni Paolo Coia on 02/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface ThoughtInstance : NSObject <NSCoding>

@property (strong, nonatomic) NSString *thoughtDescription;
@property (strong, nonatomic) NSDate *thoughtTime;
@property float thoughtRating;
@property (strong, nonatomic) CLLocation *currentLocation;



-(NSInteger)getInstanceCount;
- (void)setThoughtWithName:(NSString *)thoughtName andTime:(NSDate *)time withRating:(float)rating andLocation:(CLLocation *)thoughtLocation;
- (void)addInstanceOfThoughtWithTime:(NSDate *)time withRating:(float)rating andLocation:(CLLocation *)thoughtLocation;

@end
