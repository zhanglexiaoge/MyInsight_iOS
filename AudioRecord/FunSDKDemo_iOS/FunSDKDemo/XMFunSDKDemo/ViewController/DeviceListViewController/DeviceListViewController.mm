//
//  DeviceListViewController.m
//  FunSDKDemo
//
//  Created by Levi on 2018/5/18.
//  Copyright © 2018年 Levi. All rights reserved.
//

#import "DeviceListTableViewCell.h"
#import "DeviceListViewController.h"
#import "PlayViewController.h"
#import "DeviceManager.h"
#import "DeviceInfoEditViewController.h"

@interface DeviceListViewController ()<UITableViewDelegate,UITableViewDataSource,DeviceManagerDelegate>
{
    NSMutableArray *deviceArray; //设备信息数组
    int selectNum;               //当前选择的设置
}
@property (nonatomic, strong) UIBarButtonItem *rightBarBtn;

@property (nonatomic, strong) UITableView *devListTableView;

@end

@implementation DeviceListViewController

- (UITableView *)devListTableView {
    if (!_devListTableView) {
        _devListTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight ) style:UITableViewStylePlain];
        _devListTableView.delegate = self;
        _devListTableView.dataSource = self;
        _devListTableView.rowHeight = 50;
        [_devListTableView registerClass:[DeviceListTableViewCell class] forCellReuseIdentifier:@"cell"];
        UILongPressGestureRecognizer *longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo:)];
        longPressGr.minimumPressDuration = 0.5;
        [_devListTableView addGestureRecognizer:longPressGr];
        
        _devListTableView.estimatedRowHeight = 0;
        _devListTableView.estimatedSectionHeaderHeight = 0;
        _devListTableView.estimatedSectionFooterHeight = 0;
    }
    return _devListTableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //读取设备数据
    [self getDevicelist];
    //刷新读取到的设备的在线状态
    [self getdeviceState:nil];
    //设置导航栏样式
    [self setNaviStyle];
    //配置子试图
    [self configSubView];
}

- (void)getDevicelist {
    deviceArray = [[DeviceControl getInstance] currentDeviceArray];
    if (deviceArray == nil) {
        deviceArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
}
-(void)getdeviceState:(NSString*)deviceMac {
    //刷新读取到的设备状态
    DeviceManager *manager = [DeviceManager getInstance];
    manager.delegate = self;
    [manager getDeviceState:deviceMac];
}
- (void)setNaviStyle {
    self.navigationItem.title = TS("DeviceList");
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"new_back.png"] style:UIBarButtonItemStylePlain target:self action:@selector(popViewController)];
    self.navigationItem.leftBarButtonItem = leftBtn;
    self.rightBarBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshDeviceList)];
    self.navigationItem.rightBarButtonItem = self.rightBarBtn;
    self.rightBarBtn.width = 15;
    self.rightBarBtn.tintColor = [UIColor whiteColor];
}

- (void)configSubView {
    [self.view addSubview:self.devListTableView];
}

-(void)popViewController{
    if([SVProgressHUD isVisible]){
        [SVProgressHUD dismiss];
    }
    [self.navigationController popViewControllerAnimated:YES];
    DeviceManager *manager = [DeviceManager getInstance];
    manager.delegate = nil;
}
    
