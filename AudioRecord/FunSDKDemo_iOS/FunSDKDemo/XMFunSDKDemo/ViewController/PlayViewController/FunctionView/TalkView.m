//
//  TalkView.m
//  XMEye
//
//  Created by Wangchaoqun on 15/7/4.
//  Copyright (c) 2015年 Megatron. All rights reserved.
//

#import "TalkView.h"


@implementation TalkView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.talkButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [self.talkButton setBackgroundImage:[UIImage imageNamed:TS("press_talk")] forState:UIControlStateNormal];
        [self.talkButton setBackgroundImage:[UIImage imageNamed:TS("press_talk_selected")] forState:UIControlStateHighlighted];
        [self.talkButton addTarget:self action:@selector(talkToOther:) forControlEvents:UIControlEventTouchDown];
        [self.talkButton addTarget:self action:@selector(cannelTalk:) forControlEvents:UIControlEventTouchUpInside];
        [self.talkButton addTarget:self action:@selector(cannelTalk:) forControlEvents:UIControlEventTouchUpOutside];
        [self addSubview:self.talkButton];
        
        self.cannelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.cannelButton setBackgroundImage:[UIImage imageNamed:@"icon_close"] forState:UIControlStateNormal];
        [self.cannelButton addTarget:self action:@selector(cannelTheView) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.cannelButton];
    }
    return self;
}

//显示视图
- (void)showTheView
{
    CGFloat width = CGRectGetWidth(self.frame) > CGRectGetHeight(self.frame) ?
                                             CGRectGetHeight(self.frame) - 10:
                                             CGRectGetWidth(self.frame) - 10;
    self.talkButton.frame = CGRectMake(0, 0, width, width);
    self.talkButton.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    
    self.cannelButton.frame = CGRectMake(CGRectGetWidth(self.frame) - 50, 0, 50, 50);
    
    CGRect frame = self.frame;
    
    self.frame = CGRectOffset(frame, 0, frame.size.height);
    
    [UIView animateWithDuration:0.2 animations:^{
        self.frame = frame;
        self.cannelButton.transform = CGAffineTransformMakeRotation(M_PI_2);
    } completion:^(BOOL finished) {
        if ([self.delegate respondsToSelector:@selector(openTalkView)]) {
            [self.delegate openTalkView];
        }
    }];
}


//关闭视图
- (void)cannelTheView
{
    [UIView animateWithDuration:0.2 animations:^{
        self.frame = CGRectOffset(self.frame, 0, self.frame.size.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if ([self.delegate respondsToSelector:@selector(closeTalkView)]) {
            [self.delegate closeTalkView];
        }
    }];
}

//打开通话
- (void)talkToOther:(id)sender
{
    UIButton *button  = (UIButton*)sender;
    button.highlighted = true;
    
    if ([self.delegate respondsToSelector:@selector(openTalk)]) {
        [self.delegate openTalk];
    }
}

//关闭通话
- (void)cannelTalk:(id)sender
{
    UIButton *button = (UIButton*)sender;
    button.highlighted = false;
    
    if ([self.delegate respondsToSelector:@selector(closeTalk)]) {
        [self.delegate closeTalk];
    }
}


@end
