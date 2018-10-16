//
//  YMKCircle.h
//
//  Copyright (C) 2014 Yahoo Japan Corporation. All Rights Reserved.
//
#import <Foundation/Foundation.h>
#import "YMKShape.h"
#import "YMKGeometry.h"
#import "YMKOverlay.h"

@class LLPoint;
@interface YMKCircle : YMKShape <YMKOverlay>{
}

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly) CLLocationDistance radius;
@property (nonatomic, readonly) YMKMapRect boundingMapRect;

@property (nonatomic, readonly) YMKMapPoint center_point;
@property (nonatomic, readonly) double pixel_radius;

+ (YMKCircle *)circleWithCenterCoordinate:(CLLocationCoordinate2D)coord radius:(CLLocationDistance)radius;
+ (YMKCircle *)circleWithMapRect:(YMKMapRect)mapRect;

@end
