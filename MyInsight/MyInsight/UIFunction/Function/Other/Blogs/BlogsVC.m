//
//  BlogsVC.m
//  MyInsight
//
//  Created by zhouyugang_mini on 2018/10/17.
//  Copyright © 2018 SongMenglong. All rights reserved.
//

#import "BlogsVC.h"
#import "MDBlogsVC.h"

@interface BlogsVC ()<UITableViewDelegate, UITableViewDataSource>
// 列表
@property (nonatomic, strong) UITableView *tableView;
// 数组
@property (nonatomic, strong) NSArray *dataArray;

@end

@implementation BlogsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

	self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
	[self.view addSubview:self.tableView];
	self.tableView.delegate = self;
	self.tableView.dataSource = self;
	// 清空多余cell
	self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
	// 注册cell
	[self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"ReferToVC"];

	// 处理数据
	[self handleData];

}

#pragma mark - 实现协议
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReferToVC" forIndexPath:indexPath];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ReferToVC"];
	}

	// 赋值
	cell.textLabel.text = self.dataArray[indexPath.row];
	cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;

	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	// 获取cell的字符串
	NSString *cellString = [self.dataArray objectAtIndex:indexPath.row];
	NSLog(@"选中cell %@", cellString);
	// 打开链接
	MDBlogsVC *mdBlogsVC = [[MDBlogsVC alloc] init];
	mdBlogsVC.markdownStr = cellString;
	[self.navigationController pushViewController:mdBlogsVC animated:YES];
}

#pragma mark - 处理数据
- (void)handleData {
	self.dataArray = @[@"iOS设计模式", @"GIT工具"];
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
