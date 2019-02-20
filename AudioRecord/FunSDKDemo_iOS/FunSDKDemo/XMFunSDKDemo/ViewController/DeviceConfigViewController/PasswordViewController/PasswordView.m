//
//  PasswordView.m
//  FunSDKDemo
//
//  Created by XM on 2018/11/17.
//  Copyright © 2018年 XM. All rights reserved.
//

#import "PasswordView.h"
#import "UserInputCell.h"
#import <Masonry/Masonry.h>

@interface  PasswordView()  <UITableViewDelegate,UITableViewDataSource>

@end
@implementation PasswordView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:self.tbPassWord];
        [self addSubview:self.changePwdBtn];
        
        //布局
        [self configSubView];
    }
    
    return self;
}

#pragma mark - 控件布局
-(void)configSubView
{
    [self.tbPassWord mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@110);
        make.width.equalTo(self).multipliedBy(0.9);
        make.height.equalTo(@192);
        make.centerX.equalTo(self);
    }];
    
    [self.changePwdBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tbPassWord.mas_bottom).offset(60);
        make.width.equalTo(self).multipliedBy(0.9);
        make.height.equalTo(@45);
        make.centerX.equalTo(self);
    }];
}

#pragma mark - button Event
//点击密码修改按钮
-(void)changePwdBtnClicked:(UIButton *)sender
{
    if (self.changePwdClicked) {
        self.changePwdClicked(self.pwdOldTF.text, self.pwdNewTF.text, self.confrimTF.text);
    }
}

//点击空白处隐藏键盘
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self endEditing:YES];
}

#pragma mark - tableViewDataSource/Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 4;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 48;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UserInputCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserInputCell"];
    switch (indexPath.row) {
        case 0:
        {
            cell.customTitle.text = TS("Device_Name");
            cell.customTitle.adjustsFontSizeToFitWidth = YES;
            cell.inputTextField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:@"" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}];
            ChannelObject *channel = [[DeviceControl getInstance] getSelectChannel];
            cell.inputTextField.text = channel.loginName;
            cell.inputTextField.enabled = NO;
            cell.toggleBtn.hidden = YES;
        }
            break;
        case 1:
        {
            cell.customTitle.text = TS("Old_Password");
            cell.customTitle.adjustsFontSizeToFitWidth = YES;
            cell.inputTextField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:TS("Old_Password") attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}];
            
            self.pwdOldTF = cell.inputTextField;
            cell.toggleBtn.hidden = YES;
        }
            break;
            
        case 2:
        {
            cell.customTitle.text = TS("New_Password");
            cell.customTitle.adjustsFontSizeToFitWidth = YES;
            cell.inputTextField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:TS("PwdInputTip") attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}];
            cell.inputTextField.secureTextEntry = YES;
            self.pwdNewTF = cell.inputTextField;
            cell.toggleBtn.hidden = NO;
            [cell.toggleBtn addTarget:self action:@selector(showPassword) forControlEvents:UIControlEventTouchUpInside];
        }
            break;
            
        default:
        {
            cell.customTitle.text = TS("New_Password");
            cell.customTitle.adjustsFontSizeToFitWidth = YES;
            cell.inputTextField.attributedPlaceholder =[[NSAttributedString alloc]initWithString:TS("PwdInputTip2") attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}];
            cell.inputTextField.secureTextEntry = YES;
            self.confrimTF = cell.inputTextField;
            cell.toggleBtn.hidden = NO;
            [cell.toggleBtn addTarget:self action:@selector(showPassword) forControlEvents:UIControlEventTouchUpInside];
        }
            break;
    }
    return cell;
}

//显示密码
-(void)showPassword
{
    self.pwdNewTF.secureTextEntry = !self.pwdNewTF.secureTextEntry;
    UserInputCell *cell1 = [self.tbPassWord cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    cell1.toggleBtn.selected = !cell1.toggleBtn.selected;
    
    self.confrimTF.secureTextEntry = !self.confrimTF.secureTextEntry;
    UserInputCell *cell2 = [self.tbPassWord cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    cell2.toggleBtn.selected = !cell2.toggleBtn.selected;
}

#pragma mark - LazyLoad
-(UITableView *)tbPassWord {
    if (!_tbPassWord) {
        _tbPassWord = [[UITableView alloc] init];
        _tbPassWord.delegate = self;
        _tbPassWord.dataSource = self;
        _tbPassWord.scrollEnabled = NO;
        _tbPassWord.layer.cornerRadius = 4;
        _tbPassWord.allowsSelection = NO;
        [_tbPassWord registerClass:[UserInputCell class] forCellReuseIdentifier:@"UserInputCell"];
    }
    
    return _tbPassWord;
}

-(UIButton *)changePwdBtn
{
    if (!_changePwdBtn) {
        _changePwdBtn = [[UIButton alloc] init];
        [_changePwdBtn setTitle:TS("Modify_pwd") forState:UIControlStateNormal];
        [_changePwdBtn setBackgroundColor:GlobalMainColor];
        [_changePwdBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [_changePwdBtn addTarget:self action:@selector(changePwdBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _changePwdBtn;
}

@end
