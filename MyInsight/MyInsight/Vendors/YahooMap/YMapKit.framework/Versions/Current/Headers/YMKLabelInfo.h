//
//  YMKUserLocation.h
//
//  Copyright (C) 2014 Yahoo Japan Corporation. All Rights Reserved.
//
#import <Foundation/Foundation.h>

@interface YMKLabelInfo : NSObject{
	NSString* type;
	NSString* label;
	NSString* name;
	NSString* gid;
	NSString* specid;
	double angle;
    BOOL vertical;	
}

- (id) initWithType:(NSString*)_type Gid:(NSString*)_gid Specid:(NSString*)_specid Name:(NSString*)_name  Label:(NSString*)_label Angle:(double)_angle Vertical:(BOOL)_vertical;

@property (nonatomic, readonly) NSString *type;
@property (nonatomic, readonly) NSString *label;
@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSString *gid;
@property (nonatomic, readonly) NSString *specid;
@property (readonly) double angle;
@property (readonly) BOOL vertical;

@end