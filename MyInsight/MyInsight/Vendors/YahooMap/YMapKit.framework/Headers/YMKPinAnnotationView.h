//
//  YMKPinAnnotationView.h
//
//  Copyright (C) 2014 Yahoo Japan Corporation. All Rights Reserved.
//
#import <Foundation/Foundation.h>
#import "YMKAnnotationView.h"

enum {
	YMKPinAnnotationColorRed = 0,
    YMKPinAnnotationColorGreen,
    YMKPinAnnotationColorPurple
};
	
typedef NSUInteger YMKPinAnnotationColor;
	
@class YMKPinAnnotationViewInternal;
@interface YMKPinAnnotationView : YMKAnnotationView
{
	YMKPinAnnotationColor pinColor;
	BOOL animatesDrop;
	int _anime_y;
	int _org_y;
}
@property (nonatomic) YMKPinAnnotationColor pinColor;
@property (nonatomic) BOOL animatesDrop;
@end