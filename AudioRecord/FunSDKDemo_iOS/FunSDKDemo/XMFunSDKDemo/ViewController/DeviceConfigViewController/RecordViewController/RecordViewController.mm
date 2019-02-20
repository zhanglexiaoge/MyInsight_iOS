//
//  RecordViewController.m
//  FunSDKDemo
//
//  Created by XM on 2018/11/7.
//  Copyright © 2018年 XM. All rights reserved.
//

#import "RecordViewController.h"
#import "ItemTableviewCell.h"
#import "ItemViewController.h"
#import "RecordConfig.h"

@interface RecordViewController () <UITableViewDelegate,UITableViewDataSource,RecordConfigDelegate>
{
    RecordConfig *config;
    UITableView *recordTableView;
    NSMutableArray *recordTitleArray;
}
@end

@implementation RecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化界面
    [self initDataSource];
    [self configSubView];
    //请求配置
    [self getRecordConfig];
}

- (void)viewWillDisappear:(BOOL)animated{
    //有加载状态、则取消加载
    if ([SVProgressHUD isVisible]){
        [SVProgressHUD dismiss];
    }
}

#pragma mark - 获取录像配置
- (void)getRecordConfig {
    [SVProgressHUD showWithStatus:TS("")];
    if (config == nil) {
        config = [[RecordConfig alloc] init];
        config.delegate = self;
    }
    //调用获取设备录像配置的接口
    [config getRecordConfig];
}

#pragma mark 获取录像配置代理回调
- (void)recordSuportStatu:(NSInteger)statu {
    //statu = 0：只支持主码流。statu=1:只支持辅码流。statu=2:主辅码流都支持
    if (statu == 0) {//删掉辅码流
        [recordTitleArray removeObjectsInArray:self.extraArray];
    }else if (statu == 1){
        [recordTitleArray removeObjectsInArray:self.mainArray];
    }
}
- (void)getRecordConfigResult:(NSInteger)result {
    if (result >0) {
        //成功，刷新界面数据
        [self.recordTableView reloadData];
        [SVProgressHUD dismiss];
    }else{
        [MessageUI ShowErrorInt:(int)result];
    }
}

#pragma mark - 保存录像配置
-(void)saveConfig{
    [SVProgressHUD show];
    [config setRecordConfig];
}

#pragma mark 保存录像配置代理回调
- (void)setRecordConfigResult:(NSInteger)result {
    if (result >0) {
        //成功
        [SVProgressHUD dismissWithSuccess:TS("Success")];
    }else{
        [MessageUI ShowErrorInt:(int)result];
    }
}

