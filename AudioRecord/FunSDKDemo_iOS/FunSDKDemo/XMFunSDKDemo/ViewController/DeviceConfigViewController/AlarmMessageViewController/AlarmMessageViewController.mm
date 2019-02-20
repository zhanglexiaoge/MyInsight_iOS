//
//  AlarmMessageViewController.m
//  FunSDKDemo
//
//  Created by wujiangbo on 2018/12/1.
//  Copyright © 2018 wujiangbo. All rights reserved.
//

#import "AlarmMessageViewController.h"
#import "AlarmMessageCell.h"
#import "AlarmMessageConfig.h"
#import "AlarmMessageInfo.h"
#import <Masonry/Masonry.h>
#import "AlarmMessagePicViewController.h"

@interface AlarmMessageViewController ()<UITableViewDelegate,UITableViewDataSource,AlarmMessageCellDelegate,AlarmMessageConfigDelegate>
{
    NSMutableArray *messageArray;                   // 消息数组
    
}
@property (nonatomic,strong)UITableView *messageTableV;     //消息列表
@property (nonatomic,strong)AlarmMessageConfig *config;     //消息管理器

@end

@implementation AlarmMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    //设置导航栏样式
    [self setNaviStyle];
    
    //数据初始化
    self.config = [[AlarmMessageConfig alloc] init];
    self.config.delegate = self;
    [self.view addSubview:self.messageTableV];
    
    //布局
    [self configSubviews];
    
    //获取推送消息列表
    [self.config searchAlarmInfo];
}

- (void)setNaviStyle {
    self.navigationItem.title = TS("Alarm_message_push");
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"new_back.png"] style:UIBarButtonItemStylePlain target:self action:@selector(popViewController)];
    self.navigationItem.leftBarButtonItem = leftBtn;
}

-(void)configSubviews{
    [self.messageTableV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view);
        make.height.equalTo(self.view).offset(-64);
        make.top.equalTo(@64);
        make.left.equalTo(self);
    }];
}

