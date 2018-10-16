//
//  BlueToothDataVC.h
//  MyInsight
//
//  Created by SongMenglong on 2018/5/17.
//  Copyright © 2018年 SongMenglong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseVC.h"
#import  <CoreBluetooth/CoreBluetooth.h>

@interface BlueToothDataVC : BaseVC

// 传过来的设备
@property (nonatomic, strong) CBPeripheral *peripheral;

@end
