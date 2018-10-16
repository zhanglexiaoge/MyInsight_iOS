//
//  CollectionViewVC.m
//  MyInsight
//
//  Created by SongMenglong on 2018/2/1.
//  Copyright © 2018年 SongMenglong. All rights reserved.
//

#import "CollectionViewVC.h"
#import <Masonry.h>
#import "NormalCollectionVC.h" // 普通布局的layout
#import "HorizontalCollectionVC.h" //
#import "VerticalCollectionVC.h" //
#import "MultiTypeFlowLayoutVC.h" //多种布局方式的集合视图
#import "CollectionQuiltLayoutVC.h" // 另一种集合视图

@interface CollectionViewVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *dataArray;

@end

static const NSString *NormalLayoutStr = @"普通布局CollectionView";
static const NSString *WaterFlowStr = @"瀑布流布局";
static const NSString *HorizontalFlowStr = @"水平流布局";
static const NSString *VerticalFlowStr = @"垂直流布局";
static const NSString *MultiTypeLayoutStr = @"多种布局(三种布局)";
static const NSString *QuiltLayoutStr = @"自定义布局";

@implementation CollectionViewVC

/*
 纯代码创建UICollectionView步骤以及简单使用
 https://www.jianshu.com/p/16c9d466f88c
 
 iOS之流布局UICollectionView全系列教程
 https://blog.csdn.net/lvxiangan/article/details/73826108
 */

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"CollectionView分类";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.dataArray = @[NormalLayoutStr, WaterFlowStr, HorizontalFlowStr, VerticalFlowStr, MultiTypeLayoutStr, QuiltLayoutStr];
    
    [self creatTableView];
}

- (void)creatTableView {
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    // 清空多余cell
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    //
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CollectionView"];
}

#pragma mark - 实现代理协议
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CollectionView" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CollectionView"];
    }
    
    cell.textLabel.text = self.dataArray[indexPath.row];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 获取到当前cell的字符串
    NSString *cellString = [self.dataArray objectAtIndex:indexPath.row];
    
    if ([cellString isEqual:NormalLayoutStr]) {
        // 普通布局
        NormalCollectionVC *normalCollectionVC = [[NormalCollectionVC alloc] init];
        normalCollectionVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:normalCollectionVC animated:YES];
    }
    
    if ([cellString isEqual:WaterFlowStr]) {
        //
        
    }
    
    if ([cellString isEqual:HorizontalFlowStr]) {
        // 水平流布局
        HorizontalCollectionVC *horizontalCollectionVC = [[HorizontalCollectionVC alloc] init];
        horizontalCollectionVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:horizontalCollectionVC animated:YES];
    }
    
    if ([cellString isEqual:VerticalFlowStr]) {
        // 垂直流布局
        VerticalCollectionVC *verticalCollectionVC = [[VerticalCollectionVC alloc] init];
        verticalCollectionVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:verticalCollectionVC animated:YES];
    }
    
    if ([cellString isEqual:MultiTypeLayoutStr]) {
        // 多种布局
        MultiTypeFlowLayoutVC *multiTypeFlowLayoutVC = [[MultiTypeFlowLayoutVC alloc] init];
        multiTypeFlowLayoutVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:multiTypeFlowLayoutVC animated:YES];
    }
    if ([cellString isEqual:QuiltLayoutStr]) {
        // 自定义布局
        CollectionQuiltLayoutVC *collectionQuiltLayoutVC = [[CollectionQuiltLayoutVC alloc] init];
        collectionQuiltLayoutVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:collectionQuiltLayoutVC animated:YES];
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
