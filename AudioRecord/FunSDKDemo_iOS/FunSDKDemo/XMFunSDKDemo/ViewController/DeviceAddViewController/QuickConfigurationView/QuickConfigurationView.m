//
//  QuickConfigurationView.m
//  FunSDKDemo
//
//  Created by wujiangbo on 2018/11/15.
//  Copyright © 2018年 wujiangbo. All rights reserved.
//

#import "QuickConfigurationView.h"
#import <Masonry/Masonry.h>
#import "NSString+Category.h"

@implementation QuickConfigurationView
{
    NSTimer *_myTimer;           // 动画计时器
    int _myATime;                // 动画进行时间
    BOOL _configing;             // 是否正在配置
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        _configing = NO;
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.wifiLab];
        [self addSubview:self.wifiTF];
        [self addSubview:self.passwordLab];
        [self addSubview:self.passwordTF];
        [self addSubview:self.tipsLab];
        [self addSubview:self.startBtn];
        
        //控件布局
        [self configSubView];
    }
    
    return self;
}

#pragma mark-控件布局
-(void)configSubView{
    [self.wifiLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@20);
        make.top.equalTo(@100);
        make.width.equalTo(@80);
        make.height.equalTo(@30);
    }];
    
    [self.wifiTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.wifiLab.mas_right).offset(5);
        make.centerY.equalTo(self.wifiLab.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-20);
        make.height.equalTo(@30);
    }];
    
    [self.passwordLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@20);
        make.top.equalTo(self.wifiLab.mas_bottom).offset(5);
        make.width.equalTo(@80);
        make.height.equalTo(@30);
    }];
    
    [self.passwordTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.passwordLab.mas_right).offset(5);
        make.centerY.equalTo(self.passwordLab.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-20);
        make.height.equalTo(@30);
    }];
    
    [self.tipsLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.passwordLab.mas_bottom).offset(30);
        make.left.equalTo(@20);
        make.right.equalTo(self.mas_right).offset(-20);
        make.height.equalTo(@100);
    }];
    
    [self.startBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tipsLab.mas_bottom).offset(50);
        make.width.equalTo(self).multipliedBy(0.9);
        make.height.equalTo(@45);
        make.centerX.equalTo(self);
    }];
}

#pragma mark - touch event
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self endEditing:YES];
}

#pragma mark 开始快速配置
-(void)startConfigurationClicked{
    [self endEditing:YES];
    if (self.passwordTF.text.length == 0 || self.wifiTF.text.length == 0) {
        [SVProgressHUD showErrorWithStatus:TS("EE_ACCOUNT_PARMA_ABNORMAL")];
        return;
    }
    [self createPlayView];
    [self.radarView startSeek];
    _myATime = 120;
    _myTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(myTimeCount:) userInfo:nil repeats:YES];
    if (self.startConfig) {
        self.startConfig(self.wifiTF.text, self.passwordTF.text);
    }
}
#pragma mark 停止快速配置
-(void)stopConfigurationClicked{
    if (_myTimer != nil) {
        [_myTimer invalidate];
    }
    [self cancelAPAction];
}

#pragma mark 快速配置成功，停止计时
-(void)stopTiming{
    if (_myTimer != nil) {
        [_myTimer invalidate];
    }
    _myATime = 0;
    self.countLab.text = @"";
    _configing = NO;
}

#pragma mark 配置计时
-(void)myTimeCount:(NSTimer*)timer{
    _myATime = _myATime - 1;
    // 判断是否正在配置 倒计时大于零 说明在配置
    if (_myATime >= 0) {
        _configing = YES;
    }else{
        _configing = NO;
    }
    if (_myATime < 0) {
        //  快速配置失败
        [timer invalidate];
        [self cancelAPAction];
    }
    self.countLab.text = [NSString stringWithFormat:@"%i",_myATime];
}

#pragma mark 取消快速配置
-(void)cancelAPAction{
    _myATime = 0;
    self.countLab.text = @"";
    self.radarView.hidden = YES;
    _configing = NO;
    if (self.stopConfig) {
        self.stopConfig();
    }
}

#pragma mark 点击配网成功的设备
-(void)btnDeviceAction:(UIButton *)sender{
    [self cancelAPAction];
    if(self.addDevice){
        self.addDevice();
    }
}

