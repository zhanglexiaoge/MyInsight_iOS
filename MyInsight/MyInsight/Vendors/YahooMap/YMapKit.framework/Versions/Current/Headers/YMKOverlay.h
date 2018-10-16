//
//  YMKOverlay.h
//
//  Copyright (C) 2014 Yahoo Japan Corporation. All Rights Reserved.
//
#import <Foundation/Foundation.h>
#import "YMKGeometry.h"
#import "YMKAnnotation.h"

//アイテム検索
@protocol YMKOverlay <YMKAnnotation>

//アイテムの緯度経度
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly) YMKMapRect boundingMapRect;
@optional

- (BOOL)intersectsMapRect:(YMKMapRect)mapRect;

@end
