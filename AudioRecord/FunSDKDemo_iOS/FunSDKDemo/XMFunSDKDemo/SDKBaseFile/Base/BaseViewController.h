//
//  BaseViewController.h
//  XMeye_Old
//
//  Created by zyj on 15/1/7.
//  Copyright (c) 2015年 hzjf. All rights reserved.
//
/***
 SDK初始化类，这几个文件是调用大部分sdk接口所必须要使用或者继承之后使用的父类
 BaseViewController  普通的视图控制器或者功能类如果要使用FunSDK，可以继承自这个类
 *****/
#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController

-(int)MsgHandle;
-(void)CloseMsgHandle;
@end
