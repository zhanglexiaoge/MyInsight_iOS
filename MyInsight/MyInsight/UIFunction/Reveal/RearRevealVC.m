//
//  RearRevealVC.m
//  MyInsight
//
//  Created by SongMenglong on 2017/12/1.
//  Copyright © 2017年 SongMenglong. All rights reserved.
//

#import "RearRevealVC.h"
#import <Masonry.h>
#import "UIColor+Category.h"
#import "Header.h" // 头文件

@interface RearRevealVC ()

// 微信
@property (nonatomic, strong) UILabel *qrcodeLabel;
// 微信二维码
@property (nonatomic, strong) UIImageView *qrcodeImageView;
// 收付款
@property (nonatomic, strong) UILabel *payLabel;
// 收付款二维码
@property (nonatomic, strong) UIImageView *payImageView;

@end

@implementation RearRevealVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor RandomColor]; // 设置背景颜色
    
    [self creatView];
    
    [self masonryLayout];
}

- (void)creatView {
    // 初始化控件
    self.qrcodeLabel = [[UILabel alloc] init];
    [self.view addSubview:self.qrcodeLabel];
    self.qrcodeLabel.text = @"WeChat";
    
    self.qrcodeImageView = [[UIImageView alloc] init];
    [self.view addSubview:self.qrcodeImageView];
    self.qrcodeImageView.image = [UIImage imageNamed:@"selfcode"];
    
    self.payLabel = [[UILabel alloc] init];
    [self.view addSubview:self.payLabel];
    self.payLabel.text = @"Pay";
    
    self.payImageView = [[UIImageView alloc] init];
    [self.view addSubview:self.payImageView];
    self.payImageView.image = [UIImage imageNamed:@"shouqian"];
}

- (void)masonryLayout {
    [self.qrcodeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.qrcodeImageView.mas_centerX).multipliedBy(1.0f);
        make.bottom.equalTo(self.qrcodeImageView.mas_top).offset(-20.0f);
    }];
    
    [self.qrcodeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX).multipliedBy(0.85f);
        make.centerY.equalTo(self.view.mas_centerY).multipliedBy(0.7f);
        make.width.equalTo(self.view.mas_width).multipliedBy(0.40f);
        make.height.equalTo(self.view.mas_width).multipliedBy(0.40f);
    }];
    
    [self.payLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.qrcodeImageView.mas_centerX).multipliedBy(1.0f);
        make.top.equalTo(self.qrcodeImageView.mas_bottom).offset(20.0f);
    }];
    
    [self.payImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.qrcodeImageView.mas_centerX).multipliedBy(1.0f);
        make.top.equalTo(self.payLabel.mas_bottom).offset(20.0f);
        make.width.equalTo(self.view.mas_width).multipliedBy(0.40f);
        make.height.equalTo(self.view.mas_width).multipliedBy(0.40f);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
