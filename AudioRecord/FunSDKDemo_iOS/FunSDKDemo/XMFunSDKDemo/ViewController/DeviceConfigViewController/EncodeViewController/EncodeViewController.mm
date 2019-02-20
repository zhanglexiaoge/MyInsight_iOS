//
//  EncodeViewController.m
//  FunSDKDemo
//
//  Created by XM on 2018/10/24.
//  Copyright © 2018年 XM. All rights reserved.
//

#import "EncodeViewController.h"
#import "EncodeConfig.h"
#import "EncodeConfigTableviewCell.h"
#import "EncodeItemViewController.h"

@interface EncodeViewController () <EncodeConfigDelegate,UITableViewDelegate,UITableViewDataSource>
{
    EncodeConfig *config;
    UITableView *ebcodeTableView;
    NSArray *encodeTitleArray;
}
@end

@implementation EncodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化数据和界面
    [self initDataSource];
    [self configSubView];
    //获取编码配置参数
    [self getEncodeConfig];
}

- (void)viewWillDisappear:(BOOL)animated{
    //有加载状态、则取消加载
    if ([SVProgressHUD isVisible]){
        [SVProgressHUD dismiss];
    }
}

#pragma mark - 获取编码配置
- (void)getEncodeConfig {
    [SVProgressHUD showWithStatus:TS("")];
    if (config == nil) {
        config = [[EncodeConfig alloc] init];
        config.delegate = self;
    }
    //调用获取设备编码配置的接口
    [config getEncodeConfig];
}

#pragma mark 获取编码配置代理回调
- (void)getEncodeConfigResult:(NSInteger)result {
    if (result >0) {
        //成功，刷新界面数据
        [self.ebcodeTableView reloadData];
        [SVProgressHUD dismiss];
    }else{
        [MessageUI ShowErrorInt:(int)result];
    }
}
#pragma mark - 保存编码配置,这一步才真正的把配置保存到设备
-(void)saveConfig{
    [SVProgressHUD show];
    [config setEncodeConfig];
}
#pragma mark 保存编码配置代理回调
- (void)setEncodeConfigResult:(NSInteger)result {
    if (result >0) {
        //成功
        [SVProgressHUD dismissWithSuccess:TS("Success")];
    }else{
         [MessageUI ShowErrorInt:(int)result];
    }
}


