//
//  PlaceMark.h
//  iAct
//
// This class provides the annotation pins for the map view
//
//
//
//
//  Created by Giovanni Paolo Coia on 02/08/2012.
//
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

/**
 Class used to construct a placemark for use on the maps. Can display some information at each placemark.
 */
@interface PlaceMark : NSObject <MKAnnotation> {
    CLLocationCoordinate2D coordinate; 
    NSString *markTitle, *markSubTitle; 
}

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate; /**< Coordinate for placemark.  */
@property (nonatomic, retain) NSString *markTitle, *markSubTitle; /**< Strings containing data for display at placemark.  */

-(id)initWithCoordinate:(CLLocationCoordinate2D)theCoordinate andMarkTitle:(NSString *)theMarkTitle andMarkSubTitle:(NSString *)theMarkSubTitle;

@end