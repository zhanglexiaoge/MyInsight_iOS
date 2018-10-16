//
//  YMKRouteOverlayView.h
//
//  Copyright (C) 2014 Yahoo Japan Corporation. All Rights Reserved.
//
#import <Foundation/Foundation.h>
#import "YMKOverlayView.h"
#import "YMKAnnotationView.h"

@class YMKRouteOverlay;

@interface YMKRouteOverlayView : YMKOverlayView {

}

@property (nonatomic, readonly) YMKRouteOverlay* routeOverlay;
@property(nonatomic) BOOL startPinVisible;
@property(nonatomic) BOOL goalPinVisible;
@property(nonatomic) BOOL routePinVisible;

- (id)initWithRouteOverlay:(YMKRouteOverlay*)overlay;

@end
