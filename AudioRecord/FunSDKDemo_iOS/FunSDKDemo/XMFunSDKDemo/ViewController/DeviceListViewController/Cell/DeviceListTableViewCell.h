//
//  DeviceListTableViewCell.h
//  FunSDKDemo
//
//  Created by Levi on 2018/5/18.
//  Copyright © 2018年 Levi. All rights reserved.
//

/**
 设备列表Cell
 */

#import <UIKit/UIKit.h>

@interface DeviceListTableViewCell : UITableViewCell

//设备类型图片
@property (nonatomic, strong) UIImageView *devImageV;

//设备名称Lab
@property (nonatomic, strong) UILabel *devName; 

//设备类型:
@property (nonatomic, strong) UILabel *devType;

//设备类型获取填充Lab
@property (nonatomic, strong) UILabel *devTypeLab;

//设备SN:
@property (nonatomic, strong) UILabel *devSN;

//设备SN:获取填充Lab
@property (nonatomic, strong) UILabel *devSNLab;

//设备在线状态
@property (nonatomic, strong) UIImageView *onlineState;

//设备在线状态
- (void)setDeviceState:(int)state;
//设备睡眠状态
- (void)setSleepType:(int)type;
@end
