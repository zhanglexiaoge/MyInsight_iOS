//
//  AlarmMessagePicViewController.m
//  FunSDKDemo
//
//  Created by wujiangbo on 2018/12/3.
//  Copyright © 2018 wujiangbo. All rights reserved.
//

#import "AlarmMessagePicViewController.h"
#import <Masonry/Masonry.h>

@interface AlarmMessagePicViewController ()

@end

@implementation AlarmMessagePicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];

    //设置导航栏样式
    [self setNaviStyle];
    
    //布局
    [self.view addSubview:self.imageV];
    [self configSubviews];
}

- (void)setNaviStyle {
    self.navigationItem.title = TS("Alarm_picture");
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"new_back.png"] style:UIBarButtonItemStylePlain target:self action:@selector(popViewController)];
    self.navigationItem.leftBarButtonItem = leftBtn;
}

-(void)configSubviews{
    [self.imageV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view);
        make.height.equalTo(self.view.mas_width).multipliedBy(0.6);
        make.centerY.equalTo(self.view.mas_centerY);
        make.left.equalTo(self);
    }];
}

#pragma mark - button event
#pragma mark 点击返回上层
-(void)popViewController{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - lazyload
- (UIImageView *)imageV{
    if (!_imageV) {
        _imageV = [[UIImageView alloc] init];
        _imageV.image = [UIImage imageNamed:@"icon_funsdk.png"];
    }
    
    return _imageV;
}

@end
