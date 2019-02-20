//
//  RegisterView.m
//  FunSDKDemo
//
//  Created by wujiangbo on 2018/10/27.
//  Copyright © 2018年 wujiangbo. All rights reserved.
//

#import "RegisterView.h"
#import "UserInputCell.h"
#import <Masonry/Masonry.h>

@interface RegisterView()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property (nonatomic, assign) int seqNum;
@end

@implementation RegisterView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
  
        self.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:self.tbSettings];
        [self addSubview:self.errorTipLabel];
        [self addSubview:self.registerBtn];
        [self addSubview:self.phoneTF];
        [self addSubview:self.codeTF];
        [self addSubview:self.getCodeBtn];
        [self addSubview:self.jumpBtn];
        [self addSubview:self.btnSelector];
        [self addSubview:self.lbDescription];
        [self addSubview:self.btnPrivacy];
        
        //布局
        [self configSubView];
    }
    
    return self;
}

#pragma mark - 控件布局
-(void)configSubView
{
    [self.tbSettings mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@110);
        make.width.equalTo(self).multipliedBy(0.9);
        make.height.equalTo(@144);
        make.centerX.equalTo(self);
    }];
    
    [self.errorTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@70);
        make.centerX.equalTo(self);
        make.width.equalTo(self).multipliedBy(0.9);
        make.height.equalTo(@40);
    }];
    
    [self.phoneTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tbSettings);
        make.width.equalTo(self).offset(-10).multipliedBy(0.67);
        make.height.equalTo(@45);
        make.top.equalTo(self.tbSettings.mas_bottom).offset(20);
    }];
    
    [self.codeTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.tbSettings);
        make.width.equalTo(self).offset(-10).multipliedBy(0.67);
        make.height.equalTo(@45);
        make.top.equalTo(self.tbSettings.mas_bottom).offset(20);
    }];
    
    [self.getCodeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.tbSettings);
        make.width.equalTo(self).offset(-10).multipliedBy(0.33);
        make.height.equalTo(@45);
        make.top.equalTo(self.phoneTF);
    }];
    
    [self.registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneTF.mas_bottom).offset(50);
        make.width.equalTo(self).multipliedBy(0.9);
        make.height.equalTo(@45);
        make.centerX.equalTo(self);
    }];
    
    [self.jumpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneTF.mas_bottom).offset(10);
        make.width.equalTo(self).multipliedBy(0.9);
        make.centerX.equalTo(self);
        make.height.equalTo(@25);
    }];
    
    [self.btnSelector mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.registerBtn.mas_left);
        make.width.equalTo(@40);
        make.height.equalTo(@40);
        make.top.equalTo(self.registerBtn.mas_bottom).offset(20);
    }];

    [self.lbDescription mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.btnSelector.mas_right);
        make.width.equalTo(@100);
        make.height.equalTo(@40);
        make.centerY.equalTo(self.btnSelector.mas_centerY);
    }];

    [self.btnPrivacy mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lbDescription.mas_right);
        make.width.equalTo(@150);
        make.height.equalTo(@40);
        make.centerY.equalTo(self.btnSelector.mas_centerY);
    }];
}

