//
//  NavigationMgr.h
//
//  Copyright (C) 2014 Yahoo Japan Corporation. All Rights Reserved.
//
#import <Foundation/Foundation.h>
#import "DeviceState.h"
#import "POI.h"

@protocol NavigationMgrDelegate
- (void) NavigationMgrUpdated;
@end


@interface NavigationMgr : NSObject <DeviceStateDelegate> {
	//現在位置
	double lat;			//緯度
	double lon;			//経度
	double alt;			//高度
	float acc;				//精度
	
	//POI
	NSMutableArray* poiList;
	int destIndex;			//目的地のインデックス
	
	//目的地
	double destLat;
	double destLon;
	double dist;
	double angle;
	
	DeviceState* ds;
	id<NavigationMgrDelegate> delegate;
}
@property (nonatomic, retain) id<NavigationMgrDelegate> delegate;
@property (nonatomic,readonly) double lat;
@property (nonatomic,readonly) double lon;
@property (nonatomic,readonly) double alt;
@property (nonatomic,readonly) float acc;
- (void) setGpsValue:(CLLocation*)loc;
@property (nonatomic,readonly) double dist;
@property (nonatomic,readonly) double angle;
@property (nonatomic,readonly) float inclination;
@property (nonatomic,readonly) float azimuth;
- (int) addPOI:(double) lat :(double) lon :(UIImage*) icon :(int) x :(int) y;
- (void) removePOI:(int) index;
- (void) clearPOI;
- (void) setDestination:(int) index;
- (int) getDestination;
- (NSArray*) getPoiList;
- (double) calcAngle:(double)destinationLat :(double)destinationLon :(double)dist;
- (double) calcDist:(double)destinationLat :(double)destinationLon;

@end
