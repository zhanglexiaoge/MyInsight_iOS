//
//  TableViewVC.m
//  MyInsight
//
//  Created by SongMenglong on 2018/2/1.
//  Copyright © 2018年 SongMenglong. All rights reserved.
//

#import "TableViewVC.h"
#import <Masonry.h> // 代码约束布局
#import "FoldTableVC.h"
#import "DragTableVC.h"

@interface TableViewVC ()<UITableViewDelegate, UITableViewDataSource>
// TableView
@property (nonatomic, strong) UITableView *tableView;
// 数据数组
@property (nonatomic, strong) NSArray *dataArray;

@end

static const NSString *FoldTableStr = @"折叠TableView";
static const NSString *DragTableStr = @"拖拽TableView";

@implementation TableViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"TableView";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.dataArray = @[FoldTableStr, DragTableStr];
    
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
    // 设置cell
    cell.textLabel.text = self.dataArray[indexPath.row];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"选中cell");
    // 获取到当前cell的字符串
    NSString *cellString = [self.dataArray objectAtIndex:indexPath.row];
    if ([cellString isEqual:FoldTableStr]) {
        // 折叠
        FoldTableVC *foldTableVC = [[FoldTableVC alloc] init];
        foldTableVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:foldTableVC animated:YES];
    }
    if ([cellString isEqual:DragTableStr]) {
        // 拖拽
        DragTableVC *dragTableVC = [[DragTableVC alloc] init];
        dragTableVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:dragTableVC animated:YES];
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
