//
//  POI.h
//
//  Copyright (C) 2014 Yahoo Japan Corporation. All Rights Reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface POI : NSObject {
	double lat;
	double lon;
	UIImageView* iconView;
	int hotX;
	int hotY;
	double x;	//画面座標X
	double y;	//画面座標Y
}
- (id) initWithLat:(double)latitude Lon:(double)longitude Icon:(UIImage*)iconImage iconX:(int)iconx iconY:(int)icony;
@property (nonatomic,readonly) double lat;
@property (nonatomic,readonly) double lon;
@property (nonatomic,retain) UIImageView* iconView;
@property (nonatomic,readonly) int hotX;
@property (nonatomic,readonly) int hotY;
@property (nonatomic) double x;
@property (nonatomic) double y;
@end
