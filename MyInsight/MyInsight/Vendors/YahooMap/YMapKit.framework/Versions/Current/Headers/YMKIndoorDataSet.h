//
//  YMLIndoorDataSet.h
//
//  Copyright (C) 2014 Yahoo Japan Corporation. All Rights Reserved.
//
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>	
#import "YMKIndoorData.h"

@interface YMKIndoorDataSet : NSObject
{
    NSArray* indoorDatas;
}
@property (nonatomic,retain) NSArray* indoorDatas;

- (id)initWithIndoorDatas:(NSArray *)_indoorDatas;
-(YMKIndoorData*)containsPoint:(CLLocationCoordinate2D)coordinate;
@end