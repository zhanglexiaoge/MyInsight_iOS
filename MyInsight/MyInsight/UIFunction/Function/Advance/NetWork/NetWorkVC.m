//
//  NetWorkVC.m
//  MyInsight
//
//  Created by SongMenglong on 2018/4/17.
//  Copyright © 2018年 SongMenglong. All rights reserved.
//

#import "NetWorkVC.h"
#import "AFNetWorkVC.h"

@interface NetWorkVC ()

@end

@implementation NetWorkVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"网络请求";
    
    [self afNetWorkButton];
}

- (void)afNetWorkButton {
    UIButton *afNetButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:afNetButton];
    afNetButton.frame = CGRectMake(100, 100, 150, 50);
    afNetButton.backgroundColor = [UIColor orangeColor];
    [afNetButton setTitle:@"AFN数据请求" forState:UIControlStateNormal];
    // 添加手势
    [afNetButton addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)buttonAction {
    NSLog(@"点击button了 准备去处理数据分析");
    
    AFNetWorkVC *afnetWorkVC = [[AFNetWorkVC alloc] init];
    afnetWorkVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:afnetWorkVC animated:YES];
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
