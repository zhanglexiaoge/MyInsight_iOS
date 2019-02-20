//
//  DeviceInfoEditViewController.m
//  FunSDKDemo
//
//  Created by wujiangbo on 2018/11/19.
//  Copyright © 2018年 wujiangbo. All rights reserved.
//

#import "DeviceInfoEditViewController.h"
#import "DeviceManager.h"
#import "AddDeviceInputCell.h"
#import <Masonry/Masonry.h>

@interface DeviceInfoEditViewController ()<UITableViewDelegate,UITableViewDataSource,DeviceManagerDelegate>
{
    NSArray *titleArray;                //列表数组
    DeviceManager *deviceManager;       //设备管理器
    UITextField *devNameTF;             //设备名
    UITextField *devPswTF;              //设备密码
    UITextField *serialTF;              //设备序列号
    UITextField *userNameTF;            //用户名
}
@property (nonatomic,strong)UITableView *listTableView;         //输入列表
@property (nonatomic,strong)UIButton *editBtn;                   //添加按钮
@end

@implementation DeviceInfoEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    //设备管理器
    deviceManager = [[DeviceManager alloc] init];
    deviceManager.delegate = self;
    //设置导航栏
    [self setNaviStyle];
    //初始化数据
    [self initDataSource];
    [self.view addSubview:self.listTableView];
    [self.view addSubview:self.editBtn];
    
    //控件布局
    [self configSubView];
}

- (void)setNaviStyle {
    self.navigationItem.title = TS("");
    
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"new_back.png"] style:UIBarButtonItemStylePlain target:self action:@selector(popViewController)];
    self.navigationItem.leftBarButtonItem = leftBtn;
}

#pragma mark - 控件布局
-(void)configSubView{
    [self.listTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@110);
        make.width.equalTo(self.view.mas_width).multipliedBy(0.9);
        make.height.equalTo(@200);
        make.centerX.equalTo(self.view.mas_centerX);
    }];
    
    [self.editBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.listTableView.mas_bottom).offset(50);
        make.width.equalTo(self.view.mas_width).multipliedBy(0.9);
        make.height.equalTo(@45);
        make.centerX.equalTo(self.view);
    }];
}

#pragma mark - button event
-(void)popViewController{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)editBtnClicked{
    //修改设备名称和设备密码
    [SVProgressHUD show];
    [deviceManager changeDevice:serialTF.text devName:devNameTF.text username:userNameTF.text password:devPswTF.text];
}

#pragma mark 点击空白处关闭键盘
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma mark - tableViewDataSource/Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return titleArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AddDeviceInputCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddDeviceInputCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSString *titleStr = titleArray[indexPath.row];
    
    cell.customTitle.text = titleStr;
    
    if ([titleStr isEqualToString:TS("Device_Name")]) {
        cell.inputTextField.attributedPlaceholder =
        [[NSAttributedString alloc]initWithString:TS("Enter_Device_Name") attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}];
        cell.inputTextField.text = self.devObject.deviceName;
        devNameTF = cell.inputTextField;
    }
    else if ([titleStr isEqualToString:TS("serial_number")]){
        cell.inputTextField.attributedPlaceholder =
        [[NSAttributedString alloc]initWithString:TS("Enter_serial_number") attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}];
        cell.inputTextField.text = self.devObject.deviceMac;
        cell.inputTextField.enabled = NO;
        serialTF = cell.inputTextField;
    }
    else if ([titleStr isEqualToString:TS("UserName")]){
        cell.inputTextField.attributedPlaceholder =
        [[NSAttributedString alloc]initWithString:TS("Enter_LoginName") attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}];
        cell.inputTextField.text = self.devObject.loginName;
        cell.inputTextField.enabled = NO;
        userNameTF = cell.inputTextField;
    }
    else if ([titleStr isEqualToString:TS("Password2")]){
        cell.inputTextField.attributedPlaceholder =
        [[NSAttributedString alloc]initWithString:TS("Enter_LoginPassword") attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]}];
        cell.inputTextField.text = self.devObject.loginPsw;
        devPswTF = cell.inputTextField;
    }
    
    return cell;
}

#pragma mark - funsdk 回调处理
// 修改设备信息结果
- (void)changeDevice:(NSString *)sId changedResult:(int)result{
    if (result >= 0) {
        [SVProgressHUD showSuccessWithStatus:TS("Success")];
        if (self.editSuccess) {
            self.editSuccess();
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
    else{
        [MessageUI ShowErrorInt:result];
    }
}

#pragma mark - 界面和数据初始化
- (void)initDataSource {
    titleArray = @[TS("Device_Name"),TS("serial_number"),TS("UserName"),TS("Password2")];
}

-(UITableView *)listTableView{
    if (!_listTableView) {
        _listTableView = [[UITableView alloc] init];
        _listTableView.delegate = self;
        _listTableView.dataSource = self;
        _listTableView.scrollEnabled = NO;
        [_listTableView registerClass:[AddDeviceInputCell class] forCellReuseIdentifier:@"AddDeviceInputCell"];
    }
    
    return _listTableView;
}

-(UIButton *)editBtn{
    if (!_editBtn) {
        _editBtn = [[UIButton alloc] init];
        [_editBtn addTarget:self action:@selector(editBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        [_editBtn setTitle:TS("OK") forState:UIControlStateNormal];
        [_editBtn setBackgroundColor:GlobalMainColor];
    }
    
    return _editBtn;
}


@end
