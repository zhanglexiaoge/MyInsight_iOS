//
//  BluetoothCell.h
//  MyInsight
//
//  Created by SongMenglong on 2017/12/28.
//  Copyright © 2017年 SongMenglong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BluetoothCell : UITableViewCell
// 蓝牙名字
@property (weak, nonatomic) IBOutlet UILabel *bleNameLabel;
// 设备信号值
@property (weak, nonatomic) IBOutlet UILabel *rssiLabel;
// 设备identifier
@property (weak, nonatomic) IBOutlet UILabel *identifierLabel;
// 广播中的设备服务UUID
@property (weak, nonatomic) IBOutlet UILabel *serviceUUIDLabel;


@end