#pragma mark - 初始化数据
-(void)createPlayView{
    if (self.radarView  == nil) {
        self.radarView = [[MyRadarView alloc] initWithFrame:CGRectMake(0, NavHeight, ScreenWidth, ScreenHeight - NavHeight)];
        self.radarView.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.radarView];
        
        UIButton *cancel = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 40)];
        cancel.center = CGPointMake(self.radarView.frame.size.width * 0.5, self.radarView.frame.size.height - 70);
        [cancel setTitleColor:[UIColor colorWithRed:100/255.0 green:164/255.0 blue:230/255.0 alpha:1] forState:UIControlStateNormal];
        cancel.backgroundColor = [UIColor clearColor];
        [cancel setTitle:TS("Cancel") forState:UIControlStateNormal];
        cancel.tag = 101010;
        [cancel addTarget:self action:@selector(stopConfigurationClicked) forControlEvents:UIControlEventTouchUpInside];
        
        [self.radarView addSubview:cancel];
        
        self.configTipsLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 35)];
        self.configTipsLab.textColor = [UIColor whiteColor];
        self.configTipsLab.textAlignment = NSTextAlignmentCenter;
        self.configTipsLab.center = CGPointMake(ScreenWidth * 0.5, self.radarView.frame.size.height - 90);
        self.configTipsLab.backgroundColor = [UIColor colorWithRed:54/255.0 green:54/255.0 blue:54/255.0 alpha:1];
        [self.radarView addSubview:self.configTipsLab];
        
        if ([NSString checkSSID:[NSString getCurrent_SSID]]) {
            cancel.hidden = YES;
            self.configTipsLab.hidden = NO;
        }else{
            cancel.hidden = NO;
            self.configTipsLab.hidden = YES;
        }
        
        UIImageView *phone = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth * 0.125 , ScreenWidth * 0.125)];
        phone.center = CGPointMake(self.radarView.frame.size.width * 0.5, self.radarView.frame.size.height * 0.5);
        [self.radarView addSubview:phone];
        
        self.countLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 50)];
        self.countLab.font = [UIFont fontWithName:@"Helvetica-BoldOblique" size:20];
        self.countLab.backgroundColor = [UIColor clearColor];
        self.countLab.textAlignment = NSTextAlignmentCenter;
        self.countLab.textColor = [UIColor whiteColor];
        self.countLab.center = phone.center;
        [self.radarView addSubview:self.countLab];
    }
    
    if (self.btnArray == nil) {
        self.btnArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    for (int i = 0; i < self.btnArray.count; i ++) {
        [[self.btnArray objectAtIndex:i] removeFromSuperview];
    }
    [self.btnArray removeAllObjects];
    
    self.radarView.hidden = NO;
    //有设备则显示设备图标按钮
    for (int i = 0; i < self.deviceArray.count; i ++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        btn.tag = i;
        CGPoint btnPoint = CGPointMake(-20, -20);
        double sum;
        for (int i = 0; i < 99999999; i ++) {
            btnPoint = [self getPoint];
            double x = ((btnPoint.x - ScreenWidth * 0.5)*(btnPoint.x - ScreenWidth * 0.5));
            double y = (btnPoint.y - self.radarView.frame.size.height * 0.5)*(btnPoint.y - self.radarView.frame.size.height * 0.5);
            sum = x + y;
            if ((sqrt(sum) < ScreenWidth * 0.375)) {
                break;
            }
        }
        
        btn.center = btnPoint;
        [btn setBackgroundImage:[UIImage imageNamed:@"phone2.png"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnDeviceAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.btnArray addObject:btn];
        [self.radarView addSubview:btn];
    }
}

//随机获取坐标
-(CGPoint)getPoint{
    CGPoint point;
    CGFloat mX = arc4random()%(int)(ScreenWidth * 0.875) + ScreenWidth * 0.125;
    CGFloat mY = arc4random()%(int)(ScreenHeight - 64 - ScreenWidth * 0.125) + ScreenWidth * 0.125;
    point.x = mX;
    point.y = mY;
    return point;
}

#pragma mark - lazyload
-(UILabel *)wifiLab{
    if (!_wifiLab) {
        _wifiLab = [[UILabel alloc] init];
        _wifiLab.text = TS("WIFI:");
    }
    
    return _wifiLab;
}

-(UILabel *)passwordLab{
    if (!_passwordLab) {
        _passwordLab = [[UILabel alloc] init];
        _passwordLab.text = TS("Password2");
    }
    
    return _passwordLab;
}

-(UITextField *)wifiTF{
    if (!_wifiTF) {
        _wifiTF = [[UITextField alloc] init];
        _wifiTF.attributedPlaceholder = [[NSAttributedString alloc]initWithString:TS("") attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    }
    
    return _wifiTF;
}

-(UITextField *)passwordTF{
    if (!_passwordTF) {
        _passwordTF = [[UITextField alloc] init];
        _passwordTF.attributedPlaceholder = [[NSAttributedString alloc]initWithString:TS("Enter_WIFIPassword") attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];
    }
    
    return _passwordTF;
}

-(UILabel *)tipsLab{
    if (!_tipsLab) {
        _tipsLab = [[UILabel alloc] init];
        _tipsLab.numberOfLines = 0;
        _tipsLab.font = [UIFont systemFontOfSize:14];
        _tipsLab.text = TS("wifi_config_tip");
    }
    
    return _tipsLab;
}

-(UIButton *)startBtn{
    if (!_startBtn) {
        _startBtn = [[UIButton alloc] init];
        [_startBtn setTitle:TS("OK") forState:UIControlStateNormal];
        [_startBtn setBackgroundColor:GlobalMainColor];
        [_startBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
        [_startBtn addTarget:self action:@selector(startConfigurationClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _startBtn;
}

-(NSMutableArray *)deviceArray{
    if (!_deviceArray) {
        _deviceArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    
    return _deviceArray;
}

@end
