//
//  FishEyeVideoVC.h
//  未来家庭
//
//  Created by wujiangbo on 8/8/16.
//  Copyright © 2016 wujiangbo. All rights reserved.
//
#import "BaseViewController.h"
#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>
#import "FunSDK/FunSDK.h"
@interface FishEyeVideoVC : BaseViewController<GLKViewDelegate>

@property (nonatomic,copy)NSString *titleName;              // 标题名称
@property (nonatomic,strong)UILabel *titleLabel;            // 标题label
@property (nonatomic,strong)UIButton *playBtn;              // 播放暂停按钮
@property (nonatomic,strong)UISlider *timeSlider;           // 时间滑动条
@property (nonatomic,strong)UILabel *playTime;              // 播放时间
@property (nonatomic,strong)UILabel *totalTime;             // 总时间
@property (nonatomic,strong)NSString *fileName;             //文件路径名
@property (nonatomic,assign)int fisheyephotoOrvideo;
//@property (nonatomic,assign) UI_HANDLE msgHandle;
@end
