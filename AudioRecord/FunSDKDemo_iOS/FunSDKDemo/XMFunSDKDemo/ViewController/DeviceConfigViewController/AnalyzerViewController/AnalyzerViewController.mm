//
//  AnalyzerViewController.m
//  FunSDKDemo
//
//  Created by XM on 2018/12/22.
//  Copyright © 2018年 XM. All rights reserved.
//

#import "AnalyzerViewController.h"
#import "ItemViewController.h"
#import "ItemTableviewCell.h"
#import "AnalyzeConfig.h"

@interface AnalyzerViewController () <UITableViewDelegate,UITableViewDataSource,AnalyzeConfigDelegate>
{
    AnalyzeConfig *config; //智能分析
    UITableView *analyzerTableView;
    NSMutableArray *analyzerTitleArray;
}
@end

@implementation AnalyzerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化tableview数据
    [self initDataSource];
    [self configSubView];
    // 获取智能分析配置
    [self getVideoRotainConfig];
}

- (void)viewWillDisappear:(BOOL)animated{
    //有加载状态、则取消加载
    if ([SVProgressHUD isVisible]){
        [SVProgressHUD dismiss];
    }
}

#pragma mark - 获取智能分析配置
- (void)getVideoRotainConfig {
    [SVProgressHUD showWithStatus:TS("")];
    if (config == nil) {
        config = [[AnalyzeConfig alloc] init];
        config.delegate = self;
    }
    //调用获取智能分析等参数的接口
    [config getAnalyzeConfig];
}
#pragma mark 获取智能分析代理回调
- (void)getAnalyzeConfigResult:(NSInteger)result {
    if (result >0) {
        //成功，刷新界面数据
        [self.analyzerTableView reloadData];
        [SVProgressHUD dismiss];
    }else{
        [MessageUI ShowErrorInt:(int)result];
    }
}

#pragma mark - 保存智能分析配置 （
-(void)saveConfig{
    [SVProgressHUD show];
    [config setAnalyzeConfig];
}
#pragma mark 保存智能分析代理回调
- (void)setAnalyzeConfigResult:(NSInteger)result {
    if (result >0) {
        //成功
        [SVProgressHUD dismissWithSuccess:TS("Success")];
    }else{
        [MessageUI ShowErrorInt:(int)result];
    }
}

#pragma mark - tableView代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return analyzerTitleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ItemTableviewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ItemTableviewCell"];
    if (!cell) {
        cell = [[ItemTableviewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ItemTableviewCell"];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    NSString *title = [analyzerTitleArray objectAtIndex:indexPath.row];
    cell.textLabel.text = title;
    if ([config checkParam] == NO) {
        //当前配置参数无效，不能刷新
        return cell;
    }
    AnalyzeDataSource *dataSource = [config getAnalyzeDataSource];
    if ([title isEqualToString:TS("Analyzer_Enable")]) {
            cell.Labeltext.text =  [dataSource getEnableString:dataSource.AnalyzeEnable];
    }
    if ([title isEqualToString:TS("Analyzer_Type")]) {
            cell.Labeltext.text = [dataSource getAnalyzeTypeString:dataSource.ModuleType];
    }
    if ([title isEqualToString:TS("Analyzer_Level")]) {
        cell.Labeltext.text = [NSString stringWithFormat:@"%d",dataSource.PeaLevel];
    }
    if ([title isEqualToString:TS("Analyzer_Rule")]) {
        cell.Labeltext.text =  [dataSource getEnableString:dataSource.PeaShowRule];
    }
    if ([title isEqualToString:TS("Analyzer_Trace")]) {
        cell.Labeltext.text =  [dataSource getEnableString:dataSource.PeaShowTrace];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([config checkParam] == NO) {
        return; //
    }
    NSString *titleStr = analyzerTitleArray[indexPath.row];
    //初始化各个配置的item单元格
    ItemViewController *itemVC = [[ItemViewController alloc] init];
    [itemVC setTitle:titleStr];
    
    __weak typeof(self) weakSelf = self;
    itemVC.itemSelectStringBlock = ^(NSString *encodeString) {
        //itemVC的单元格点击回调,设置各种属性
        ItemTableviewCell *cell = [weakSelf.analyzerTableView cellForRowAtIndexPath:indexPath];
        cell.Labeltext.text = encodeString;
        AnalyzeDataSource *dataSource = [config getAnalyzeDataSource];
        if ([cell.textLabel.text isEqualToString:TS("Analyzer_Enable")]) {
            dataSource.AnalyzeEnable = [dataSource getEnableBool:encodeString];
        }
        if ([cell.textLabel.text isEqualToString:TS("Analyzer_Type")]) {
            dataSource.ModuleType = (int)[dataSource getAnalyzeTypeInt:encodeString];
        }
        if ([cell.textLabel.text isEqualToString:TS("Analyzer_Level")]) {
            dataSource.PeaLevel = [encodeString intValue];
        }
        if ([cell.textLabel.text isEqualToString:TS("Analyzer_Rule")]) {
            dataSource.PeaShowRule = [dataSource getEnableBool:encodeString];
        }
        if ([cell.textLabel.text isEqualToString:TS("Analyzer_Trace")]) {
            dataSource.PeaShowTrace = [dataSource getEnableBool:encodeString];
        }
    };
    //点击单元格之后进行分别赋值
    AnalyzeDataSource *dataSource = [config getAnalyzeDataSource];
    if ([titleStr isEqualToString:TS("Analyzer_Enable")]) {
        [itemVC setValueArray:[config getEnableArray]];
    }else if ([titleStr isEqualToString:TS("Analyzer_Type")]) {
        [itemVC setValueArray:(NSMutableArray*)[dataSource analyzeTypeArray]]; //警戒算法，分3种
    }else if ([titleStr isEqualToString:TS("Analyzer_Level")]) {
        [itemVC setValueArray:(NSMutableArray*)[dataSource analyzeLevelArray]]; //警戒级别，1-5（可能不同）
    }else if ([titleStr isEqualToString:TS("Analyzer_Rule")]) {
        [itemVC setValueArray:[config getEnableArray]];
    }else if ([titleStr isEqualToString:TS("Analyzer_Trace")]) {
        [itemVC setValueArray:[config getEnableArray]];
    }else{
        return;
    }
    //如果赋值成功，跳转到下一级界面
    [self.navigationController pushViewController:itemVC animated:YES];
}


#pragma mark - 界面和数据初始化
- (void)configSubView {
     self.navigationItem.title = TS("AnalyzeConfig");
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave  target:self action:@selector(saveConfig)];
    self.navigationItem.rightBarButtonItem = rightButton;
    [self.view addSubview:self.analyzerTableView];
}
- (UITableView *)analyzerTableView {
    if (!analyzerTableView) {
        analyzerTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight ) style:UITableViewStylePlain];
        analyzerTableView.delegate = self;
        analyzerTableView.dataSource = self;
        [analyzerTableView registerClass:[ItemTableviewCell class] forCellReuseIdentifier:@"ItemTableviewCell"];
    }
    return analyzerTableView;
}
#pragma mark - 界面和数据初始化
- (void)initDataSource {
    analyzerTitleArray = (NSMutableArray*)@[TS("Analyzer_Enable"),TS("Analyzer_Type"),TS("Analyzer_Level"),TS("Analyzer_Rule"),TS("Analyzer_Trace")];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
