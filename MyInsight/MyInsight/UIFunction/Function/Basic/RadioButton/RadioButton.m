//
//  RadioButton.m
//  MyInsight
//
//  Created by SongMenglong on 2018/3/13.
//  Copyright © 2018年 SongMenglong. All rights reserved.
//

#import "RadioButton.h"

@implementation RadioButton

// 重写setter方法
- (BOOL)isSelected {
    return [super isSelected];
}

- (void)setSelected:(BOOL)selected {
    super.selected = selected;
    if (self.selected) {
        self.titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    } else {
        self.titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    }
}

#pragma mark - 重写初始化方法
- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupContentUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupContentUI];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self setupContentUI];
    }
    return self;
}

#pragma mark - 初始化UI
- (void)setupContentUI {
    //
    [self addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    self.titleLabel.numberOfLines = 0;
    
    [self setTitleColor:UIColorFromHex(0x0a83c6) forState:UIControlStateSelected];
    [self setTitleColor:UIColorFromHex(0x333333) forState:UIControlStateNormal];
    
    if (self.selected) {
        self.titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    } else {
        self.titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    }
    
}


- (void)buttonClicked:(UIButton *)button {
    NSLog(@"选中复选框button");
    button.selected = !button.selected;
    
    if (self.selected) {
        self.titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    } else {
        self.titleLabel.font = [UIFont boldSystemFontOfSize:15.0f];
    }
    
    // 闭包 block传出
    if (self.clickedAction) {
        self.clickedAction(self, self.selected);
    }
    
    
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
