//
//  YMKPointAnnotation.h
//
//  Copyright (C) 2014 Yahoo Japan Corporation. All Rights Reserved.
//
#import <Foundation/Foundation.h>
#import "YMKAnnotation.h"

@interface YMKPointAnnotation : NSObject<YMKAnnotation> {
	CLLocationCoordinate2D coordinate;
	NSString *_title;
	NSString *_subtitle;
}
- (id)initWithLocationCoordinate:(CLLocationCoordinate2D) coord title:(NSString *)title subtitle:(NSString *)subtitle; 
- (NSString *)title;  
- (NSString *)subtitle; 
@property  (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@end