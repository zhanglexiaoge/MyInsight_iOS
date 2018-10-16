//
//  YMKShape.h
//
//  Copyright (C) 2014 Yahoo Japan Corporation. All Rights Reserved.
//
#import <Foundation/Foundation.h>
#import "YMKAnnotation.h"

@interface YMKShape : NSObject <YMKAnnotation> {
	NSString * _title;
	NSString * _subtitle;
	CLLocationCoordinate2D coordinate;
}

@property (copy) NSString *title;
@property (copy) NSString *subtitle;

@end
