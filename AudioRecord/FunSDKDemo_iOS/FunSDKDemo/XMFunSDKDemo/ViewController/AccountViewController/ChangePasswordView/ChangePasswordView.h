//
//  ChangePasswordView.h
//  FunSDKDemo
//
//  Created by wujiangbo on 2018/10/30.
//  Copyright © 2018年 wujiangbo. All rights reserved.
//

/**
 
 修改账号密码界面视图
*/


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChangePasswordView : UIView

@property (nonatomic, copy) void(^changePwdBtnClicked)(NSString *userName,NSString *pwdOld,NSString *pwdNew1,NSString *pwdNew2);  // 修改密码点击事件

@property (nonatomic, strong) UITableView *tbPassWord;  //视图列表

@property (nonatomic, strong) UITextField *pwdOldTF;    //用户名
@property (nonatomic, strong) UITextField *pwdNewTF;    //密码
@property (nonatomic, strong) UITextField *confrimTF;   //确认密码

@property (nonatomic, strong) UIButton *changePwdBtn;   //修改密码按钮

@end

NS_ASSUME_NONNULL_END
