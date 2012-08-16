//
//  PlaceMark.m
//  iAct
//
//  Created by Giovanni Paolo Coia on 02/08/2012.
//
//

#import "PlaceMark.h"

@implementation PlaceMark
@synthesize coordinate;
@synthesize markTitle, markSubTitle;

/**
 Constructs and returns a placemark object for use on a map.
 @param theCoordinate Coordinates of placemark
 @param theMarkTitle Title of placemark
 @param theMarkSubTitle Subtitle of placemark
 @return id PlaceMark object
 */
-(id)initWithCoordinate:(CLLocationCoordinate2D)theCoordinate andMarkTitle:(NSString *)theMarkTitle andMarkSubTitle:(NSString *)theMarkSubTitle {
	coordinate = theCoordinate;
    markTitle = theMarkTitle;
    markSubTitle = theMarkSubTitle;
	return self;
}

/**
Getter method for placemark title.
 @return NSString Placemark title.
 */
- (NSString *)title {
    return markTitle;
}

/**
 Getter method for placemark subtitle.
 @return NSString Placemark subtitle.
 */- (NSString *)subtitle {
    return markSubTitle;
}

@end