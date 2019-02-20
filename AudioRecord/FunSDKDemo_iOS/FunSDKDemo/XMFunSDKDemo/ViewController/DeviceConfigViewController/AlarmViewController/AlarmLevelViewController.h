//
//  AlarmLevelViewController.h
//  FunSDKDemo
//
//  Created by Levi on 2018/5/23.
//  Copyright © 2018年 Levi. All rights reserved.
//

/**
 
 移动侦测灵敏度选择
 */

#import <UIKit/UIKit.h>

@interface AlarmLevelViewController : UIViewController

@property (nonatomic, copy) void (^alarmLevelBlock)(NSString *iLevel);

@end
