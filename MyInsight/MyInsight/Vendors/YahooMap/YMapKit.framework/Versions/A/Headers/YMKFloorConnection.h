//	
//  YMLFloorConnection
//	
//  Copyright (C) 2014 Yahoo Japan Corporation. All Rights Reserved.
//	
#import <Foundation/Foundation.h>

@interface YMKFloorConnection : NSObject
{
    int floorId;
    int connectionIndoorId;
    int connectionFloorId;
}
@property (nonatomic) int floorId;
@property (nonatomic) int connectionIndoorId;
@property (nonatomic) int connectionFloorId;


@end