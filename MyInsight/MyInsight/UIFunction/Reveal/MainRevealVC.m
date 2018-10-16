//
//  MainRevealVC.m
//  MyInsight
//
//  Created by SongMenglong on 2017/12/1.
//  Copyright © 2017年 SongMenglong. All rights reserved.
//

#import "MainRevealVC.h"
#import "TabBarVC.h" // 用作主界面
#import "RearRevealVC.h" // 左边
#import "RightRevealVC.h" // 右边

@interface MainRevealVC ()

@end

@implementation MainRevealVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //  iOS之UI--使用SWRevealViewController 实现侧边菜单功能详解实例 https://www.cnblogs.com/LiLihongqiang/p/5905547.html
    // 主页面
    TabBarVC *tabbarVC = [[TabBarVC alloc] init];
    //UINavigationController *tabbarNavi = [[UINavigationController alloc] initWithRootViewController:tabbarVC];
    // 左边侧滑页
    RearRevealVC *rearRevealVC = [[RearRevealVC alloc] init];
    // 右边侧滑页
    RightRevealVC *rightRevealVC = [[RightRevealVC alloc] init];
    
    //  左右抽屉显示宽度
    self.rearViewRevealWidth = [UIScreen mainScreen].bounds.size.width*0.70f;
    self.rightViewRevealWidth = [UIScreen mainScreen].bounds.size.width*0.70f;
    
    // 添加手势
    tabbarVC.view.userInteractionEnabled = YES;
    [tabbarVC.view addGestureRecognizer:[self panGestureRecognizer]];
    [tabbarVC.view addGestureRecognizer:[self tapGestureRecognizer]];
    
    [self setFrontViewController:tabbarVC animated:YES]; // 主页面
    [self setRearViewController:rearRevealVC animated:YES]; // 左侧边
    [self setRightViewController:rightRevealVC animated:YES]; // 右侧边
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
