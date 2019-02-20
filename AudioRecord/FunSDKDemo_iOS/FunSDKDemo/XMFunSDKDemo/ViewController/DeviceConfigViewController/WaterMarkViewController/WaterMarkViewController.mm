//
//  WaterMarkViewController.m
//  FunSDKDemo
//
//  Created by wujiangbo on 2018/12/19.
//  Copyright © 2018 wujiangbo. All rights reserved.
//

#import "WaterMarkViewController.h"
#import "WaterMarkConfig.h"
#import "ItemTableviewCell.h"
#import "EncodeItemViewController.h"

@interface WaterMarkViewController ()<UITableViewDelegate,UITableViewDataSource,WaterMarkConfigDelegate,UITextFieldDelegate>
{
    WaterMarkConfig *config;                      //水印配置
    NSArray *titleArray;                          //水印配置数组
    UITableView *tableView;                       //水印配置列表
}
@end

@implementation WaterMarkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
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
    self.navigationItem.title = TS("Watermark_setting");
}

#pragma mark - 获取配置
-(void)getConfig{
    [SVProgressHUD show];
    if (!config) {
        config = [[WaterMarkConfig alloc] init];
        config.delegate = self;
    }
    //获取水印信息
    [config getLogoConfig];
}

#pragma mark - 保存配置
-(void)saveConfig{
    [SVProgressHUD show];
    [config setWaterMarkConfig];
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
    if ([title isEqualToString:TS("Watermark_switch")]) {
       int enable = [config getLogoEnable];
        cell.Labeltext.text = enable == 0 ? TS("close"):TS("open");
    }
    else if ([title isEqualToString:TS("Watermark_text")]){
        cell.Labeltext.text = [config getLogoTitle];
    }
    else if ([title isEqualToString:TS("Osd_Watermark_switch")]){
        int enable = [config getOsdLogoEnable];
         cell.Labeltext.text = enable == 0 ? TS("close"):TS("open");
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *titleStr = titleArray[indexPath.row];
     if ([titleStr isEqualToString:TS("Watermark_switch")]) {
         //初始化各个配置的item单元格
         EncodeItemViewController *itemVC = [[EncodeItemViewController alloc] init];
         [itemVC setTitle:titleStr];

         itemVC.itemSelectStringBlock = ^(NSString *encodeString) {
             //itemVC的单元格点击回调,设置各种属性
             ItemTableviewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
             cell.Labeltext.text = encodeString;
             if ([encodeString isEqualToString:TS("close")]) {
                 [config setLossEnable:0];
             }
             else{
                 [config setLossEnable:1];
             }
         };
         [itemVC setValueArray:[@[TS("close"),TS("open")] mutableCopy]];
         [self.navigationController pushViewController:itemVC animated:YES];
     }
     else if ([titleStr isEqualToString:TS("Watermark_text")]){
         UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:TS("enter_custom_watermark") preferredStyle:UIAlertControllerStyleAlert];
         
         //增加取消按钮；
         [alertController addAction:[UIAlertAction actionWithTitle:TS("Cancel") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
  
         }]];

         //增加确定按钮
         [alertController addAction:[UIAlertAction actionWithTitle:TS("OK") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
             //获取第1个输入框
             UITextField *userNameTextField = alertController.textFields.firstObject;
             
             NSLog(@"shuiyin = %@",userNameTextField.text);
             
             [config setLogoTitle:userNameTextField.text];
             [tableView reloadData];
             
         }]];
         //定义一个输入框
         [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
             
             textField.placeholder = TS("enter_custom_watermark");
             textField.text = [config getLogoTitle];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged:) name:UITextFieldTextDidChangeNotification object:textField];
             
         }];
         [self presentViewController:alertController animated:true completion:nil];
     }
    else if ([titleStr isEqualToString:TS("Osd_Watermark_switch")]){
        //初始化各个配置的item单元格
        EncodeItemViewController *itemVC = [[EncodeItemViewController alloc] init];
        [itemVC setTitle:titleStr];
        
        itemVC.itemSelectStringBlock = ^(NSString *encodeString) {
            //itemVC的单元格点击回调,设置各种属性
            ItemTableviewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            cell.Labeltext.text = encodeString;
            if ([encodeString isEqualToString:TS("close")]) {
                [config setOsdLogoEnable:0];
            }
            else{
                [config setOsdLogoEnable:1];
            }
        };
        [itemVC setValueArray:[@[TS("close"),TS("open")] mutableCopy]];
        [self.navigationController pushViewController:itemVC animated:YES];
    }
}

#pragma mark - textFieldDelegate
-(void)textFieldChanged:(NSNotification*)notificaton{
    UITextField *textField = (UITextField *)notificaton.object;
    if (textField.text.length > 10) {
        textField.text = [textField.text substringToIndex:10];
    }
}

#pragma mark - funsdk回调处理
-(void)getLogoWidgetResult:(NSInteger)result{
    if (result > 0) {
        //成功，刷新界面数据
        [tableView reloadData];
        [SVProgressHUD dismiss];
    }else{
        [MessageUI ShowErrorInt:(int)result];
    }
}

-(void)getOsdLogoConfigResult:(NSInteger)result{
    if (result > 0) {
        //成功，刷新界面数据
        [tableView reloadData];
        [SVProgressHUD dismiss];
    }else{
        [MessageUI ShowErrorInt:(int)result];
    }
}

-(void)setLogoWidgetResult:(NSInteger)result{
    if (result > 0) {
        //成功
        [SVProgressHUD dismissWithSuccess:TS("Success")];
    }else{
        [MessageUI ShowErrorInt:(int)result];
    }
}

-(void)setOsdLogoConfigResult:(NSInteger)result{
    if (result > 0) {
        //成功
        [SVProgressHUD dismissWithSuccess:TS("Success")];
    }else{
        [MessageUI ShowErrorInt:(int)result];
    }
}

#pragma mark - 界面和数据初始化
-(void)initDataSource {
    titleArray = @[TS("Watermark_switch"),TS("Watermark_text"),TS("Osd_Watermark_switch")];
}

- (void)configSubView {
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave  target:self action:@selector(saveConfig)];
    self.navigationItem.rightBarButtonItem = rightButton;
    [self.view addSubview:self.tableView];
}

- (UITableView *)tableView{
    if (!tableView) {
        tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight ) style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        [tableView registerClass:[ItemTableviewCell class] forCellReuseIdentifier:@"ItemTableviewCell"];
    }
    
    return tableView;
}


@end
