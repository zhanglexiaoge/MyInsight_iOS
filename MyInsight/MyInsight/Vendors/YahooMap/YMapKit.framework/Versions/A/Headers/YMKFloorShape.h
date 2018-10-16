//	
//  YMLFloorShape
//	
//  Copyright (C) 2014 Yahoo Japan Corporation. All Rights Reserved.
//	
#import <Foundation/Foundation.h>

@interface YMKFloorShape : NSObject
{
    NSString* type;
    int* floorIds;
    int floorIdCount;
    NSArray* floorLevels;
}
@property (nonatomic,retain) NSString* type;
@property (assign)int* floorIds;
@property (nonatomic) int floorIdCount;
@property (nonatomic,retain) NSArray* shapes;

@end