#pragma mark - tableview长按手势响应,删除和编辑设备
-(void)longPressToDo:(UILongPressGestureRecognizer *)gesture{
    if(gesture.state != UIGestureRecognizerStateBegan){
        return;
    }
    NSIndexPath *indexPath ;

    CGPoint point = [gesture locationInView:self.devListTableView];
    indexPath = [self.devListTableView indexPathForRowAtPoint:point];
    if(indexPath == nil){
        return;
    }
    NSLog(@"%ld",(long)indexPath.row);
    DeviceObject *devObject = [deviceArray objectAtIndex:indexPath.section];;
    
    NSString *title = [NSString stringWithFormat:@"%@%@",TS(""), devObject.deviceName];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:TS("Cancel") style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *deleteBtn = [UIAlertAction actionWithTitle:TS("Delete") style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:TS("warning") message:TS("Are_you_sure_to_delete_device2") preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelButton = [UIAlertAction actionWithTitle:TS("Cancel") style:UIAlertActionStyleCancel handler:nil];
        UIAlertAction *deleteButton = [UIAlertAction actionWithTitle:TS("OK") style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            //发送删除命令
            DeviceManager *manager = [DeviceManager getInstance];
            [manager deleteDeviceWithDevMac:devObject.deviceMac];
        }];
       
        [alertController addAction:cancelButton];
        [alertController addAction:deleteButton];
        [self presentViewController:alertController animated:YES completion:nil];
    }];
    UIAlertAction *settingBtn = [UIAlertAction actionWithTitle:TS("Edit") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //跳转到编辑界面
        DeviceInfoEditViewController *editVC = [[DeviceInfoEditViewController alloc] init];
        editVC.devObject = devObject;
        editVC.editSuccess = ^{
            //编辑成功，刷新界面
            deviceArray = [[DeviceControl getInstance] currentDeviceArray];
            [self.devListTableView reloadData];
        };
        [self.navigationController pushViewController:editVC animated:YES];
    }];
    [alert addAction:cancel];
    [alert addAction:deleteBtn];
    [alert addAction:settingBtn];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        [alert setModalPresentationStyle:UIModalPresentationPopover];
        UIPopoverPresentationController *popPresenter = [alert
                                                         popoverPresentationController];
        popPresenter.sourceView = self.view;
        popPresenter.sourceRect = CGRectMake(self.view.bounds.size.width/2.0, self.view.bounds.size.height, 1.0, 1.0);
        popPresenter.permittedArrowDirections = UIPopoverArrowDirectionAny;
    }
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark -- UiTableViewDelegate/DataSource
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DeviceObject *devObject = [deviceArray objectAtIndex:indexPath.section];
    if (devObject == nil) {
        return;
    }
    if (devObject.state <=0 ) {
        //提示设备不在线
        [SVProgressHUD showErrorWithStatus:TS("EE_DVR_CONNECT_DEVICE_ERROR") duration:2.0];
        //刷新当前设备状态，如果是门铃的话，可能已经处于休眠状态而没有实时刷新
        [[DeviceManager getInstance] getDeviceState:devObject.deviceMac];
        return;
    }
    if (devObject.info.eFunDevState == 4) {//睡眠中
        [self getdeviceState:devObject.deviceMac];
        [SVProgressHUD showWithStatus:TS("Refresh_State")];
        //获取设备状态和门铃睡眠状态，然后return
    }else if (devObject.info.eFunDevState == 3) {//深度睡眠
        //直接return，深度睡眠需要设备端唤醒
        [SVProgressHUD showErrorWithStatus:TS("DEV_SLEEP_AND_CAN_NOT_WAKE_UP") duration:3.0];
        return;
    }else if (devObject.info.eFunDevState == 2) {//睡眠
        //唤醒睡眠，然后继续其他处理
        [SVProgressHUD showWithStatus:TS("Waking_up")];
        [[DeviceManager getInstance] deviceWeakUp:devObject.deviceMac];
        
        return;
    }
    
    [SVProgressHUD showWithStatus:TS("Get_Channle")];
    //现获取设备通道信息，多通道预览时需要。如果不需要支持多通道预览，则可以不获取通道信息，直接打开0通道
    selectNum = (int)indexPath.section;
    [[DeviceManager getInstance] getDeviceChannel:devObject.deviceMac];
    //获取成功之后，在回调接口中进入预览界面   - (void)getDeviceChannel:(NSString *)sId result:(int)result
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [deviceArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 110;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DeviceListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    DeviceObject *devObject = [deviceArray objectAtIndex:indexPath.section];
    if (devObject != nil) {
        cell.devSNLab.text = devObject.deviceMac;
        cell.devName.text = devObject.deviceName;
        [cell setDeviceState:devObject.state];
        [cell setSleepType:devObject.info.eFunDevState];
        cell.devTypeLab.text = [NSString getDeviceType:devObject.nType];
        cell.devImageV.image = [UIImage imageNamed:[NSString getDeviceImageType:devObject.nType]];
    }
    return cell;
}

#pragma - mark -- 刷新设备列表
- (void)refreshDeviceList {
    [self getdeviceState:nil];
}
#pragma - mark 获取设备在线状态结果
- (void)getDeviceState:(NSString *)sId result:(int)result {
    [self.devListTableView reloadData];
}
#pragma - mark 设备唤醒结果
- (void)deviceWeakUp:(NSString *)sId result:(int)result {
    if (result < 0) {
        [MessageUI ShowErrorInt:result];
        return;
    }
     [SVProgressHUD dismiss];
    DeviceObject *object = [[DeviceControl getInstance] GetDeviceObjectBySN:sId];
    object.info.eFunDevState = 1;
    [self.devListTableView reloadData];
}
#pragma mark 获取设备通道结果
- (void)getDeviceChannel:(NSString *)sId result:(int)result {
    if (result <= 0) {
        if(result == EE_DVR_PASSWORD_NOT_VALID)//密码错误，弹出密码修改框
        {
            [SVProgressHUD dismiss];
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:TS("EE_DVR_PASSWORD_NOT_VALID") message:sId preferredStyle:UIAlertControllerStyleAlert];
            [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                textField.placeholder = TS("set_new_psd");
            }];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:TS("Cancel") style:UIAlertActionStyleCancel handler:nil];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:TS("OK") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                UITextField *passWordTextField = alert.textFields.firstObject;
                DeviceObject *devObject = [deviceArray objectAtIndex:selectNum];
                 DeviceManager *manager = [DeviceManager getInstance];
                //点击确定修改密码
                [manager changeDevicePsw:sId loginName:devObject.loginName password:passWordTextField.text];
            }];
            [alert addAction:cancelAction];
            [alert addAction:okAction];
            [self presentViewController:alert animated:YES completion:nil];
            return;
        }
        [MessageUI ShowErrorInt:result];
        return;
    }
    [SVProgressHUD dismiss];
    //获取通道信息成功，进入预览界面
    DeviceObject *object = [[DeviceControl getInstance] GetDeviceObjectBySN:sId];
    //这里只选了当前设备的第一个通道进行预览，有些设备可能包含多个通道
    [[DeviceControl getInstance] setPlayItem:[object.channelArray firstObject]];
    PlayViewController *playVC = [[PlayViewController alloc] init];
    [self.navigationController pushViewController:playVC animated:YES];
}

#pragma mark 删除设备结果
- (void)deleteDevice:(NSString *)sId result:(int)result{
    if (result >= 0) {
        [SVProgressHUD showSuccessWithStatus:TS("Success")];
        deviceArray = [[DeviceControl getInstance] currentDeviceArray];
        [self.devListTableView reloadData];
    }else{
        [MessageUI ShowErrorInt:result];
    }
}

@end