#pragma mark - button event
#pragma mark 点击返回上层
-(void)popViewController{

    if ([SVProgressHUD isVisible]){
        [SVProgressHUD dismiss];
    }

    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 点击开始下载图片
-(void)beginDownlaodAlarmPic:(int)index{
    AlarmMessageInfo *info = [messageArray objectAtIndex:index];
    NSString *uID = [info getuId];
    NSString *filePath = [[NSString alarmMessagePicPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg",uID]];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    
    //图片存在则直接跳转
    if (data && [data length] > 1024) {
        AlarmMessagePicViewController *picVC = [[AlarmMessagePicViewController alloc] init];
        
        picVC.imageV.image = [UIImage imageWithData:data];
        
        [self.navigationController pushViewController:picVC animated:YES];
    }
    //图片不存在则去下载图片
    else{
        [SVProgressHUD show];
        [self.config searchAlarmPic:uID fileName:filePath];
    }
    
}

#pragma mark -- UITableViewDelegate/DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return messageArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    AlarmMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AlarmMessageCell"];
    if (!cell) {
        cell = [[AlarmMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AlarmMessageCell"];
    }
    cell.index = (int)indexPath.row;
    cell.delegate = self;
    
    AlarmMessageInfo *info = [messageArray objectAtIndex:indexPath.row];
    NSString *videoType;
    if ([[info getEvent] isEqualToString:@"VideoMotion"]) {
        videoType = @"Motion_detection";//移动检测
    }else if ([[info getEvent] isEqualToString:@"VideoBlind"]) {
        videoType = @"Video_block"; //视频遮挡
    }else if ([[info getEvent] isEqualToString:@"VideoLoss"]) {
        videoType = @"Video_loss_alarm"; //视频丢失
    }else if ([[info getEvent] isEqualToString:@"LocalIO"]) {
        videoType = @"LocalIO"; //本地IO报警
    }else if ([[info getEvent] isEqualToString:@"appEventHumanDetectAlarm"]){
        videoType = @"appEventHumanDetectAlarm"; //人形检测
    }else if ([[info getEvent] isEqualToString:@"VideoAnalyze"]){
        videoType = @"AnalyzeConfig"; //智能分析报警
    }else if ([[info getEvent] isEqualToString:@"LocalAlarm"]){
        videoType = @"Caller"; //访客来电
    }else if ([[info getEvent] isEqualToString:@"PIRAlarm"]){
        videoType = @"IDR_MSG_LOITERING"; //徘徊检测
    }else if ([[info getEvent] isEqualToString:@"LowBattery"]){
        videoType = @"IDR_LOW_BATTERY"; //低电量
    }else if ([[info getEvent] isEqualToString:@"ReserveWakeAlarm"]){
        videoType = @"IDR_MSG_RESERVER_WAKE"; //预约唤醒
    }else if ([[info getEvent] isEqualToString:@"IntervalWakeAlarm"]){
        videoType = @"IDR_MSG_INTERVAL_WAKE"; //间隔唤醒
    }else if ([[info getEvent] isEqualToString:@"ForceDismantleAlarm"]){
        videoType = @"IDR_MSG_FORCE_DISMANTLE"; //智能设备被拔出
    }else{
        videoType = [info getEvent];
    }
    cell.detailLabel.text =  [NSString stringWithFormat:@"%@\n%@\n%@",[info getStartTime],TS([videoType UTF8String]),[info  getStatus]];
    
    //获取缩略图，存在则显示缩略图，不存在显示默认图片
    NSData *data = [self findAlarmImage:info];
    UIImage *image = [UIImage imageWithData:data];
    if (data != nil) {
        cell.pushImageView.image = image;
    }else{
        cell.pushImageView.image = [UIImage imageNamed:@"icon_funsdk.png"];
    }
    
    cell.tag = [[info getuId] longLongValue];
    
    return cell;
}

#pragma mark - 获取缩略图
-(NSData*)findAlarmImage:(AlarmMessageInfo *)info
{
    if ([info getPicSize].length > 0) {
        NSString *uID = [info getuId];
        NSString *filePath = [[NSString thumbnailPath] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg",uID]];
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        if (data && [data length] > 1024) {
            return data;
        }
        else{
            [self.config searchAlarmThumbnail:uID fileName:filePath];
        }
    }
    return nil;
}

#pragma mark - sdk回调处理
#pragma mark 报警消息查询回调
-(void)getAlarmMessageConfigResult:(NSInteger)result message:(NSMutableArray *)array{
    if (result >= 0) {
        [SVProgressHUD dismiss];
        messageArray = [array mutableCopy];
        [self.messageTableV reloadData];
    }
    else{
        [SVProgressHUD showErrorWithStatus:TS("Error")];
    }
}
#pragma mark 报警图片搜索回调
-(void)searchAlarmPicConfigResult:(NSInteger)result imagePath:(NSString *)imagePath{
    NSString* imageName = [[imagePath componentsSeparatedByString:@"/"]lastObject];
    //缩略图
    if ([imagePath containsString:@"Thumbnail"]) {
        for (int i = 0; i < messageArray.count; i++) {
            AlarmMessageInfo *json = [messageArray objectAtIndex:i];
            if ([[NSString stringWithFormat:@"%@.jpg",[json getuId]] isEqualToString:imageName]) {
                AlarmMessageCell *cell = (AlarmMessageCell *)[self.messageTableV viewWithTag:[[[imageName componentsSeparatedByString:@"."] firstObject] longLongValue]];
                NSData *data = [NSData dataWithContentsOfFile:imagePath];
                UIImage *image = [[UIImage alloc] initWithData:data];
                if (image != nil) {
                    cell.pushImageView.image = image;
                    data = nil;
                }
            }
        }
    }
    //报警图
    else{
        AlarmMessagePicViewController *picVC = [[AlarmMessagePicViewController alloc] init];
        
        NSData *data = [NSData dataWithContentsOfFile:imagePath];
        
        picVC.imageV.image = [UIImage imageWithData:data];
        
        [self.navigationController pushViewController:picVC animated:YES];
    }
}

#pragma mark - lazy load
-(UITableView *)messageTableV{
    if (!_messageTableV) {
        _messageTableV = [[UITableView alloc] init];
        _messageTableV.delegate = self;
        _messageTableV.dataSource = self;
        [_messageTableV registerClass:[AlarmMessageCell class] forCellReuseIdentifier:@"AlarmMessageCell"];
        _messageTableV.rowHeight = 70;
        _messageTableV.tableFooterView = [[UIView alloc] init];
    }
    
    return _messageTableV;
}


@end
