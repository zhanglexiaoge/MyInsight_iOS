//
//  PlayView.m
//  XMEye
//
//  Created by XM on 2018/7/21.
//  Copyright © 2018年 Megatron. All rights reserved.
//

#import "PlayView.h"

@implementation PlayView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor blackColor];
    _activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    _activityView.hidesWhenStopped = YES;
    [self addSubview:_activityView];
    return self;
}
#pragma mark  刷新界面图标
- (void)refreshView {
    CGRect rect = self.frame;
    CGPoint point = CGPointMake(rect.size.width/2.0, rect.size.height/2.0);
    self.activityView.center = point;
}
- (void)playViewBufferIng { //正在缓冲
    [self.activityView startAnimating];
}
- (void)playViewBufferEnd {//缓冲完成
    [self.activityView stopAnimating];
}
- (void)playViewBufferStop {//预览失败
    [self.activityView stopAnimating];
}



+(Class)layerClass{
    return [CAEAGLLayer class];
}
@end
