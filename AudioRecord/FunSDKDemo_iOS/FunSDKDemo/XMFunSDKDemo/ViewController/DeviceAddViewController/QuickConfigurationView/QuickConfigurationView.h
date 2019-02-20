//
//  QuickConfigurationView.h
//  FunSDKDemo
//
//  Created by wujiangbo on 2018/11/15.
//  Copyright © 2018年 wujiangbo. All rights reserved.
//
/**
 
 快速配置界面视图
 */
#import <UIKit/UIKit.h>
#import "MyRadarView.h"

NS_ASSUME_NONNULL_BEGIN

@interface QuickConfigurationView : UIView
@property (nonatomic, copy) void(^startConfig)(NSString *ssid,NSString *password);      //开始快速配置
@property (nonatomic, copy) void(^stopConfig)(void);                                    //停止快速配置
@property (nonatomic, copy) void(^addDevice)(void);                                     //点击设备按钮添加设备

@property(nonatomic,strong) UITextField *wifiTF;         //wifi名
@property(nonatomic,strong) UITextField *passwordTF;     //wifi密码
@property(nonatomic,strong) UIButton *configurationBtn;  //确定按钮
@property(nonatomic,strong) UILabel *wifiLab;            //wifi名
@property(nonatomic,strong) UILabel *passwordLab;        //wifi密码
@property(nonatomic,strong) UILabel *tipsLab;            //快速配置提示语
@property(nonatomic,strong) UIButton *startBtn;          //开始快速配置按钮
@property(nonatomic,strong) MyRadarView *radarView;      //快速配置动画界面
@property(nonatomic,strong) UILabel *configTipsLab;      //快速配置提示语
@property(nonatomic,strong) UILabel *countLab;           //倒计时
@property(nonatomic,strong) NSMutableArray *btnArray;    //设备按钮数组
@property(nonatomic,strong) NSMutableArray *deviceArray; //快速配置搜索到得设备

//创建快速配置视图，有设备则显示设备按钮
-(void)createPlayView;
//快速配置成功，停止计时
-(void)stopTiming;

@end

NS_ASSUME_NONNULL_END
