//
//  YMKTileView.h
//
//  Copyright (C) 2014 Yahoo Japan Corporation. All Rights Reserved.
//
#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

@interface YMKTileView : UIImageView
{
    int tileX;
    int tileY;
    int tileZ;
}
@property (nonatomic) int tileX;
@property (nonatomic) int tileY;
@property (nonatomic) int tileZ;
- (id)initWithTileX:(int)x TileY:(int)y TileZ:(int)z;
- (BOOL)cmpWithTileX:(int)x TileY:(int)y TileZ:(int)z;

//@property (nonatomic, retain) UIImage* image;

@end
