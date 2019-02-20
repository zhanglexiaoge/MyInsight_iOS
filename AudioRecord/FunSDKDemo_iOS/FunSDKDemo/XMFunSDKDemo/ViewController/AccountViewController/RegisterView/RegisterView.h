//
//  RegisterView.h
//  FunSDKDemo
//
//  Created by wujiangbo on 2018/10/27.
//  Copyright © 2018年 wujiangbo. All rights reserved.
//

/**
 
 注册账号界面视图
*/


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RegisterView : UIView

@property (nonatomic, copy) void(^getCodeBtnClicked)(NSString *phoneStr);     //获取验证码
@property (nonatomic, copy) void(^registerBtnClicked)(NSString *userName,NSString *password1,NSString *password2,NSString *phoneStr,NSString *codeStr);       //注册按钮点击
@property (nonatomic, copy) void(^btnPrivacyBtnClicked)(void);  //点击查看隐私权限

@property (nonatomic, strong) UITableView *tbSettings;  //账号列表
@property (nonatomic, strong) UIButton *registerBtn;    //注册按钮
@property (nonatomic, strong) UITextField *userNameTF;  //用户名
@property (nonatomic, strong) UITextField *pwdTF;       //密码
@property (nonatomic, strong) UITextField *confrimTF;   //确认密码

@property (nonatomic, strong) UIButton *jumpBtn;        //跳过按钮
@property (nonatomic, strong) UITextField *phoneTF;     //手机邮箱输入
@property (nonatomic, strong) UITextField *codeTF;      //二维码输入框
@property (nonatomic, strong) UIButton *getCodeBtn;     //获取二维码
@property (nonatomic, assign) NSInteger sendTime;       //倒计时时间
@property (nonatomic, strong) NSTimer *countDownTimer;  //倒计时计时器

@property (nonatomic,strong) UIButton *btnSelector;     //选择隐私权限按钮
@property (nonatomic,strong) UILabel *lbDescription;    //隐私权限文字描述
@property (nonatomic,strong) UIButton *btnPrivacy;      //隐私权限按钮
@property (nonatomic,strong) UILabel *errorTipLabel;    //错误提示

@end

NS_ASSUME_NONNULL_END
