//
//  UserBindView.h
//  FunSDKDemo
//
//  Created by wujiangbo on 2018/11/2.
//  Copyright © 2018年 wujiangbo. All rights reserved.
//

/**
 
 用户手机号或者邮箱绑定界面视图
 */
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserBindView : UIView

@property (nonatomic, copy) void(^getCodeBtnClicked)(NSString *phoneEmail);     //获取验证码
@property (nonatomic, copy) void(^bindBtnClicked)(NSString *phoneEmail,NSString *code);     //绑定手机号/邮箱

@property (nonatomic) UITextField *phoneEmailTF;     //邮箱/手机号输入框
@property (nonatomic) UITextField *codeTF;           //验证码输入框
@property (nonatomic) UIButton *getCodeBtn;          //获取验证码按钮
@property (nonatomic) UIButton *bindBtn;             //绑定按钮

@end

NS_ASSUME_NONNULL_END
