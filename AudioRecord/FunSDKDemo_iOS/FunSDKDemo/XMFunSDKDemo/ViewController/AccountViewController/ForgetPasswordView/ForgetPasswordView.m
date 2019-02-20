//
//  ForgetPasswordView.m
//  FunSDKDemo
//
//  Created by wujiangbo on 2018/10/30.
//  Copyright © 2018年 wujiangbo. All rights reserved.
//

#import "ForgetPasswordView.h"
#import <Masonry/Masonry.h>

@implementation ForgetPasswordView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:self.userPhone];
        [self addSubview:self.inputCode];
        [self addSubview:self.getCode];
        [self addSubview:self.checkBtn];
        [self addSubview:self.confirmPwdView];
        
        //按确定后 下一步显示的View
        self.confirmPwdView.hidden = YES;
        [self.confirmPwdView addSubview:self.userNameLabel];
        [self.confirmPwdView addSubview:self.pwdField];
        [self.confirmPwdView addSubview:self.confirmResettingPwdbtn];
        
        //布局
        [self configSubView];
    }
    
    return self;
}

#pragma mark - 控件布局
-(void)configSubView
{
    [self.userPhone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self).multipliedBy(0.8);
        make.height.equalTo(@45);
        make.top.equalTo(@80);
        make.centerX.equalTo(self);
    }];
    
    [self.inputCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.userPhone.mas_width).offset(-100);
        make.height.equalTo(@45);
        make.top.equalTo(self.userPhone.mas_bottom).offset(20);
        make.left.equalTo(self.userPhone.mas_left);
    }];
    
    [self.getCode mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@100);
        make.height.equalTo(@45);
        make.top.equalTo(self.inputCode.mas_top);
        make.right.equalTo(self.userPhone.mas_right);
    }];
    
    [self.checkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self).multipliedBy(0.8);
        make.height.equalTo(@45);
        make.top.equalTo(self.getCode.mas_bottom).offset(60);
        make.centerX.equalTo(self);
    }];
    
    [self.confirmPwdView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self);
        make.height.equalTo(self).offset(-45);
        make.top.equalTo(@64);
        make.left.equalTo(self);
    }];
    
    [self.userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.confirmPwdView.mas_width).multipliedBy(0.8);
        make.height.equalTo(@35);
        make.top.equalTo(@40);
        make.centerX.equalTo(self.confirmPwdView.mas_centerX);
    }];
    
    [self.pwdField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.confirmPwdView.mas_width).multipliedBy(0.8);
        make.height.equalTo(@45);
        make.top.equalTo(self.userNameLabel.mas_bottom).offset(20);
       make.centerX.equalTo(self.confirmPwdView.mas_centerX);
    }];
    
    [self.confirmResettingPwdbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.confirmPwdView.mas_width).multipliedBy(0.8);
        make.height.equalTo(@45);
        make.top.equalTo(self.pwdField.mas_bottom).offset(20);
         make.centerX.equalTo(self.confirmPwdView.mas_centerX);
    }];
}

#pragma mark - touch Event 按钮点击事件
//点击空白处关闭键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self endEditing:YES];//结束编辑模式
}

//密码显示
-(void)showPassword:(UIButton *)sender
{
    self.pwdField.secureTextEntry = !self.pwdField.secureTextEntry;
    sender.selected = !sender.selected;
}

//获取验证码
-(void)getCode:(UIButton *)sender
{
    if (self.getCodeBtnClicked) {
        self.getCodeBtnClicked(self.userPhone.text);
    }
}

//校验验证码
-(void)chekeCodeInfo:(UIButton *)sender
{
    if (self.checkCodeBtnClicked) {
        self.checkCodeBtnClicked(self.userPhone.text,self.inputCode.text);
    }
}

//重置密码
-(void)resetPwd:(UIButton *)sender
{
    if (self.resettingPwdBtnClicked) {
        self.resettingPwdBtnClicked(self.userPhone.text, self.pwdField.text);
    }
}

#pragma mark - lazyload
-(UITextField *)userPhone {
    if (!_userPhone) {
        _userPhone = [[UITextField alloc] init];
        _userPhone.placeholder = TS("phone_num");
    }
    return _userPhone;
}

-(UITextField *)inputCode {
    if (!_inputCode) {
        _inputCode = [[UITextField alloc] init];
        _inputCode.placeholder = TS("input_code");
    }
    return _inputCode;
}

-(UIButton *)getCode {
    if (!_getCode) {
        _getCode = [[UIButton alloc] init];
        [_getCode setTitle:TS("get_code") forState:UIControlStateNormal];
        [_getCode setBackgroundColor:GlobalMainColor];
        _getCode.titleLabel.numberOfLines = 2 ;
        _getCode.titleLabel.font = [UIFont systemFontOfSize:15];
        [_getCode addTarget:self action:@selector(getCode:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _getCode;
}

-(UIButton *)checkBtn {
    if (!_checkBtn) {
        _checkBtn = [[UIButton alloc] init];
        [_checkBtn setTitle:TS("verify_pwd") forState:UIControlStateNormal];
        [_checkBtn setBackgroundColor:GlobalMainColor];
        _checkBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_checkBtn addTarget:self action:@selector(chekeCodeInfo:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _checkBtn;
    
}

- (UIView *)confirmPwdView{
    if (!_confirmPwdView) {
        _confirmPwdView = [[UIView alloc] init];
        _confirmPwdView.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:244.0/255.0 alpha:1];
        
    }
    return _confirmPwdView;
}

- (UILabel *)userNameLabel{
    if (!_userNameLabel) {
        _userNameLabel = [[UILabel alloc] init];
        _userNameLabel.text = TS("forget_username_is");
        _userNameLabel.textAlignment = NSTextAlignmentLeft;
        _userNameLabel.font = [UIFont systemFontOfSize:16];
    }
    return _userNameLabel;
}

-(UITextField *)pwdField {
    if (!_pwdField) {
        _pwdField = [[UITextField alloc]init];
        _pwdField.placeholder = TS("reset_user_psd");
        _pwdField.borderStyle = UITextBorderStyleRoundedRect;
        UIButton *showPwd = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
        [showPwd setImage:[UIImage imageNamed:@"icon_hide_nor.png"] forState:UIControlStateNormal];
        [showPwd setImage:[UIImage imageNamed:@"icon_hide_sel.png"] forState:UIControlStateSelected];
        [showPwd addTarget:self action:@selector(showPassword:) forControlEvents:UIControlEventTouchUpInside];
        _pwdField.secureTextEntry = YES;
        _pwdField.rightView = showPwd;
        _pwdField.rightViewMode = UITextFieldViewModeAlways;
    }
    return _pwdField;
}

- (UIButton *)confirmResettingPwdbtn {
    if (!_confirmResettingPwdbtn) {
        _confirmResettingPwdbtn = [[UIButton alloc] init];
        [_confirmResettingPwdbtn setTitle:TS("Sure_Reset") forState:UIControlStateNormal];
        _confirmResettingPwdbtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_confirmResettingPwdbtn setBackgroundColor:GlobalMainColor];
        [_confirmResettingPwdbtn addTarget:self action:@selector(resetPwd:) forControlEvents:UIControlEventTouchUpInside];
    }
    return  _confirmResettingPwdbtn;
}


@end
