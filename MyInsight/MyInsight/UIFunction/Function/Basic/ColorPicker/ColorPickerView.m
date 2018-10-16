
//
//  ColorPickerView.m
//  MyInsight
//
//  Created by SongMengLong on 2018/7/16.
//  Copyright © 2018年 SongMenglong. All rights reserved.
//

#import "ColorPickerView.h"
#import "Header.h"

@interface ColorPickerView()

@end


@implementation ColorPickerView

// 初始化方法
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUIViews];
    }
    return self;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    
    //
    [self setupUIViews];
}

// 设置UI内容
- (void)setupUIViews {
    // 背景颜色
    self.backgroundColor = [UIColor colorWithRed:0.225 green:0.225 blue:0.225 alpha:1.000];
    
    // 调色盘
    
    
    // 亮度滑动条
    
    // 透明度滑动条
    
    // 颜色比较
    
    
    
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
