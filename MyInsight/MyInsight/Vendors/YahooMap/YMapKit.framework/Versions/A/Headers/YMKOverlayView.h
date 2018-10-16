//
//  YMKOverlayView.h
//
//  Copyright (C) 2014 Yahoo Japan Corporation. All Rights Reserved.
//
#import <UIKit/UIKit.h>
#import "YMKOverlay.h"
#import "YMKGeometry.h"

@protocol YMKProjection;

@interface YMKOverlayView : UIView {
	id <YMKOverlay> _overlay;
}

//初期化
- (id)initWithOverlay:(id <YMKOverlay>)overlay;
//オーバーレイ
@property (nonatomic, readonly) id <YMKOverlay> overlay;

- (CGPoint)pointForMapPoint:(YMKMapPoint)mapPoint;

- (YMKMapPoint)mapPointForPoint:(CGPoint)point;

- (CGRect)rectForMapRect:(YMKMapRect)mapRect;

- (YMKMapRect)mapRectForRect:(CGRect)rect;

- (BOOL)canDrawMapRect:(YMKMapRect)mapRect zoomScale:(YMKZoomScale)zoomScale;

- (void)drawMapRect:(YMKMapRect)mapRect zoomScale:(YMKZoomScale)zoomScale inContext:(CGContextRef)context;

- (void)setNeedsDisplayInMapRect:(YMKMapRect)mapRect;

- (void)setNeedsDisplayInMapRect:(YMKMapRect)mapRect zoomScale:(YMKZoomScale)zoomScale;

@end