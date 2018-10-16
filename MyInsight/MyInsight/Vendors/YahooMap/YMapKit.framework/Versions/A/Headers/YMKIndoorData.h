//
//  YMKIndoorData.h
//
//  Copyright (C) 2014 Yahoo Japan Corporation. All Rights Reserved.
//
	
#import <Foundation/Foundation.h>

@class YMKIndoorData;
@interface YMKIndoorData : NSObject
{
    int indoorId;
    NSString* copyright;
    int* layers;
    int layersCount;
    int defaultFloorId;
    int* floorIds;
    int floorIdsCount;
    NSArray* floorLevels;
    NSArray* floorShape;
    NSArray* floorConnection;
}
@property (nonatomic) int indoorId;
@property (nonatomic,retain)NSString* copyright;
@property (assign) int* layers;
@property (nonatomic) int layersCount;
@property (nonatomic) int defaultFloorId;
@property (assign) int* floorIds;
@property (nonatomic) int floorIdsCount;
@property (nonatomic,retain) NSArray* floorLevels;
@property (nonatomic,retain) NSArray* floorShape;
@property (nonatomic,retain) NSArray* floorConnection;

@end