#pragma mark - tableView代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return recordTitleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ItemTableviewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ItemTableviewCell"];
    if (!cell) {
        cell = [[ItemTableviewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ItemTableviewCell"];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    NSString *title = [recordTitleArray objectAtIndex:indexPath.row];
    cell.textLabel.text = title;
    if ([config checkRecord] == NO) {
        //当前配置参数无效，不能刷新
        return cell;
    }
    if ([title isEqualToString:TS("main_record")]) {
        cell.Labeltext.text =  [config getMainRecordMode];
    }else if ([title isEqualToString:TS("main_pre_record")]) {
        cell.Labeltext.text =[config getMainPreRecord];
    }else if ([title isEqualToString:TS("main_record_length")]) {
        cell.Labeltext.text = [config getMainPacketLength];
    }else if ([title isEqualToString:TS("extra_record")]) {
         cell.Labeltext.text = [config getExtraRecordMode];
    }else if ([title isEqualToString:TS("extra_pre_record")]) {
       cell.Labeltext.text = [config getExtraPreRecord];
    }else if ([title isEqualToString:TS("extra_record_length")]) {
        cell.Labeltext.text = [config getExtraPacketLength];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([config checkRecord] == NO) {
        return; //录像配置能力级数据异常，无法进行配置
    }
    NSString *titleStr = recordTitleArray[indexPath.row];
    //初始化各个配置的item单元格
    ItemViewController *itemVC = [[ItemViewController alloc] init];
    [itemVC setTitle:titleStr];
    
    __weak typeof(self) weakSelf = self;
    itemVC.itemSelectStringBlock = ^(NSString *encodeString) {
        //itemVC的单元格点击回调,设置各种属性
        ItemTableviewCell *cell = [weakSelf.recordTableView cellForRowAtIndexPath:indexPath];
        cell.Labeltext.text = encodeString;
        if ([cell.textLabel.text isEqualToString:TS("main_record")]) {
             [config setMainRecordMode:encodeString];
        }else if ([cell.textLabel.text isEqualToString:TS("main_pre_record")]){
            [config setMainPreRecord:encodeString];
        }else if ([cell.textLabel.text isEqualToString:TS("main_record_length")]){
            [config setMainPacketLength:encodeString];
        }else if ([cell.textLabel.text isEqualToString:TS("extra_record")]){
            [config setExtraRecordMode: encodeString];
        }else if ([cell.textLabel.text isEqualToString:TS("extra_pre_record")]){
            [config setExtraPreRecord:encodeString];
        }else if ([cell.textLabel.text isEqualToString:TS("extra_record_length")]){
            [config setExtraPacketLength:encodeString];
        }else{
            return;
        }
    };
    //点击单元格之后进行分别赋值
    if ([titleStr isEqualToString:TS("main_record")]) {
        NSMutableArray *array = [[config getMainRecordModeArray] mutableCopy];
        [itemVC setValueArray:array];
    }else if ([titleStr isEqualToString:TS("main_pre_record")]){
        NSMutableArray *array = [[config getMainPrerecordArray] mutableCopy];
        [itemVC setValueArray:array];
    }else if ([titleStr isEqualToString:TS("main_record_length")]){
        NSMutableArray *array = [[config getMainPacketLengthArray] mutableCopy];
        [itemVC setValueArray:array];
    }else if ([titleStr isEqualToString:TS("extra_record")]){
        NSMutableArray *array = [[config getExtraRecordModeArray] mutableCopy];
        [itemVC setValueArray:array];
    }else if ([titleStr isEqualToString:TS("extra_pre_record")]){
        NSMutableArray *array = [[config getMainPrerecordArray] mutableCopy];
        [itemVC setValueArray:array];
    }else if ([titleStr isEqualToString:TS("extra_record_length")]){
        NSMutableArray *array = [[config getExtraPacketLengthArray] mutableCopy];
        [itemVC setValueArray:array];
    }else if ([titleStr isEqualToString:TS("Custom_example")]){
        [config setTuesdayNightAlarmRecord];//设置周二晚上报警录像打开，保存后生效
        return;
    }else{
        return;
    }
    //如果赋值成功，跳转到下一级界面
    [self.navigationController pushViewController:itemVC animated:YES];
}

#pragma mark - 界面和数据初始化
- (void)configSubView {
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave  target:self action:@selector(saveConfig)];
    self.navigationItem.rightBarButtonItem = rightButton;
    [self.view addSubview:self.recordTableView];
}
- (UITableView *)recordTableView {
    if (!recordTableView) {
        recordTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight ) style:UITableViewStylePlain];
        recordTableView.delegate = self;
        recordTableView.dataSource = self;
        [recordTableView registerClass:[ItemTableviewCell class] forCellReuseIdentifier:@"ItemTableviewCell"];
    }
    return recordTableView;
}
- (void)initDataSource {
    recordTitleArray= [[NSMutableArray alloc] initWithArray:self.mainArray];
    [recordTitleArray addObjectsFromArray:self.extraArray];
    [recordTitleArray addObjectsFromArray:self.expendArray];
}
-(NSArray*)mainArray {
    return @[TS("main_record"),TS("main_pre_record"),TS("main_record_length")];
}
-(NSArray*)extraArray {
    return @[TS("extra_record"),TS("extra_pre_record"),TS("extra_record_length")];
}
-(NSArray*)expendArray {
    return @[TS("Custom_example")];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
