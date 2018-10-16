//
//  YMKTypes.h
//
//  Copyright (C) 2014 Yahoo Japan Corporation. All Rights Reserved.
//
#import <UIKit/UIKit.h>

enum {
	YMKMapTypeStandard = 0,
	YMKMapTypeSatellite,
	YMKMapTypeChika,
	YMKMapTypeHD,
	YMKMapTypeStyle,
	YMKMapTypeOSM,
	YMKMapTypeHybrid,
    YMKMapTypeIndoor,
    YMKMapTypeWeather,
};

typedef NSUInteger YMKMapType;

UIKIT_EXTERN NSString *YMKErrorDomain;

enum YMKErrorCode {
    YMKErrorUnknown = 1,
    YMKErrorServerFailure,
    YMKErrorLoadingThrottled,
    YMKErrorPlacemarkNotFound,
};
