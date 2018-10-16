//
//  YMKIndoormapFloor.h
//
//  Copyright (C) 2014 Yahoo Japan Corporation. All Rights Reserved.
//	
#import <Foundation/Foundation.h>

@interface YMKIndoormapFloor : NSObject
{
    int indoorId;
    int floorId;
    int mapType;
}
@property (nonatomic) int indoorId;
@property (nonatomic) int floorId;
@property (nonatomic) int mapType;

@end