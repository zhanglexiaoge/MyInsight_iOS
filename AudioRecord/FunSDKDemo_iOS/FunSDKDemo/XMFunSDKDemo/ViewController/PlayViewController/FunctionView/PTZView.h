//
//  PTZView.h
//  XMEye
//
//  Created by Levi on 2017/6/23.
//  Copyright © 2017年 Megatron. All rights reserved.
//
/******
 *
 *云台控制界面
 *
 *
 */
#import <UIKit/UIKit.h>

@protocol PTZViewDelegate <NSObject>

#pragma mark - 点击云台控制的按钮
-(void)controlPTZBtnTouchDownAction:(int)sender;

#pragma mark - 抬起云台控制的按钮
-(void)controlPTZBtnTouchUpInsideAction:(int)sender;

#pragma mark - 点击控制的按钮(变倍，变焦，光圈)
-(void)controladdSpeedTouchDownAction:(int)sender;

#pragma mark - 抬起控制的按钮(变倍，变焦，光圈)
-(void)controladdSpeedTouchUpInsideAction:(int)sender;

@end

@interface PTZView : UIView

@property (nonatomic, strong) UIButton *closeBtn;

@property (nonatomic, strong) UIButton *PTZUpBtn;

@property (nonatomic, strong) UIButton *PTZDownBtn;

@property (nonatomic, strong) UIButton *PTZLeftBtn;

@property (nonatomic, strong) UIButton *PTZRightBtn;

@property (nonatomic, strong) UIImageView *PTZControlIV;

@property (nonatomic,weak) id <PTZViewDelegate> PTZdelegate;

@property (nonatomic,weak) id <PTZViewDelegate> speedDelegate;


@end
