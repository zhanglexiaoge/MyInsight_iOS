//
//  YMKPolyline.h
//
//  Copyright (C) 2014 Yahoo Japan Corporation. All Rights Reserved.
//
#import <Foundation/Foundation.h>
#import "YMKMultiPoint.h"
#import "YMKGeometry.h"
#import "YMKOverlay.h"

@interface YMKPolyline : YMKMultiPoint <YMKOverlay> {
}

+ (YMKPolyline*)polylineWithPoints:(YMKMapPoint *)points count:(NSUInteger)count;
+ (YMKPolyline*)polylineWithCoordinates:(CLLocationCoordinate2D *)coords count:(NSUInteger)count;

@end