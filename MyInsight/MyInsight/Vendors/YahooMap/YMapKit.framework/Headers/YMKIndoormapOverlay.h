//
//  YMKWeatherOverlay.h
//
//  Copyright (C) 2014 Yahoo Japan Corporation. All Rights Reserved.
//	

#import <UIKit/UIKit.h>
#import "YMKGeometry.h"
#import "YMKOverlay.h"

enum {
	YMKIndoorMapTypeStandard = 0,
	YMKIndoorMapTypeSilhouette,
};

@interface YMKIndoormapOverlay : NSObject <YMKOverlay> {
    
    
}
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly) YMKMapRect boundingMapRect;
@property (nonatomic, readonly) NSArray* floorList;

- (id)init;

- (BOOL)intersectsMapRect:(YMKMapRect)mapRect;

-(void)addFloorWithIndoorId:(int)indoorId withFloorId:(int)floorId withMapType:(int)mapType;
-(void)removeFloorWithIndoorId:(int)indoorId withFloorId:(int)floorId;
-(void)removeFloorsWithIndoorId:(int)indoorId;
-(void)removeAllFloors;

@end
