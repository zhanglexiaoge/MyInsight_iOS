//
//  MKPolylineView.h
//
//  Copyright (C) 2014 Yahoo Japan Corporation. All Rights Reserved.
//
#import <UIKit/UIKit.h>
#import "YMKPolyline.h"
#import "YMKGeometry.h"
#import "YMKOverlayView.h"
#import "YMKOverlayPathView.h"

@interface YMKPolylineView : YMKOverlayPathView {
	
}
@property (nonatomic, readonly) YMKPolyline *polyline;
-(id)initWithPolyline:(YMKPolyline *)_polyline;

@end