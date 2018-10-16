//
//  YMKWeatherOverlay.h
//
//  Copyright (C) 2014 Yahoo Japan Corporation. All Rights Reserved.
//

#import <UIKit/UIKit.h>
#import "YMKGeometry.h"
#import "YMKOverlay.h"

@interface YMKWeatherOverlay : NSObject <YMKOverlay> {

}
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly) YMKMapRect boundingMapRect;
- (id)init;

- (BOOL)intersectsMapRect:(YMKMapRect)mapRect;
@end
