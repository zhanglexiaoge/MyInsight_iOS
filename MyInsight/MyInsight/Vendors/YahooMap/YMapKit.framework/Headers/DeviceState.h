//
//  DeviceState.h
//
//  Copyright (C) 2014 Yahoo Japan Corporation. All Rights Reserved.
//
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>

@protocol DeviceStateDelegate
- (void) StateChanged;
@end

@interface DeviceState : NSObject <UIAccelerometerDelegate, CLLocationManagerDelegate> {
	float inclination;	//仰角
	float azimuth;		//方位角
	
	//位置センサー、加速度センサー
	CLLocationManager* locationManager;	
	id<DeviceStateDelegate> delegate;
}
@property (nonatomic,readonly) float inclination;
@property (nonatomic, readonly) float azimuth;
@property (nonatomic, retain) id<DeviceStateDelegate> delegate;

@end
