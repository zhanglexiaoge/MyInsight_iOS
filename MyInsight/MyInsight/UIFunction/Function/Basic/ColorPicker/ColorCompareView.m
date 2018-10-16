//
//  ColorCompareView.m
//  MyInsight
//
//  Created by SongMengLong on 2018/7/16.
//  Copyright © 2018年 SongMenglong. All rights reserved.
//

#import "ColorCompareView.h"

@interface ColorCompareView()

@property (nonatomic, assign) CAShapeLayer *touchDownLayer;
@property (nonatomic, retain) UIColor *checkerboardColor;

@end


@implementation ColorCompareView

// 颜色比较
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    
    return self;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
