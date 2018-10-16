//
//  YMKMapLayerDelegate.h
//
//  Copyright (C) 2014 Yahoo Japan Corporation. All Rights Reserved.
//
#import <Foundation/Foundation.h>
@class YMKMapView;

@protocol YMKMapLayerDelegate <NSObject>
@optional
	- (void)returnMapLayer:(id <YMKMapLayer>)mapLayer;
@end