//密码显示
-(void)showPassword
{
    self.pwdTF.secureTextEntry = !self.pwdTF.secureTextEntry;
    UserInputCell *cell1 = [self.tbSettings cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    cell1.toggleBtn.selected = !cell1.toggleBtn.selected;
    
    self.confrimTF.secureTextEntry = !self.confrimTF.secureTextEntry;
    UserInputCell *cell2 = [self.tbSettings cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    cell2.toggleBtn.selected = !cell2.toggleBtn.selected;
}

#pragma mark - tableViewDataSource/Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 3;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 48;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UserInputCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserInputCell"];
    switch (indexPath.row) {
        case 0:
        {
            cell.customTitle.text = TS("username");
            cell.customTitle.adjustsFontSizeToFitWidth = YES;
            cell.inputTextField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:TS("UserInputTip") attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}];
            cell.inputTextField.delegate = self;
            cell.inputTextField.text = [[NSUserDefaults standardUserDefaults]stringForKey:@"registerName"];
            self.userNameTF = cell.inputTextField;
            [self.userNameTF addTarget:self action:@selector(textFieldTextDidChange:) forControlEvents:UIControlEventEditingChanged];
            cell.toggleBtn.hidden = YES;
        }
            break;
            
        case 1:
        {
            cell.customTitle.text = TS("password");
            cell.customTitle.adjustsFontSizeToFitWidth = YES;
            cell.inputTextField.attributedPlaceholder = [[NSAttributedString alloc]initWithString:TS("PwdInputTip") attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}];
            cell.inputTextField.secureTextEntry = YES;
            cell.inputTextField.text = [[NSUserDefaults standardUserDefaults]stringForKey:@"registerPwd"];
            self.pwdTF = cell.inputTextField;
            cell.toggleBtn.hidden = NO;
            [cell.toggleBtn addTarget:self action:@selector(showPassword) forControlEvents:UIControlEventTouchUpInside];
        }
            break;
            
        default:
        {
            cell.customTitle.text = TS("confirm_psd");
            cell.inputTextField.attributedPlaceholder =[[NSAttributedString alloc]initWithString:TS("PwdInputTip2") attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}];
            cell.inputTextField.secureTextEntry = YES;
            cell.inputTextField.text = [[NSUserDefaults standardUserDefaults]stringForKey:@"registerConfirm"];
            cell.customTitle.adjustsFontSizeToFitWidth = YES;
            self.confrimTF = cell.inputTextField;
            cell.toggleBtn.hidden = NO;
            [cell.toggleBtn addTarget:self action:@selector(showPassword) forControlEvents:UIControlEventTouchUpInside];
        }
            break;
    }
    return cell;
}

#pragma mark - UITextFieldDelegate

-(void)textFieldTextDidChange:(UITextField *)sender {
    self.errorTipLabel.text = @"";
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

#pragma mark - button event
-(void)registerBtnClicked:(UIButton *)sender
{
    if (self.btnSelector.selected) {
        [SVProgressHUD showErrorWithStatus:TS("Please_agree_privacy_policy")];
        return;
    }
    if (self.registerBtnClicked) {
        self.registerBtnClicked(self.userNameTF.text, self.pwdTF.text, self.confrimTF.text, self.phoneTF.text, self.codeTF.text);
    }
}

-(void)getCodeBtnClicked:(UIButton *)sender
{
    self.jumpBtn.hidden = YES;
    if (self.getCodeBtnClicked) {
        self.getCodeBtnClicked(self.phoneTF.text);
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self endEditing:YES];
}

-(void)jumpBtnClicked:(UIButton *)sender
{
    sender.selected = !sender.selected;
}

-(void)btnSelectorClicked:(UIButton *)sender
{
    sender.selected = !sender.selected;
}

-(void)btnPrivacyClicked:(UIButton *)sender
{
    if (self.btnPrivacyBtnClicked) {
        self.btnPrivacyBtnClicked();
    }
}

#pragma mark - lazyLoad
-(UITableView *)tbSettings {
    if (!_tbSettings) {
        _tbSettings = [[UITableView alloc] init];
        _tbSettings.delegate = self;
        _tbSettings.dataSource = self;
        _tbSettings.scrollEnabled = NO;
        _tbSettings.layer.cornerRadius = 4;
        _tbSettings.allowsSelection = NO;
        [_tbSettings registerClass:[UserInputCell class] forCellReuseIdentifier:@"UserInputCell"];
    }
    
    return _tbSettings;
}

-(UILabel *)errorTipLabel
{
    if (!_errorTipLabel) {
        _errorTipLabel = [[UILabel alloc] init];
        _errorTipLabel.text = @"";
        _errorTipLabel.textAlignment = NSTextAlignmentCenter;
        _errorTipLabel.textColor = [UIColor redColor];
        _errorTipLabel.numberOfLines = 0;
        _errorTipLabel.font = [UIFont systemFontOfSize:12];
    }
    
    return _errorTipLabel;
}

-(UITextField *)phoneTF
{
    if (!_phoneTF) {
        _phoneTF = [[UITextField alloc] init];
        _phoneTF.placeholder = TS("phone_num");
        _phoneTF.backgroundColor = [UIColor whiteColor];
        _phoneTF.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 8, 0)];
        _phoneTF.leftViewMode = UITextFieldViewModeAlways;
    }
    
    return _phoneTF;
}

