//
//  RightRevealVC.m
//  MyInsight
//
//  Created by SongMenglong on 2017/12/1.
//  Copyright © 2017年 SongMenglong. All rights reserved.
//

#import "RightRevealVC.h"
#import <Masonry.h>
#import "UIColor+Category.h"

@interface RightRevealVC ()
// 标题
@property (nonatomic, strong) UILabel *titleLabel;
// 关于我
@property (nonatomic, strong) UILabel *aboutMeLabel;
// 邮箱地址
@property (nonatomic, strong) UILabel *emailLabel;
// 内容
@property (nonatomic, strong) UITextView *contentTestView;

@end

@implementation RightRevealVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor RandomColor]; // 设置背景颜色
    
    [self creatContentView];
    
    [self masonryLayout];
}

- (void)creatContentView {;
    // 标题
    self.titleLabel = [[UILabel alloc] init];
    [self.view addSubview:self.titleLabel];
    self.titleLabel.text = @"About Me";
    // 关于
    self.aboutMeLabel = [[UILabel alloc] init];
    [self.view addSubview:self.aboutMeLabel];
    self.aboutMeLabel.text = @"尘世迷茫程序员，汇集百家来开源。感谢大神写得好，俺们只是搬搬砖。";
    self.aboutMeLabel.numberOfLines = 0;
    // 邮箱
    self.emailLabel = [[UILabel alloc] init];
    [self.view addSubview:self.emailLabel];
    self.emailLabel.numberOfLines = 0;
    self.emailLabel.text = @"Email:983174628@qq.com";
}

#pragma mark - 代码约束布局
- (void)masonryLayout {
    // 标题
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.aboutMeLabel.mas_top).offset(-20.0f);
        make.left.equalTo(self.view.mas_left).offset(self.view.bounds.size.width*0.20f);
        make.right.equalTo(self.view.mas_right).offset(-10.0f);
    }];
    // 关于
    [self.aboutMeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view.mas_centerY).multipliedBy(0.7f);
        make.left.equalTo(self.view.mas_left).offset(self.view.bounds.size.width*0.20f);
        make.right.equalTo(self.view.mas_right).offset(-10.0f);
    }];
    // 邮箱
    [self.emailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.aboutMeLabel.mas_bottom).offset(10.0f);
        make.left.equalTo(self.view.mas_left).offset(self.view.bounds.size.width*0.20f);
        make.right.equalTo(self.view.mas_right).offset(-10.0f);
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
