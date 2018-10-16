//
//  PSBaseView.m
//  MyInsight
//
//  Created by SongMenglong on 2018/4/24.
//  Copyright © 2018年 SongMenglong. All rights reserved.
//

#import "PSBaseView.h"

@implementation PSBaseView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        // 设置背景
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"BackgroundTile"]];
        
        // 设置方块
        UIImageView *boxView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Box1"]];
        boxView.center = CGPointMake(200, 200);
        boxView.userInteractionEnabled = YES;
        [self addSubview:boxView];
        self.boxView = boxView;
        
        // 初始化仿真器
        UIDynamicAnimator *animator = [[UIDynamicAnimator alloc] initWithReferenceView:self];
        //UIDynamic－iOS中的物理引擎
        
        //1, 创建一个物理仿真器 设置仿真范围
        //2, 创建相应的物理仿真行为, 添加物理仿真元素
        //3, 将物理仿真行为添加到仿真器中开始仿真
        
        self.animator = animator;
    }
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
