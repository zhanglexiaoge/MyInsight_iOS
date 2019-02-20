//
//  PlayBackViewController.h
//  FunSDKDemo
//
//  Created by XM on 2018/10/19.
//  Copyright © 2018年 XM. All rights reserved.
//
/*****
 *
 * 视频回放视图控制器，包括下面几部分
 *根据日期查询录像文件
 *播放录像文件
 *暂停和恢复录像回放
 *音频控制和播放速度控制
 *抓图和录像
 *通过查询到的录像文件显示时间轴，拖动时间轴播放
 *app进入后台时，可以把视频暂停，也可以直接停止，重新唤醒app时，再恢复播放
 *
 *****/
#import <UIKit/UIKit.h>

@interface PlayBackViewController : UIViewController

@end
