//
//  YMKUserLocation.h
//
//  Copyright (C) 2014 Yahoo Japan Corporation. All Rights Reserved.
//
#import <Foundation/Foundation.h>
#import "YMKAnnotation.h"

@class CLLocation;
@class UserLocationAnnotation;

@interface YMKUserLocation : NSObject <YMKAnnotation> {
	UserLocationAnnotation* _internal;
}
- (id) initWithInternal:(UserLocationAnnotation*)usrLocAnnotation;

// Returns YES if the user's location is being updated.
@property (readonly, nonatomic, getter=isUpdating) BOOL updating;

// Returns nil if the owning MKMapView's showsUserLocation is NO or the user's location has yet to be determined.
@property (readonly, nonatomic) CLLocation *location;

// The title to be displayed for the user location annotation.
@property (retain, nonatomic) NSString *title;

// The subtitle to be displayed for the user location annotation.
@property (retain, nonatomic) NSString *subtitle;

@end