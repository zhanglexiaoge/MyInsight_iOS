//
//  ARPoint.h
//
//  Copyright (C) 2014 Yahoo Japan Corporation. All Rights Reserved.
//
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>	

@interface ARPoint : NSObject {
	CLLocationCoordinate2D coordinate;
}
+ (ARPoint*) pointWithCoordinate:(CLLocationCoordinate2D) coord;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

@end
