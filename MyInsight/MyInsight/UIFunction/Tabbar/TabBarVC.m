//
//  TabBarVC.m
//  MyInsight
//
//  Created by SongMenglong on 2017/12/1.
//  Copyright © 2017年 SongMenglong. All rights reserved.
//

#import "TabBarVC.h"

#import "BasicVC.h"
#import "AdvanceVC.h"
#import "SeniorVC.h"
#import "OtherVC.h"

@interface TabBarVC ()

@end

@implementation TabBarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Demo地址
    // https://github.com/NJHu/iOSProject
    
    self.view.backgroundColor = [UIColor whiteColor];
    // 基础
    BasicVC *basicVC = [[BasicVC alloc] init];
    UINavigationController *basicNavi = [[UINavigationController alloc] initWithRootViewController:basicVC];
    // 进阶
    AdvanceVC *advanceVC = [[AdvanceVC alloc] init];
    UINavigationController *advanceNavi = [[UINavigationController alloc] initWithRootViewController:advanceVC];
    // 高级
    SeniorVC *seniorVC = [[SeniorVC alloc] init];
    UINavigationController *seniorNavi = [[UINavigationController alloc] initWithRootViewController:seniorVC];
    // 其他
    OtherVC *otherVC = [[OtherVC alloc] init];
    UINavigationController *otherNavi = [[UINavigationController alloc] initWithRootViewController:otherVC];
    
    // 设置各个tabbar
    // 基础
    basicVC.tabBarItem.image = [UIImage imageNamed:@"home_nor"];
    basicVC.tabBarItem.selectedImage = [UIImage imageNamed:@"home_sel"];
    basicVC.tabBarItem.title = @"基础";
    basicVC.title = basicVC.tabBarItem.title;
    // 进阶
    advanceVC.tabBarItem.image = [UIImage imageNamed:@"mark_nor"];
    advanceVC.tabBarItem.selectedImage = [UIImage imageNamed:@"mark_sel"];
    advanceVC.tabBarItem.title = @"进阶";
    advanceVC.title = advanceVC.tabBarItem.title;
    // 高级
    seniorVC.tabBarItem.image = [UIImage imageNamed:@"mine_nor"];
    seniorVC.tabBarItem.selectedImage = [UIImage imageNamed:@"mine_sel"];
    seniorVC.tabBarItem.title = @"高级";
    seniorVC.title = seniorVC.tabBarItem.title;
    // 其他
    otherVC.tabBarItem.image = [UIImage imageNamed:@"setting_nor"];
    otherVC.tabBarItem.selectedImage = [UIImage imageNamed:@"setting_sel"];
    otherVC.tabBarItem.title = @"其他";
    otherVC.title = otherVC.tabBarItem.title;
    
    // 设置徽标
    [basicVC.navigationController.tabBarItem setBadgeValue:@"2"];
    
    // 设置tabbar
    [self setViewControllers:@[basicNavi, advanceNavi, seniorNavi, otherNavi] animated:NO];
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
