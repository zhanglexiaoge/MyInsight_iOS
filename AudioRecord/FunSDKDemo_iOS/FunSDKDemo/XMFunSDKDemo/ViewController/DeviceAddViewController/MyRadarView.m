//
//  MyRadarView.m
//  XMEye
//
//  Created by Megatron on 4/2/15.
//  Copyright (c) 2015 Megatron. All rights reserved.
//

#import "MyRadarView.h"

@implementation MyRadarView

@synthesize angle = _angle;

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        int w = frame.size.width;       // 背景图的宽高
        int h = frame.size.height;
        
        self.bgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"radar_search_bg.png"]];
        self.bgView.frame = CGRectMake(0, 0, w, w);
        self.bgView.center = CGPointMake(w * 0.5, h * 0.5);
        self.bgView.userInteractionEnabled = YES;
        
        [self addSubview:self.bgView];
        
        self.scanSign = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"radar_search_sign.png"]];
        self.scanSign.frame = CGRectMake(0, 0, w, w);
        self.scanSign.center = CGPointMake(w * 0.5, h *0.5);
        self.scanSign.userInteractionEnabled = YES;
        self.scanSign.hidden = YES;
        
        [self addSubview:self.scanSign];
    }
    return self;
}

-(void)startSeek
{
    self.scanSign.hidden = NO;
    
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 2;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = 9999999;
    
    [self.scanSign.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

-(void)stopSeek
{
    self.hidden = YES;
}


@end
