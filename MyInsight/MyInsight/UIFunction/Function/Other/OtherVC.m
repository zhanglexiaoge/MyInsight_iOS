//
//  OtherVC.m
//  MyInsight
//
//  Created by SongMenglong on 2018/1/24.
//  Copyright © 2018年 SongMenglong. All rights reserved.
//

#import "OtherVC.h"
#import <SWRevealViewController.h>
#import "ChatListVC.h"
#import "XinHuaVC.h"
#import "ZhiHuDailyVC.h"
#import "CrossVC.h"
#import "ReferToVC.h"
#import "UMengVC.h"

@interface OtherVC ()<UITableViewDelegate, UITableViewDataSource>
// 列表
@property (nonatomic, strong) UITableView *tableView;
// 数组数据
@property (nonatomic, strong) NSArray *dataArray;

@end

static const NSString *BaiSiBuDeJieStr = @"百思不得姐";
static const NSString *QiuShiBaiKeStr = @"糗事百科";
static const NSString *MeiZhiStr = @"妹纸";
static const NSString *ChatUIStr = @"聊天界面";
static const NSString *XinHuaStr = @"中华新华字典";
static const NSString *ZhiHuDailyStr = @"知乎日报";
static const NSString *CrossStr = @"跨平台";
static const NSString *ReferToStr = @"鸣谢:借鉴参考的仓库";
static const NSString *GitHubStr = @"GitHub";
static const NSString *UMengStr = @"友盟UMeng";

@implementation OtherVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // 
    if ([self revealViewController] != NULL) {
        [[self revealViewController] tapGestureRecognizer];
        [self.view addGestureRecognizer:[self revealViewController].panGestureRecognizer];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if ([self revealViewController] != NULL) {
        [self.view removeGestureRecognizer:[self revealViewController].panGestureRecognizer];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 左右button
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"左边" style:UIBarButtonItemStylePlain target:[self revealViewController] action:@selector(revealToggle:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"右边" style:UIBarButtonItemStylePlain target:[self revealViewController] action:@selector(rightRevealToggle:)];
    
    //处理数据
    [self handleTableViewData];
    // 创建列表
    [self creatTableView];
}

// 处理数据
- (void)handleTableViewData {
    self.dataArray = @[ReferToStr, BaiSiBuDeJieStr, QiuShiBaiKeStr, MeiZhiStr, ZhiHuDailyStr, ChatUIStr, XinHuaStr, CrossStr, UMengStr, GitHubStr];
}

#pragma mark - 创建TableView
- (void)creatTableView {
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    // 设置代理
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    // 清空多余cell
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    // 注册cell
    //[self.tableView registerNib:[UINib nibWithNibName:@"MineCell" bundle:nil] forCellReuseIdentifier:@"MineCell"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
}

#pragma mark - 实现TableView的代理协议
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// 行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

// 生成cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    if (cell == nil) {
        //cell = [[[NSBundle mainBundle]loadNibNamed:@"MineCell" owner:self options:nil] lastObject];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    
    // 赋值
    cell.textLabel.text = self.dataArray[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

// 选中cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 获取cell的字符串
    NSString *cellString = [self.dataArray objectAtIndex:indexPath.row];
    
    if ([cellString isEqual:ReferToStr]) {
        // 借鉴参考的仓库链接
        ReferToVC *referToVC = [[ReferToVC alloc] init];
        referToVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:referToVC animated:YES];
    }
    if ([cellString isEqual:ChatUIStr]) {
        ChatListVC *chatListVC = [[ChatListVC alloc] init];
        chatListVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:chatListVC animated:YES];
    }
    if ([cellString isEqual:XinHuaStr]) {
        // 中华新华字典
        XinHuaVC *xinHuaVC = [[XinHuaVC alloc] init];
        xinHuaVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:xinHuaVC animated:YES];
    }
    if ([cellString isEqual:ZhiHuDailyStr]) {
        // 知乎日报
        ZhiHuDailyVC *zhiHuDailyVC = [[ZhiHuDailyVC alloc] init];
        zhiHuDailyVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:zhiHuDailyVC animated:YES];
    }
    if ([cellString isEqual:CrossStr]) {
        // 知乎日报
        CrossVC *crossVC = [[CrossVC alloc] init];
        crossVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:crossVC animated:YES];
    }
    if ([cellString isEqual:UMengStr]) {
        // 友盟
        UMengVC *umengVC = [[UMengVC alloc] init];
        umengVC.title = cellString;
        umengVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:umengVC animated:YES];
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
