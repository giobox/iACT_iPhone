//
//  ThoughtInstance.m
//  iAct
//
//  Created by Giovanni Paolo Coia on 02/07/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ThoughtInstance.h"
@interface ThoughtInstance ()

@property (strong, nonatomic) NSMutableArray *instanceArray;

@end



@implementation ThoughtInstance


@synthesize thoughtDescription;
@synthesize thoughtTime;
@synthesize currentLocation;
@synthesize thoughtRating;

//Need to store repeat occurances of this thought
@synthesize instanceArray = _instanceArray;

-(NSMutableArray *)instanceArray
{
if (_instanceArray == nil) _instanceArray = [[NSMutableArray alloc] init]; //lazy instantiation
return _instanceArray;
}

-(void)addThoughtInstance:(NSDictionary *)instanceParam {
    [self.instanceArray addObject:instanceParam];
}


- (void)setThoughtWithName:(NSString *)thoughtName andTime:(NSDate *)time withRating:(float)rating andLocation:(CLLocation *)thoughtLocation {
    
    [self setThoughtDescription:thoughtName];
    [self setThoughtTime:time];
    self.thoughtRating = rating;
    [self setCurrentLocation:thoughtLocation];
    NSDictionary *instanceParams = [[NSDictionary alloc]initWithObjectsAndKeys:time, @"time", rating, @"rating", thoughtLocation, @"location", nil];
    //initialise and then add first instance to instance array
    [self addThoughtInstance:instanceParams];
    
    
}

- (void)addInstanceOfThoughtWithTime:(NSDate *)instanceTime withRating:(float)instanceRating andLocation:(CLLocation *)instanceLocation {
    NSDictionary *instanceParams = [[NSDictionary alloc]initWithObjectsAndKeys:instanceTime, @"time", instanceRating, @"rating", instanceLocation, @"location", nil];
    [self addThoughtInstance:instanceParams];
}

-(NSInteger)getInstanceCount {
    return self.instanceArray.count;
}

#pragma mark - NSCoding protocol methods

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:thoughtDescription forKey:@"thoughtDescription"];
    [aCoder encodeObject:thoughtTime forKey:@"thoughtTime"];
    [aCoder encodeObject:currentLocation forKey:@"thoughtLocation"];
    NSNumber *tempNumber = [[NSNumber alloc] initWithFloat:thoughtRating];
    [aCoder encodeObject:tempNumber forKey:@"thoughtRating"];
    [aCoder encodeObject:_instanceArray forKey:@"instanceArray"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if(self = [super init]) {
        thoughtDescription = [aDecoder decodeObjectForKey:@"thoughtDescription"];
        thoughtTime = [aDecoder decodeObjectForKey:@"thoughtTime"];
        currentLocation = [aDecoder decodeObjectForKey:@"thoughtLocation"];
        NSNumber *tempNumber = [[NSNumber alloc]init];
        tempNumber = [aDecoder decodeObjectForKey:@"thoughtRating"];
        thoughtRating = tempNumber.floatValue;
        _instanceArray = [aDecoder decodeObjectForKey:@"instanceArray"];
    }
    return self;
}


@end
