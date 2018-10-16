//
//  MultiThreadVC.m
//  MyInsight
//
//  Created by SongMenglong on 2018/3/19.
//  Copyright © 2018年 SongMenglong. All rights reserved.
//

#import "MultiThreadVC.h"
#import "ThreadVC.h"
#import "GCDVC.h"
#import "OperationVC.h"
#import "LockVC.h"

@interface MultiThreadVC ()

@property (nonatomic, strong) NSArray *dataArray;

@end

// 设置字符串常量
static const NSString *NSThreadStr = @"NSThread线程";
static const NSString *GCDStr = @"GCD多线程";
static const NSString *NSOperationStr = @"NSOperation多线程";
static const NSString *LockStr = @"同步锁知识";

@implementation MultiThreadVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"多线程";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.dataArray = @[NSThreadStr, GCDStr, NSOperationStr, LockStr];
    
    
    [self setupTableView];
}

- (void)setupTableView {
    // 去掉多余的cell
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    // 注册cell
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    
    // 赋值
    cell.textLabel.text = self.dataArray[indexPath.row];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 获取到当前cell的字符串
    NSString *cellString = [self.dataArray objectAtIndex:indexPath.row];
    
    if ([cellString isEqual:NSThreadStr]) {
        // NSThread多线程
        ThreadVC *threadVC = [[ThreadVC alloc] init];
        threadVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:threadVC animated:YES];
    }
    
    if ([cellString isEqual:GCDStr]) {
        // GCD多线程
        GCDVC *gcdVC = [[GCDVC alloc] init];
        gcdVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:gcdVC animated:YES];
    }
    
    if ([cellString isEqual:NSOperationStr]) {
        // NSOperation多线程
        OperationVC *operationVC = [[OperationVC alloc] init];
        operationVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:operationVC animated:YES];
    }
    
    if ([cellString isEqual:LockStr]) {
        // 同步锁
        LockVC *lockVC = [[LockVC alloc] init];
        lockVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:lockVC animated:YES];
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
