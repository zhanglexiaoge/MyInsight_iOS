//
//  YMKMapLayer.h
//  iDriveSample7
//
//  Copyright (C) 2014 Yahoo Japan Corporation. All Rights Reserved.
//
#import <Foundation/Foundation.h>
#import "YMKTypes.h"
#import "YMKGeometry.h"
#import "YMKIndoorDataSet.h"

@protocol YMKMapLayer <NSObject>
@optional

-(YMKIndoorDataSet*)indoorDataSet;

-(BOOL)existsWithMapType:(YMKMapType)mapType withSpan:(YMKCoordinateSpan)span;
-(BOOL)existsWithMapType:(YMKMapType)mapType withSpan:(YMKCoordinateSpan)span withLevel:(int)level;
-(YMKCoordinateSpan)getMinSpanWithMapType:(YMKMapType)mapType;
-(YMKCoordinateSpan)getMaxSpanWithMapType:(YMKMapType)mapType;
- (void)stop;
@end