//
//  EncodingFormatViewController.m
//  FunSDKDemo
//
//  Created by wujiangbo on 2018/12/17.
//  Copyright © 2018 wujiangbo. All rights reserved.
//

#import "EncodingFormatViewController.h"
#import "ItemTableviewCell.h"
#import "EncodeItemViewController.h"
#import "SystemFunctionConfig.h"

@interface EncodingFormatViewController ()<UITableViewDelegate,UITableViewDataSource,SystemFunctionConfigDelegate>
{
    NSArray *encodeTitleArray;                          //编码格式数组
    UITableView *ebcodeTableView;                       //编码格式列表
}
@property (nonatomic, strong) SystemFunctionConfig * functionConfig;

@end

@implementation EncodingFormatViewController

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
    self.navigationItem.title = TS("Encoding_format");
}

#pragma mark - tableView代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return encodeTitleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ItemTableviewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ItemTableviewCell"];
    if (!cell) {
        cell = [[ItemTableviewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ItemTableviewCell"];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    NSString *title = [encodeTitleArray objectAtIndex:indexPath.row];
    cell.textLabel.text = title;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *titleStr = encodeTitleArray[indexPath.row];
    //初始化各个配置的item单元格
    EncodeItemViewController *itemVC = [[EncodeItemViewController alloc] init];
    [itemVC setTitle:titleStr];
    
    __weak typeof(self) weakSelf = self;
    itemVC.itemSelectStringBlock = ^(NSString *encodeString) {
        //itemVC的单元格点击回调,设置各种属性
        ItemTableviewCell *cell = [weakSelf.ebcodeTableView cellForRowAtIndexPath:indexPath];
        cell.Labeltext.text = encodeString;
    };
    [itemVC setValueArray:[@[TS("close"),TS("open")] mutableCopy]];
    [self.navigationController pushViewController:itemVC animated:YES];
}

#pragma mark - 保存编码配置
-(void)saveConfig{
    [SVProgressHUD show];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    ItemTableviewCell *cell = [self.ebcodeTableView cellForRowAtIndexPath:indexPath];
    NSString *valueStr = cell.Labeltext.text;
    if ([valueStr isEqualToString:TS("close")]) {
        [self.functionConfig setSmartH264Info:0];
    }
    else{
        [self.functionConfig setSmartH264Info:1];
    }
   
}

#pragma mark - 获取编码配置
-(void)getConfig{
    [SVProgressHUD show];
    if (!_functionConfig) {
        _functionConfig = [[SystemFunctionConfig alloc] init];
        _functionConfig.delegate = self;
    }
    [self.functionConfig getSmartH264Info];
}

#pragma mark - 获取编码配置回调
-(void)SmartH264InfoConfigGetResult:(BOOL)result smartH264:(int)SmartH264{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    ItemTableviewCell *cell = [self.ebcodeTableView cellForRowAtIndexPath:indexPath];
    cell.Labeltext.text = SmartH264 == 0 ? TS("close") : TS("open");
}

#pragma mark - 界面和数据初始化
-(void)initDataSource {
    encodeTitleArray = @[TS("H264+")];
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
        [ebcodeTableView registerClass:[ItemTableviewCell class] forCellReuseIdentifier:@"ItemTableviewCell"];
    }
    
    return ebcodeTableView;
}

@end
