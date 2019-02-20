//
//  MyRadarView.h
//  XMEye
//
//  Created by Megatron on 4/2/15.
//  Copyright (c) 2015 Megatron. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyRadarView : UIView

@property (nonatomic,strong) UIImageView *scanSign;
@property (nonatomic,strong) UIImageView *bgView;
@property (nonatomic,strong) NSTimer *myTimer;
@property (assign,nonatomic) int angle;

-(void)startSeek;      // 开始搜索动画
-(void)stopSeek;       // 停止搜索动画

@end
