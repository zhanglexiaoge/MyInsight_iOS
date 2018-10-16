//
//  YMKTileOverlay.h
//
//  Copyright (C) 2014 Yahoo Japan Corporation. All Rights Reserved.
//
#import <Foundation/Foundation.h>
#import "YMKOverlayView.h"

@interface YMKTileOverlayView : YMKOverlayView
{
    @protected
    NSMutableArray* tileArray;
    CGSize orgSize;
    int nowZLevel;
}

@property (nonatomic, readonly) int nowZLevel;
- (id)initWithFrame:(CGRect)frame;
- (void)updateTileX:(int)x tileY:(int)y tileZ:(int)z tileRect:(CGRect)rect;
- (void)changeZLevel:(int)z;
@end
