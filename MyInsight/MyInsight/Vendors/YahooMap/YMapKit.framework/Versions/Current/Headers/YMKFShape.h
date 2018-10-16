//	
//  YMKFShape
//	
//  Copyright (C) 2014 Yahoo Japan Corporation. All Rights Reserved.
//	
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>	

@interface YMKFShape : NSObject
{
    CLLocationCoordinate2D* coordinates;
    int coordsCount;
}
@property (assign) CLLocationCoordinate2D *coordinates;
@property (nonatomic) int coordsCount;

@end