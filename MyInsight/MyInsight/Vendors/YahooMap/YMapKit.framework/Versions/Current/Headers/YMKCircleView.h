//
//  YMKCircleView.h
//
//  Copyright (C) 2014 Yahoo Japan Corporation. All Rights Reserved.
//
#import <UIKit/UIKit.h>
#import "YMKCircle.h"
#import "YMKOverlayPathView.h"
#import "YMKGeometry.h"

@class LLPoint;
@interface YMKCircleView : YMKOverlayPathView {
//	YMKCircle *_circle;
//	YMKMapPoint _point;
//	YMKMapRect _rect;
    
}

//@property (nonatomic, readonly) YMKCircle *circle;

- (id)initWithCircle:(YMKCircle *)circle;

@end
