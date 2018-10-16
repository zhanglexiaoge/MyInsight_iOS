//
//  MapDelegate.h
//
//  Copyright (C) 2014 Yahoo Japan Corporation. All Rights Reserved.
//
#import <Foundation/Foundation.h>		
#import <CoreLocation/CoreLocation.h>	
#import "YMKOverlay.h"

@class MapCtrl;
@class YMKAnnotationView;
@class YMKCircle;
@class YMKOverlayView;

//イベント処理
@protocol MapDelegate <NSObject>
- (void)mapCtrl:(MapCtrl*)mapCtrl regionWillChangeAnimated:(BOOL)animated;
- (void)mapCtrl:(MapCtrl*)mapCtrl regionDidChangeAnimated:(BOOL)animated;
- (void)mapCtrlWillStartLoadingMap:(MapCtrl*)mapCtrl;
- (void)mapCtrlDidFinishLoadingMap:(MapCtrl*)mapCtrl;
- (void)mapCtrlDidFailLoadingMap:(MapCtrl*)mapCtrl withError:(NSError*)error;

- (YMKOverlayView*)createViewForOverlay:(id <YMKOverlay>)overlay;
- (YMKAnnotationView*)createViewForAnnotation:(id <YMKAnnotation>)annotation;
- (void)iventAnnotationView:(YMKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control;//ボタンクリック

@end