-(UITextField *)codeTF
{
    if (!_codeTF) {
        _codeTF = [[UITextField alloc] init];
        _codeTF.placeholder = TS("input_code");
        _codeTF.hidden = YES;
        _codeTF.backgroundColor = [UIColor whiteColor];
    }
    
    return _codeTF;
}

-(UIButton *)getCodeBtn
{
    if (!_getCodeBtn) {
        _getCodeBtn = [[UIButton alloc] init];
        _getCodeBtn.layer.cornerRadius = 5;
        [_getCodeBtn setTitle:TS("get_code") forState:UIControlStateNormal];
        [_getCodeBtn setBackgroundColor:GlobalMainColor];
        [_getCodeBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [_getCodeBtn addTarget:self action:@selector(getCodeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _getCodeBtn;
}

-(UIButton *)registerBtn
{
    if (!_registerBtn) {
        _registerBtn = [[UIButton alloc] init];
        [_registerBtn setTitle:TS("register") forState:UIControlStateNormal];
        [_registerBtn setBackgroundColor:GlobalMainColor];
        [_registerBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [_registerBtn addTarget:self action:@selector(registerBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _registerBtn;
}

-(UIButton *)btnSelector
{
    if (!_btnSelector) {
        _btnSelector = [[UIButton alloc] init];
        [_btnSelector setImage:[UIImage imageNamed:@"sel.png"] forState:UIControlStateNormal];
        [_btnSelector setImage:[UIImage imageNamed:@"nor.png"] forState:UIControlStateSelected];
        [_btnSelector addTarget:self action:@selector(btnSelectorClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_btnSelector setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    }
    
    return _btnSelector;
}

-(UILabel *)lbDescription
{
    if (!_lbDescription) {
        _lbDescription = [[UILabel alloc] init];
        [_lbDescription setText:TS("I_Have_Agreed")];
        _lbDescription.font = [UIFont systemFontOfSize:13];
    }
    
    return _lbDescription;
}

-(UIButton *)btnPrivacy
{
    if (!_btnPrivacy) {
        _btnPrivacy = [[UIButton alloc] init];
        [_btnPrivacy setTitle:TS("Privacy_Policy") forState:UIControlStateNormal];
        [_btnPrivacy setTitleColor:GlobalMainColor forState:UIControlStateNormal];
        [_btnPrivacy setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        _btnPrivacy.titleLabel.font = [UIFont systemFontOfSize:12];
        [_btnPrivacy addTarget:self action:@selector(btnPrivacyClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _btnPrivacy;
}

-(UIButton *)jumpBtn
{
    if (!_jumpBtn) {
        _jumpBtn = [[UIButton alloc] init];
        _jumpBtn.layer.cornerRadius = 5;
        _jumpBtn.hidden = YES;
        _jumpBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_jumpBtn setImage:[UIImage imageNamed:@"nor.png"] forState:UIControlStateNormal];
        [_jumpBtn setImage:[UIImage imageNamed:@"sel.png"] forState:UIControlStateSelected];
        [_jumpBtn setTitle:TS("Jump_RegCode") forState:UIControlStateNormal];
        [_jumpBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [_jumpBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [_jumpBtn addTarget:self action:@selector(jumpBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _jumpBtn;
}

@end
