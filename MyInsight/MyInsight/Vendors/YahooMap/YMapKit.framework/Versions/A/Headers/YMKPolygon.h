//
//  YMKPolygon.h
//
//  Copyright (C) 2014 Yahoo Japan Corporation. All Rights Reserved.
//
#import <Foundation/Foundation.h>
#import "YMKMultiPoint.h"
#import "YMKGeometry.h"
#import "YMKOverlay.h"

@interface YMKPolygon : YMKMultiPoint <YMKOverlay> {
}


+ (YMKPolygon *)polygonWithPoints:(YMKMapPoint *)points count:(NSUInteger)count;
+ (YMKPolygon *)polygonWithPoints:(YMKMapPoint *)points count:(NSUInteger)count interiorPolygons:(NSArray *)interiorPolygons;
+ (YMKPolygon *)polygonWithCoordinates:(CLLocationCoordinate2D *)coords count:(NSUInteger)count;
+ (YMKPolygon *)polygonWithCoordinates:(CLLocationCoordinate2D *)coords count:(NSUInteger)count interiorPolygons:(NSArray *)interiorPolygons;

@end
