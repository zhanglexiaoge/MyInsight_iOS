//
//  HumanDetectionViewController.m
//  FunSDKDemo
//
//  Created by wujiangbo on 2018/12/27.
//  Copyright © 2018 wujiangbo. All rights reserved.
//

#import "HumanDetectionViewController.h"
#import "HumanDetectionConfig.h"
#import "ItemTableviewCell.h"
#import "EncodeItemViewController.h"

@interface HumanDetectionViewController ()<UITableViewDataSource,UITableViewDelegate,HumanDetectionDelegate>
{
    NSMutableArray *titleArray;                          //人形检测数组
    UITableView *tableView;                              //人形检测列表
}
@property (nonatomic, strong) HumanDetectionConfig *functionConfig;

@end

@implementation HumanDetectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化数据和界面
    [self initDataSource];
    [self configSubView];
    //设置导航栏
    [self setNaviStyle];
    //获取配置
    [self getConfig];
}

-(void)viewWillDisappear:(BOOL)animated{
    if ([SVProgressHUD isVisible]) {
        [SVProgressHUD dismiss];
    }
}

- (void)setNaviStyle {
    self.navigationItem.title = TS("appEventHumanDetectAlarm");
}

#pragma mark - tableView代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ItemTableviewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ItemTableviewCell"];
    if (!cell) {
        cell = [[ItemTableviewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ItemTableviewCell"];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    NSString *title = [titleArray objectAtIndex:indexPath.row];
    cell.textLabel.text = title;
    int enable = 0;
    if ([title isEqualToString:TS("Alarm_function")]) {
        enable = [self.functionConfig getHumanDetectEnable];
    }
    else if ([title isEqualToString:TS("Alarm_video")]){
        enable = [self.functionConfig getHumanDetectRecordEnable];
    }
    else if ([title isEqualToString:TS("Alarm_picture")]){
       enable = [self.functionConfig getHumanDetectSnapEnable];
    }
    else{
       enable = [self.functionConfig getHumanDetectMessageEnable];
    }
    
    cell.Labeltext.text = enable == 0 ? TS("close"):TS("open");
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *titleStr = titleArray[indexPath.row];
    //初始化各个配置的item单元格
    EncodeItemViewController *itemVC = [[EncodeItemViewController alloc] init];
    [itemVC setTitle:titleStr];
    
    __weak typeof(self) weakSelf = self;
    itemVC.itemSelectStringBlock = ^(NSString *encodeString) {
        //itemVC的单元格点击回调,设置各种属性
        ItemTableviewCell *cell = [weakSelf.tableView cellForRowAtIndexPath:indexPath];
        cell.Labeltext.text = encodeString;
    };
    [itemVC setValueArray:[@[TS("close"),TS("open")] mutableCopy]];
    [self.navigationController pushViewController:itemVC animated:YES];
}

#pragma mark - 保存配置
-(void)saveConfig{
    [SVProgressHUD show];
    for (int i = 0; i < titleArray.count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        ItemTableviewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        NSString *valueStr = cell.Labeltext.text;
        NSString *title = [titleArray objectAtIndex:i];
        int enable = 0;
        if ([valueStr isEqualToString:TS("open")]) {
            enable = 1;
        }
        if ([title isEqualToString:TS("Alarm_function")]) {
            [self.functionConfig setHumanDetectEnable:enable];
        }
        else if ([title isEqualToString:TS("Alarm_video")]){
            [self.functionConfig setHumanDetectRecordEnable:enable];
        }
        else if ([title isEqualToString:TS("Alarm_picture")]){
            [self.functionConfig setHumanDetectSnapEnable:enable];
        }
        else{
            [self.functionConfig setHumanDetectMessageEnable:enable];
        }
    }
    
    [self.functionConfig SetConfig];
}

#pragma mark - 获取人形检测配置
-(void)getConfig{
    [SVProgressHUD show];
    if (!_functionConfig) {
        _functionConfig = [[HumanDetectionConfig alloc] init];
        _functionConfig.delegate = self;
    }
    [_functionConfig getHumanDetectConfig];
}

#pragma mark - 获取配置回调
-(void)HumanDetectionConfigGetResult:(NSInteger)result{
    if (result >= 0) {
        //成功，刷新界面数据
        [tableView reloadData];
        [SVProgressHUD dismiss];
    }else{
        [MessageUI ShowErrorInt:(int)result];
    }
}

-(void)HumanDetectionConfigSetResult:(NSInteger)result{
    if (result >= 0) {
        //成功
        [SVProgressHUD dismissWithSuccess:TS("Success")];
    }else{
        [MessageUI ShowErrorInt:(int)result];
    }
}

- (void)configSubView {
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave  target:self action:@selector(saveConfig)];
    self.navigationItem.rightBarButtonItem = rightButton;
    [self.view addSubview:self.tableView];
}

- (UITableView *)tableView {
    if (!tableView) {
        tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight ) style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        [tableView registerClass:[ItemTableviewCell class] forCellReuseIdentifier:@"ItemTableviewCell"];
    }
    return tableView;
}


#pragma mark - 界面和数据初始化
-(void)initDataSource {
    titleArray = [[NSMutableArray alloc] initWithObjects:TS("Alarm_function"),TS("Alarm_video"),TS("Alarm_picture"),TS("Send_to_phone"),nil];
}

@end
