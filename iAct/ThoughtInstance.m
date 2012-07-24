//
//  ThoughtInstance.m
//  iAct
//
//  Created by Giovanni Paolo Coia on 02/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ThoughtInstance.h"

@implementation ThoughtInstance

@synthesize thoughtDescription;
@synthesize thoughtTime;
@synthesize currentLocation;
@synthesize thoughtRating;

- (void)setThoughtWithName:(NSString *)thoughtName andTime:(NSDate *)time withRating:(float)rating andLocation:(CLLocation *)thoughtLocation {
    
    [self setThoughtDescription:thoughtName];
    [self setThoughtTime:time];
    self.thoughtRating = rating;
    [self setCurrentLocation:thoughtLocation];
    
}

#pragma mark NSCoding protocok methods

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:thoughtDescription forKey:@"thoughtDescription"];
    [aCoder encodeObject:thoughtTime forKey:@"thoughtTime"];
    [aCoder encodeObject:currentLocation forKey:@"thoughtLocation"];
    NSNumber *tempNumber = [[NSNumber alloc] initWithFloat:thoughtRating];
    [aCoder encodeObject:tempNumber forKey:@"thoughtRating"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if(self = [super init]) {
        thoughtDescription = [aDecoder decodeObjectForKey:@"thoughtDescription"];
        thoughtTime = [aDecoder decodeObjectForKey:@"thoughtTime"];
        currentLocation = [aDecoder decodeObjectForKey:@"thoughtLocation"];
        NSNumber *tempNumber = [[NSNumber alloc]init];
        tempNumber = [aDecoder decodeObjectForKey:@"thoughtRating"];
        thoughtRating = tempNumber.floatValue;
    }
    return self;
}


@end
