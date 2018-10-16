//
//  LandscapeScreenVC.m
//  MyInsight
//
//  Created by SongMenglong on 2017/12/2.
//  Copyright © 2017年 SongMenglong. All rights reserved.
//

#import "LandscapeScreenVC.h"
#import "AppDelegate.h"

@interface LandscapeScreenVC ()

@end

@implementation LandscapeScreenVC

//支持的方向
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskLandscapeRight;
}

//是否可以旋转
- (BOOL)shouldAutorotate {
    return YES;
}

//controller即将出现的时候旋转屏幕成横屏
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //采用KVO字段控制旋转 - 好处就是审核不会被拒绝
    NSNumber *orientationUnknown = [NSNumber numberWithInt:UIInterfaceOrientationUnknown];
    [[UIDevice currentDevice] setValue:orientationUnknown forKey:@"orientation"];
    NSNumber *orientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeRight];
    [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
}

//controller即将消失时将旋转屏幕成竖屏
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    AppDelegate *appdele = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appdele.isSupportHori = NO;
    //采用KVO字段控制旋转 - 好处就是审核不会被拒绝
    NSNumber *orientationUnknown = [NSNumber numberWithInt:UIInterfaceOrientationUnknown];
    [[UIDevice currentDevice] setValue:orientationUnknown forKey:@"orientation"];
    NSNumber *orientationTarget = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
    [[UIDevice currentDevice] setValue:orientationTarget forKey:@"orientation"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 横向屏幕
    
    self.title = @"竖屏";
    
    AppDelegate *appdele = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appdele.isSupportHori = YES;
    
    UITextField *textField = [[UITextField alloc] init];
    textField.backgroundColor =[UIColor orangeColor];
    textField.frame = CGRectMake(50, 50, [UIScreen mainScreen].bounds.size.width-100, 50);
    [self.view addSubview:textField];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame = CGRectMake(100, 120, 120, 100);
    backButton.backgroundColor = [UIColor purpleColor];
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
}

- (void)backButtonAction:(UIButton *)button {
    [self.view endEditing:YES];
    // 模态消失
    [self dismissViewControllerAnimated:NO completion:NULL];
    
    //[self.navigationController popViewControllerAnimated:YES];
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
