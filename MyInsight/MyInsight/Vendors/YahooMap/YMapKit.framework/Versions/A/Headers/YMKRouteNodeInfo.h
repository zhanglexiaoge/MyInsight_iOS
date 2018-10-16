//
//  YMKRouteNodeInfo.h
//
//  Copyright (C) 2014 Yahoo Japan Corporation. All Rights Reserved.
//
#import <Foundation/Foundation.h>

@protocol YMKRouteNodeInfo <NSObject>

@property (nonatomic) int direction;
@property (nonatomic) double distance;
@property (nonatomic) double time;
@property (nonatomic) int floorLevel;

-(NSString*) getMessage;

@end