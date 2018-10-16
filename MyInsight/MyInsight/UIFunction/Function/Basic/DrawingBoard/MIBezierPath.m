//
//  MIBezierPath.m
//  MyInsight
//
//  Created by SongMengLong on 2018/6/26.
//  Copyright © 2018年 SongMenglong. All rights reserved.
//

#import "MIBezierPath.h"

@implementation MIBezierPath

-(void)setColor:(UIColor *)color{
    _color = color;
    if (!_color) {
        _color = [UIColor blackColor];
    }
}

@end