#pragma mark - tableView代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return encodeTitleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EncodeConfigTableviewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EncodeConfigTableviewCell"];
    if (!cell) {
        cell = [[EncodeConfigTableviewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"EncodeConfigTableviewCell"];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    NSString *title = [encodeTitleArray objectAtIndex:indexPath.row];
    cell.textLabel.text = title;
    if ([config checkEncode] == NO) {
        //当前配置参数无效，不能刷新
        return cell;
    }
    if ([title isEqualToString:TS("main_resolution")]) {
        cell.Labeltext.text = [config getMainResolution];
    }else if ([title isEqualToString:TS("main_fps")]) {
        cell.Labeltext.text = [NSString stringWithFormat:@"%ld",(long)[config getMainFPS]];
    }else if ([title isEqualToString:TS("main_quality")]) {
        cell.Labeltext.text = [config getMainQuality];
    }else if ([title isEqualToString:TS("mian_audio")]) {
        cell.Labeltext.text = [config getMainAudioEnable];
    }else if ([title isEqualToString:TS("main_format")]) {
        cell.Labeltext.text = [config getMainCompressionEnable];
    }else if ([title isEqualToString:TS("extra_resolution")]) {
        cell.Labeltext.text = [config getExtraResolution];
    }else if ([title isEqualToString:TS("extra_fps")]) {
        cell.Labeltext.text = [NSString stringWithFormat:@"%ld",(long)[config getExtraFPS]];
    }else if ([title isEqualToString:TS("extra_quality")]) {
        cell.Labeltext.text = [config getExtraQuality];
    }else if ([title isEqualToString:TS("extra_audio")]) {
        cell.Labeltext.text = [config getExtraAudioEnable];
    }else if ([title isEqualToString:TS("extra_video")]) {
        cell.Labeltext.text = [config getExtraVideoEnable];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([config checkEncodeAbility] == NO) {
        return; //编码配置能力级数据异常，无法进行配置
    }
    NSString *titleStr = encodeTitleArray[indexPath.row];
    //初始化各个配置的item单元格
    EncodeItemViewController *itemVC = [[EncodeItemViewController alloc] init];
    [itemVC setTitle:titleStr];
    
    __weak typeof(self) weakSelf = self;
    itemVC.itemSelectStringBlock = ^(NSString *encodeString) {
        //itemVC的单元格点击回调,设置各种属性
        EncodeConfigTableviewCell *cell = [weakSelf.ebcodeTableView cellForRowAtIndexPath:indexPath];
        cell.Labeltext.text = encodeString;
        if ([cell.textLabel.text isEqualToString:TS("main_resolution")]) {
            [config setMainResolution:encodeString];
        }else if ([cell.textLabel.text isEqualToString:TS("main_fps")]){
            [config setMainFPS:[encodeString integerValue]];
        }else if ([cell.textLabel.text isEqualToString:TS("main_quality")]){
            [config setMainQuality:encodeString];
        }else if ([cell.textLabel.text isEqualToString:TS("mian_audio")]){
            [config setMainAudioEnable:encodeString];
        }else if ([cell.textLabel.text isEqualToString:TS("extra_resolution")]){
            [config setExtraResolution:encodeString];
        }else if ([cell.textLabel.text isEqualToString:TS("extra_fps")]){
             [config setExtraFPS:[encodeString integerValue]];
        }else if ([cell.textLabel.text isEqualToString:TS("extra_quality")]){
             [config setExtraQuality:encodeString];
        }else if ([cell.textLabel.text isEqualToString:TS("extra_audio")]){
             [config setExtraAudioEnable:encodeString];
        }else if ([cell.textLabel.text isEqualToString:TS("extra_video")]){
             [config setExtraVideoEnable:encodeString];
        }else{
            return;
        }
    };
    //点击单元格之后进行分别赋值
    if ([titleStr isEqualToString:TS("main_resolution")]) {
        NSMutableArray *array = [[config getMainResolutionArray] mutableCopy];
        [itemVC setValueArray:array];
    }else if ([titleStr isEqualToString:TS("main_fps")]){
        NSMutableArray *array = [[config getMainFpsArray] mutableCopy];
        [itemVC setValueArray:array];
    }else if ([titleStr isEqualToString:TS("main_quality")]){
        NSMutableArray *array = [[config getMainQualityArray] mutableCopy];
        [itemVC setValueArray:array];
    }else if ([titleStr isEqualToString:TS("mian_audio")]){
        NSMutableArray *array = [[config getEnableArray] mutableCopy];
        [itemVC setValueArray:array];
    }else if ([titleStr isEqualToString:TS("extra_resolution")]){
        NSMutableArray *array = [[config getExtraResolutionArray] mutableCopy];
        [itemVC setValueArray:array];
    }else if ([titleStr isEqualToString:TS("extra_fps")]){
        NSMutableArray *array = [[config getExtraFpsArray] mutableCopy];
        [itemVC setValueArray:array];
    }else if ([titleStr isEqualToString:TS("extra_quality")]){
        NSMutableArray *array = [[config getExtraQualityArray] mutableCopy];
        [itemVC setValueArray:array];
    }else if ([titleStr isEqualToString:TS("extra_audio")]){
        NSMutableArray *array = [[config getEnableArray] mutableCopy];
        [itemVC setValueArray:array];
    }else if ([titleStr isEqualToString:TS("extra_video")]){
        NSMutableArray *array = [[config getEnableArray] mutableCopy];
        [itemVC setValueArray:array];
    }else{
        return;
    }
    //如果赋值成功，跳转到下一级界面
    [self.navigationController pushViewController:itemVC animated:YES];
}

#pragma mark - 界面和数据初始化
-(void)initDataSource {
    encodeTitleArray=@[
                       TS("main_resolution"),TS("main_fps"),TS("main_quality"),TS("mian_audio"),TS("main_format"),
                       TS("extra_resolution"),TS("extra_fps"),TS("extra_quality"),TS("extra_audio"),TS("extra_video")];
}
- (void)configSubView {
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave  target:self action:@selector(saveConfig)];
    self.navigationItem.rightBarButtonItem = rightButton;
    [self.view addSubview:self.ebcodeTableView];
}
- (UITableView *)ebcodeTableView {
    if (!ebcodeTableView) {
        ebcodeTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight ) style:UITableViewStylePlain];
        ebcodeTableView.delegate = self;
        ebcodeTableView.dataSource = self;
        [ebcodeTableView registerClass:[EncodeConfigTableviewCell class] forCellReuseIdentifier:@"EncodeConfigTableviewCell"];
    }
    return ebcodeTableView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
