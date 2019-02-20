//
//  PasswordView.h
//  FunSDKDemo
//
//  Created by XM on 2018/11/17.
//  Copyright © 2018年 XM. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PasswordView : UIView

@property (nonatomic, copy) void(^changePwdClicked)(NSString *pwdOld,NSString *pwdNew1,NSString *pwdNew2);  // 修改密码点击事件

@property (nonatomic, strong) UITableView *tbPassWord;  //视图列表

@property (nonatomic, strong) UITextField *pwdOldTF;    //用户名
@property (nonatomic, strong) UITextField *pwdNewTF;    //密码
@property (nonatomic, strong) UITextField *confrimTF;   //确认密码

@property (nonatomic, strong) UIButton *changePwdBtn;   //修改密码按钮

@end
