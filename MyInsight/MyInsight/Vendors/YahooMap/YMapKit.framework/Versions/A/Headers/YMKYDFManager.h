//
//  YMKUserLocation.h
//
//  Copyright (C) 2014 Yahoo Japan Corporation. All Rights Reserved.
//
#import <Foundation/Foundation.h>
#import "YMKMapView.h"

@interface YMKYDFManager : NSObject <YMKMapViewDelegate>{
	NSMutableArray* ydfArray;//アイテムリスト
	NSMutableArray* orverlayArray;//アイテムリスト
}

- (id) initWithUrlString:(NSString*)urlString;//初期化
- (id) initWithXmlString:(NSString*)xmlString;//初期化
- (id) initWithJsonString:(NSString*)jsonString;//初期化
- (void) showWithMapView:(YMKMapView*)mapView;//地図上に表示
- (void) removeWithMapView:(YMKMapView*)mapView;

@end


