//
//  ViewLayoutVC.m
//  MyInsight
//
//  Created by SongMenglong on 2018/4/21.
//  Copyright © 2018年 SongMenglong. All rights reserved.
//

#import "ViewLayoutVC.h"
#import "ScaleVC.h" // 三等分约束布局
#import "MasonryLayoutVC.h"
#import "AutoLayoutVC.h"
#import "VFLLayoutVC.h"

@interface ViewLayoutVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *dataArray;

@end

static const NSString *ScaleStr = @"等分布局";
static const NSString *MasonryStr = @"Masonry布局";
static const NSString *AutoLayoutStr = @"原生AutoLayout";
static const NSString *VFLLayoutStr = @"VFL布局";

@implementation ViewLayoutVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"约束布局";
    
    self.dataArray = @[ScaleStr, MasonryStr, AutoLayoutStr, VFLLayoutStr];
    
    [self creatTableView];
}

- (void)creatTableView {
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
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
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellString = [self.dataArray objectAtIndex:indexPath.row];
    
    if ([cellString isEqual:ScaleStr]) {
        // 等分布局
        ScaleVC *scaleVC = [[UIStoryboard storyboardWithName:@"Home" bundle:NULL] instantiateViewControllerWithIdentifier:@"ScaleVC"];
        scaleVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:scaleVC animated:YES];
    }
    if ([cellString isEqual:MasonryStr]) {
        // Masonry布局
        MasonryLayoutVC *masonryLayoutVC = [[MasonryLayoutVC alloc] init];
        masonryLayoutVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:masonryLayoutVC animated:YES];
    }
    if ([cellString isEqual:AutoLayoutStr]) {
        // 原生布局约束
        AutoLayoutVC *autoLayoutVC = [[AutoLayoutVC alloc] init];
        autoLayoutVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:autoLayoutVC animated:YES];
    }
    if ([cellString isEqual:VFLLayoutStr]) {
        // VFL布局约束
        VFLLayoutVC *vflLayoutVC = [[VFLLayoutVC alloc] init];
        vflLayoutVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vflLayoutVC animated:YES];
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
