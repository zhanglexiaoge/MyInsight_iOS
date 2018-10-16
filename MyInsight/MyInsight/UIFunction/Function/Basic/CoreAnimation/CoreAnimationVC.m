

//
//  CoreAnimationVC.m
//  MyInsight
//
//  Created by SongMenglong on 2018/4/23.
//  Copyright © 2018年 SongMenglong. All rights reserved.
//

#import "CoreAnimationVC.h"
#import "CALayerBaseVC.h"
#import "CALayerYSDHVC.h"
#import "CAClockVC.h"
#import "CABasicAnimationVC.h"
#import "CAKeyFrameAnimationVC.h"
#import "CATransitionVC.h"
#import "CAAnimationGroupVC.h"
#import "ZDTPVC.h"
#import "YinLZDTVC.h"
#import "HDZSQVC.h"
#import "LZDHDTVC.h"
#import "LZDHDTSVC.h"
#import "DaoYingVC.h"

@interface CoreAnimationVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *dataArray;

@end

static const NSString *CALayerBaseStr = @"CALayer基本动画";
static const NSString *CALayerYSDHStr = @"CALayer隐式动画";
static const NSString *CAClockStr = @"CA时钟";
static const NSString *CABasicAnimationStr = @"核心动画CABasicA";
static const NSString *CAKeyFrameAnimationStr = @"关键帧动画CAKeyFrameA";
static const NSString *CATransitionStr = @"CATransition转场动画";
static const NSString *CAAnimationGroupStr = @"动画组CAGroupA";

static const NSString *ZDTPStr = @"折叠图片";
static const NSString *YinLDTStr = @"音量震动条";
static const NSString *HDZSQStr = @"活动指示器";
static const NSString *LZDHDTStr = @"粒子动画单条";
static const NSString *LZDHDTSStr = @"粒子动画多条";
static const NSString *DaoYingStr = @"倒影";

@implementation CoreAnimationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"核心动画";
    
    self.dataArray = @[CALayerBaseStr, CALayerYSDHStr, CAClockStr, CABasicAnimationStr, CAKeyFrameAnimationStr, CATransitionStr, CAAnimationGroupStr, ZDTPStr, YinLDTStr, HDZSQStr, LZDHDTStr, LZDHDTSStr, DaoYingStr];
    
    [self creatTableView];
}

- (void)creatTableView {
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    // 注册cell
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    // 清空多余cell
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    if (cell == NULL) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    
    cell.textLabel.text = self.dataArray[indexPath.row];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 获取到当前cell的字符串
    NSString *cellString = [self.dataArray objectAtIndex:indexPath.row];
    
    if ([cellString isEqual:CALayerBaseStr]) {
        // CALayer基本动画
        CALayerBaseVC *caLayerBaseVC = [[CALayerBaseVC alloc] init];
        caLayerBaseVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:caLayerBaseVC animated:YES];
    }
    
    if ([cellString isEqual:CALayerYSDHStr]) {
        // CALayer隐式动画
        CALayerYSDHVC *caLayerYSDHVC = [[CALayerYSDHVC alloc] init];
        caLayerYSDHVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:caLayerYSDHVC animated:YES];
    }
    
    if ([cellString isEqual:CAClockStr]) {
        // 时钟
        CAClockVC *caClockVC = [[CAClockVC alloc] init];
        caClockVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:caClockVC animated:YES];
    }
    if ([cellString isEqual:CABasicAnimationStr]) {
        // 核心动画CABasicA
        CABasicAnimationVC *caBasicAnimationVC = [[CABasicAnimationVC alloc] init];
        caBasicAnimationVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:caBasicAnimationVC animated:YES];
    }
    if ([cellString isEqual:CAKeyFrameAnimationStr]) {
        // 关键帧动画CAKeyFrameA
        CAKeyFrameAnimationVC *caKeyFrameAnimationVC = [[CAKeyFrameAnimationVC alloc] init];
        caKeyFrameAnimationVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:caKeyFrameAnimationVC animated:YES];
    }
    if ([cellString isEqual:CATransitionStr]) {
        // CATransition转场动画
        CATransitionVC *caTransitionVC = [[CATransitionVC alloc] init];
        caTransitionVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:caTransitionVC animated:YES];
    }
    if ([cellString isEqual:CAAnimationGroupStr]) {
        // 动画组CAGroupA
        CAAnimationGroupVC *caAnimationGroupVC = [[CAAnimationGroupVC alloc] init];
        caAnimationGroupVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:caAnimationGroupVC animated:YES];
    }
    if ([cellString isEqual:ZDTPStr]) {
        // 折叠图片
        ZDTPVC *zdtpVC = [[UIStoryboard storyboardWithName:@"CoreAnimation" bundle:NULL] instantiateViewControllerWithIdentifier:@"ZDTPVC"];
        zdtpVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:zdtpVC animated:YES];
    }
    if ([cellString isEqual:YinLDTStr]) {
        // 音量震动条
        YinLZDTVC *yinLZDTVC = [[YinLZDTVC alloc] init];
        yinLZDTVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:yinLZDTVC animated:YES];
    }
    if ([cellString isEqual:HDZSQStr]) {
        // 活动指示器
        HDZSQVC *hdzsqVC = [[HDZSQVC alloc] init];
        hdzsqVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:hdzsqVC animated:YES];
    }
    if ([cellString isEqual:LZDHDTStr]) {
        // 粒子动画单条
        LZDHDTVC *lzdhdtVC = [[UIStoryboard storyboardWithName:@"CoreAnimation" bundle:NULL] instantiateViewControllerWithIdentifier:@"LZDHDTVC"];
        lzdhdtVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:lzdhdtVC animated:YES];
    }
    if ([cellString isEqual:LZDHDTSStr]) {
        // 粒子动画多条
        LZDHDTSVC *lzdhdtsVC = [[UIStoryboard storyboardWithName:@"CoreAnimation" bundle:NULL] instantiateViewControllerWithIdentifier:@"LZDHDTSVC"];
        lzdhdtsVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:lzdhdtsVC animated:YES];
    }
    if ([cellString isEqual:DaoYingStr]) {
        // 倒影
        DaoYingVC *daoYingVC = [[UIStoryboard storyboardWithName:@"CoreAnimation" bundle:NULL] instantiateViewControllerWithIdentifier:@"DaoYingVC"];
        daoYingVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:daoYingVC animated:YES];
    }
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
