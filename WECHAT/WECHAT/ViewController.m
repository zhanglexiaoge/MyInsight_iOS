//
//  ViewController.m
//  WECHAT
//
//  Created by SongMenglong on 2018/3/21.
//  Copyright © 2018年 SongMenglong. All rights reserved.
//

#import "ViewController.h"
#import "WXApi.h"

@interface ViewController ()

@property (nonatomic, strong) UIButton *loginButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"微信第三方登录");
    
    self.loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.loginButton];
    self.loginButton.frame = CGRectMake(100, 100, 150, 60);
    self.loginButton.backgroundColor = [UIColor purpleColor];
    [self.loginButton setTitle:@"LOGIN" forState:UIControlStateNormal];
    [self.loginButton setTitle:@"LOGIN" forState:UIControlStateSelected];
    [self.loginButton addTarget:self action:@selector(loginButtonAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)loginButtonAction:(UIButton *)button {
    // Login button action
    
    NSLog(@"Login Button Action");
    
    if ([WXApi isWXAppInstalled]) {
        SendAuthReq *req = [[SendAuthReq alloc] init];
        req.scope = @"snsapi_userinfo";
        req.state = @"App";
        [WXApi sendReq:req];
    } else {
        NSLog(@"WeChat Not Installed");
    }
    
}

/*
 手动集成微信第三方登录
 微信官方文档好用
 只不过 需要账号认证为开发者账号 此过程需要填写公司信息及企业代码
 俺没有 故放弃之
 2018年3月21日 记
 附录链接：
 iOS微信实现第三方登录的方法
 https://www.cnblogs.com/sunfuyou/p/7843612.html
 iOS接入指南
 https://open.weixin.qq.com/cgi-bin/showdocument?action=dir_list&t=resource/res_list&verify=1&id=1417694084&token=&lang=zh_CN
 */

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
