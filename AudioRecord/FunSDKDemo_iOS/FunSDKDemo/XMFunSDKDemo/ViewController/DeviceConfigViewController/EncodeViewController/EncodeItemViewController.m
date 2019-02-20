//
//  EncodeItemViewController.m
//  FunSDKDemo
//
//  Created by XM on 2018/11/6.
//  Copyright © 2018年 XM. All rights reserved.
//

#import "EncodeItemViewController.h"

@interface EncodeItemViewController () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) NSArray *itemArray;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation EncodeItemViewController

- (void)setValueArray:(NSMutableArray *)array {
    self.itemArray = [array mutableCopy];
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //配置子视图
    [self configSubView];
}
-(void)configSubView{
    [self.view addSubview:self.tableView];
}

#pragma mark - tableview代理方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.itemArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier"];
    cell.textLabel.text = self.itemArray[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.itemSelectStringBlock) {
        self.itemSelectStringBlock(self.itemArray[indexPath.row]);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellIdentifier"];
    }
    return _tableView;
}
@end
