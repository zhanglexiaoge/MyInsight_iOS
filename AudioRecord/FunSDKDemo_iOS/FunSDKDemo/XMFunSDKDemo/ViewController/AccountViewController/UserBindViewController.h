//
//  UserBindViewController.h
//  FunSDKDemo
//
//  Created by wujiangbo on 2018/11/2.
//  Copyright © 2018年 wujiangbo. All rights reserved.
//

/**
 
 用户信息
 *1、输入需要绑定的手机（或者邮箱）
 *2、获取验证码
 *3、输入获取到的验证码，点击进行绑定
 */

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserBindViewController : UIViewController

@property (nonatomic, copy) void(^bindPhoneEmailSuccess)(void);     //绑定手机号/邮箱成功

@end

NS_ASSUME_NONNULL_END
