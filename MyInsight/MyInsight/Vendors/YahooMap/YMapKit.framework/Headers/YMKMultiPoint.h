//
//  YMKMultiPoint.h
//
//  Copyright (C) 2014 Yahoo Japan Corporation. All Rights Reserved.
//
#import <Foundation/Foundation.h>
#import "YMKGeometry.h"
#import "YMKShape.h"

@interface YMKMultiPoint : YMKShape {
@protected
	NSUInteger pointCount;
	YMKMapPoint *_points;
		
	CLLocationCoordinate2D *_coordinates;		//緯度経度配列
	NSUInteger coordsCount;
}

@property (nonatomic, readonly) NSUInteger pointCount;
@property (nonatomic, readonly) YMKMapPoint *points;
@property (nonatomic, readonly) CLLocationCoordinate2D *coordinates;
@property (nonatomic, readonly) NSUInteger coordsCount;

- (void)getCoordinates:(CLLocationCoordinate2D *)coords range:(NSRange)range;
- (void)setCoordinates:(CLLocationCoordinate2D *)coords count:(NSUInteger)count;
- (void)setPoints:(YMKMapPoint *)points count:(NSUInteger)count;
- (void)addCoordinate:(CLLocationCoordinate2D)coord;

@end
