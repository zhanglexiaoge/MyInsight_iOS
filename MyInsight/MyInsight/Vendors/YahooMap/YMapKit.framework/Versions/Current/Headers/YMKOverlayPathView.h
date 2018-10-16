//
//  YMKOverlayPathView.h
//
//  Copyright (C) 2014 Yahoo Japan Corporation. All Rights Reserved.
//
#import <UIKit/UIKit.h>
#import "YMKGeometry.h"
#import "YMKOverlayView.h"

@interface YMKOverlayPathView : YMKOverlayView {
	UIColor *fillColor;
	UIColor *strokeColor;
	CGFloat lineWidth;
	CGLineJoin lineJoin;
	CGLineCap lineCap;
	CGFloat miterLimit;
	CGFloat lineDashPhase;
	NSArray *lineDashPattern;
	CGPathRef path;
}

@property (retain) UIColor *fillColor;
@property (retain) UIColor *strokeColor;
@property CGFloat lineWidth;
@property CGLineJoin lineJoin;
@property CGLineCap lineCap;
@property CGFloat miterLimit;
@property CGFloat lineDashPhase;
@property (copy) NSArray *lineDashPattern;
@property CGPathRef path;

- (void)createPath;
- (void)invalidatePath;
- (void)applyStrokePropertiesToContext:(CGContextRef)context atZoomScale:(YMKZoomScale)zoomScale;
- (void)applyFillPropertiesToContext:(CGContextRef)context atZoomScale:(YMKZoomScale)zoomScale;
- (void)strokePath:(CGPathRef)path inContext:(CGContextRef)context;
- (void)fillPath:(CGPathRef)path inContext:(CGContextRef)context;

@end
