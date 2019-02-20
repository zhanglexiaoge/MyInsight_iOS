//
//  UserBindView.m
//  FunSDKDemo
//
//  Created by wujiangbo on 2018/11/2.
//  Copyright © 2018年 wujiangbo. All rights reserved.
//

#import "UserBindView.h"
#import <Masonry/Masonry.h>

@implementation UserBindView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:self.phoneEmailTF];
        [self addSubview:self.codeTF];
        [self addSubview:self.getCodeBtn];
        [self addSubview:self.bindBtn];
        //布局
        [self configSubView];
    }
    
    return self;
}

#pragma mark - 控件布局
-(void)configSubView
{
    [self.phoneEmailTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@20);
        make.width.equalTo(self).offset(-40);
        make.height.equalTo(@40);
        make.top.equalTo(@84);
    }];
    
    [self.codeTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@20);
        make.width.equalTo(self).offset(-150);
        make.height.equalTo(@40);
        make.top.equalTo(self.phoneEmailTF.mas_bottom).offset(10);
    }];
    
    [self.getCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.codeTF.mas_right).offset(10);
        make.width.equalTo(@100);
        make.height.equalTo(@40);
        make.top.equalTo(self.codeTF.mas_top);
    }];
    
    [self.bindBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@20);
        make.width.equalTo(self).offset(-40);
        make.height.equalTo(@40);
        make.top.equalTo(self.codeTF.mas_bottom).offset(20);
    }];
}

#pragma mark - button Event
//绑定按钮点击
-(void)bindBtnClick:(UIButton *)sender
{
    if (self.bindBtnClicked) {
        self.bindBtnClicked(self.phoneEmailTF.text, self.codeTF.text);
    }
}

//获取验证码
-(void)getCodeBtnClick:(UIButton *)sender
{
    if (self.getCodeBtnClicked) {
        self.getCodeBtnClicked(self.phoneEmailTF.text);
    }
}

#pragma mark - lazyload 懒加载
-(UITextField *)phoneEmailTF{
    if (!_phoneEmailTF) {
        _phoneEmailTF = [[UITextField alloc] init];
        _phoneEmailTF.layer.borderColor = [[UIColor colorWithRed:179/255.0 green:179/255.0 blue:179/255.0 alpha:1] CGColor];
        _phoneEmailTF.layer.borderWidth = 1;
        _phoneEmailTF.layer.cornerRadius = 5;
        _phoneEmailTF.placeholder = TS("Please_enter_your_email_address");
        //防止文字和边框对齐
        UIView *blankView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 40)];
        _phoneEmailTF.leftViewMode = UITextFieldViewModeAlways;
        blankView.backgroundColor = [UIColor clearColor];
        _phoneEmailTF.leftView = blankView;
    }
    return _phoneEmailTF;
}

-(UITextField *)codeTF{
    if (!_codeTF) {
        _codeTF = [[UITextField alloc] init];
        _codeTF.layer.borderColor = [[UIColor colorWithRed:179/255.0 green:179/255.0 blue:179/255.0 alpha:1] CGColor];
        _codeTF.placeholder = TS("input_code");
        _codeTF.layer.borderWidth = 1;
        _codeTF.layer.cornerRadius = 5;
        
        UIView *blankView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 40)];
        blankView.backgroundColor = [UIColor clearColor];
        _codeTF.leftViewMode = UITextFieldViewModeAlways;
        _codeTF.leftView = blankView;
    }
    return _codeTF;
}

-(UIButton *)getCodeBtn{
    if (!_getCodeBtn) {
        _getCodeBtn = [[UIButton alloc] init];
        _getCodeBtn.layer.borderColor = [[UIColor colorWithRed:179/255.0 green:179/255.0 blue:179/255.0 alpha:1] CGColor];
        [_getCodeBtn setTitle:TS("get_code") forState:UIControlStateNormal];
        _getCodeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [_getCodeBtn setBackgroundColor:GlobalMainColor];
        _getCodeBtn.layer.cornerRadius = 5;
        _getCodeBtn.layer.borderWidth = 1;
        
        [_getCodeBtn addTarget:self action:@selector(getCodeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _getCodeBtn;
}

-(UIButton *)bindBtn{
    if (!_bindBtn) {
        _bindBtn = [[UIButton alloc] init];
        [_bindBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _bindBtn.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [_bindBtn setBackgroundColor:GlobalMainColor];
        _bindBtn.layer.cornerRadius = 5;
        [_bindBtn setTitle:TS("bind_email_address") forState:UIControlStateNormal];
        [_bindBtn addTarget:self action:@selector(bindBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bindBtn;
}


@end
