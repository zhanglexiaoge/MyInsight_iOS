//
//  SubmapView.h
//
//  Copyright (C) 2014 Yahoo Japan Corporation. All Rights Reserved.
//
#import <UIKit/UIKit.h>
#import "NavigationMgr.h"
#import "GpsAnnotation.h"
#import "YMKMapView.h"

@interface SubmapView : YMKMapView {
	NavigationMgr* nm;
	
	//ルート
	YMKPolyline* route;
	
	//アイコン
	GpsAnnotation* gpsAnnotation;
	
	UIImageView* gpsIcon;
}
@property (nonatomic, retain) NavigationMgr* nm;
- (void) updateLocation;
- (void)updateLocationRotate;
- (void) makeRoute:(CLLocationCoordinate2D*)coords Count:(int)count;

@end
