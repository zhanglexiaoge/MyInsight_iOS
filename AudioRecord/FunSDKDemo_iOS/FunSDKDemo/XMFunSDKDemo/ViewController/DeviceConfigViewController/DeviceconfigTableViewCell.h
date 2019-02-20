//
//  DeviceconfigTableViewCell.h
//  FunSDKDemo
//
//  Created by Levi on 2018/5/18.
//  Copyright © 2018年 Levi. All rights reserved.
//

/**
 设备配置Cell
 */

#import <UIKit/UIKit.h>

@interface DeviceconfigTableViewCell : UITableViewCell

//设备配置FunSDKLogo
@property (nonatomic, strong) UIImageView *logoImageView;

//设备配置功能Lab(包含编码配置,报警配置等)
@property (nonatomic, strong) UILabel *Labeltext;

//设备配置功能说明Lab
@property (nonatomic, strong) UILabel *detailLabel;

@end
