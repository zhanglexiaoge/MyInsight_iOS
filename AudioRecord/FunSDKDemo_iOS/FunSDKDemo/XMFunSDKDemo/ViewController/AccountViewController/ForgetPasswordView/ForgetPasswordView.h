//
//  ForgetPasswordView.h
//  FunSDKDemo
//
//  Created by wujiangbo on 2018/10/30.
//  Copyright © 2018年 wujiangbo. All rights reserved.
//

/**
 
 忘记密码视图
*/

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface ForgetPasswordView : UIView

@property (nonatomic, copy) void(^getCodeBtnClicked)(NSString *userPhone);   //获取验证码点击事件
@property (nonatomic, copy) void(^checkCodeBtnClicked)(NSString *userPhone,NSString *codeStr); //验证点击事件
@property (nonatomic, copy) void(^resettingPwdBtnClicked)(NSString *userPhone,NSString *newPassword);   //重置密码点击

@property (nonatomic, strong) UITextField *userPhone;   //手机号或者邮箱
@property (nonatomic, strong) UITextField *inputCode;   //验证码输入框
@property (nonatomic, strong) UIButton *getCode;        //获取验证码按钮
@property (nonatomic, strong) UIButton *checkBtn;       //验证按钮

@property (nonatomic, strong) UIView *confirmPwdView;   //按确定后 下一步显示的View 覆盖原来的确定按钮
@property (nonatomic, strong) UILabel *userNameLabel;   //显示用户名label
@property (nonatomic, strong) UITextField *pwdField;    //密码
@property (nonatomic, strong) UIButton *confirmResettingPwdbtn;  //确认重置密码

@end

NS_ASSUME_NONNULL_END
