//
//  SeniorVC.m
//  MyInsight
//
//  Created by SongMenglong on 2018/1/24.
//  Copyright © 2018年 SongMenglong. All rights reserved.
//

#import "SeniorVC.h"
#import <SWRevealViewController.h>
#import <Masonry.h>
#import "OpenCVVC.h" // OpenCV
#import "FFmpegVC.h" // FFmpegVC
#import "IJKPlayerVC.h"
#import "AudioVC.h"
#import "VideoVC.h"
#import "SocketVC.h"
#import "OpenGLVC.h"
#import "CoreFoundationVC.h"

@interface SeniorVC ()<UITableViewDelegate, UITableViewDataSource>
// 列表
@property (nonatomic, strong) UITableView *tableView;
// 数组数据
@property (nonatomic, strong) NSArray *dataArray;
@end

static const NSString *SocketStr = @"Socket通讯";
static const NSString *OpenCVStr = @"OpenCV";
static const NSString *FFmpegStr = @"FFmpeg";
static const NSString *OpenGLStr = @"OpenGL";
// ijkplayer
static const NSString *IJKPlayerStr = @"IJKPlayer";

static const NSString *AudioStr = @"Audio音频";
static const NSString *VideoStr = @"Video视频";
static const NSString *CoreFoundationStr = @"Core Foundation";
static const NSString *BarrageRendererStr = @"弹幕渲染器";

@implementation SeniorVC

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
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
    
    // 处理数据
    [self handleTableViewData];
    // 创建列表
    [self creatTableView];
    // 代码约束布局
    [self masonryLayoutSubview];
}

// 处理数据
- (void)handleTableViewData {
    self.dataArray = @[CoreFoundationStr, SocketStr, OpenCVStr, FFmpegStr, IJKPlayerStr, AudioStr, VideoStr, OpenGLStr, BarrageRendererStr];
}

#pragma mark - 创建TableView
- (void)creatTableView {
    self.tableView = [[UITableView alloc] init];
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
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

// 选中cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 获取字符串
    NSString *cellString = [self.dataArray objectAtIndex:indexPath.row];
    if ([cellString isEqual:CoreFoundationStr]) {
        // Core Foundation
        CoreFoundationVC *coreFoundationVC = [[CoreFoundationVC alloc] init];
        coreFoundationVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:coreFoundationVC animated:YES];
    }
    if ([cellString isEqual:SocketStr]) {
        // Socket通讯
        SocketVC *socketVC = [[SocketVC alloc] init];
        socketVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:socketVC animated:YES];
    }
    if ([cellString isEqual:OpenCVStr]) {
        // OpenCV
        OpenCVVC *openCVVC = [[UIStoryboard storyboardWithName:@"Home" bundle:NULL] instantiateViewControllerWithIdentifier:@"OpenCVVC"];
        openCVVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:openCVVC animated:YES];
    }
    if ([cellString isEqual:OpenGLStr]) {
        // OpenGL
        OpenGLVC *openGLVC = [[OpenGLVC alloc] init];
        openGLVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:openGLVC animated:YES];
    }
    if ([cellString isEqual:FFmpegStr]) {
        // FFmpeg
        FFmpegVC *ffmpegVC = [[FFmpegVC alloc] init];
        ffmpegVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:ffmpegVC animated:YES];
    }
    if ([cellString isEqual:IJKPlayerStr]) {
        // IJKPlayer
        IJKPlayerVC *ijkPlayerVC = [[IJKPlayerVC alloc] init];
        ijkPlayerVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:ijkPlayerVC animated:YES];
    }
    if ([cellString isEqual:AudioStr]) {
        // 音频
        AudioVC *audioVC = [[AudioVC alloc] init];
        audioVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:audioVC animated:YES];
    }
    if ([cellString isEqual:VideoStr]) {
        // 视频
        VideoVC *videoVC = [[VideoVC alloc] init];
        videoVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:videoVC animated:YES];
    }
    if ([cellString isEqual:BarrageRendererStr]) {
        // 弹幕渲染器
        
    }
}

#pragma mark - 代码约束布局
- (void)masonryLayoutSubview {
    // TableView
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(0.0f);
        make.left.equalTo(self.view.mas_left).offset(0.0f);
        make.right.equalTo(self.view.mas_right).offset(0.0f);
        make.bottom.equalTo(self.view.mas_bottom).offset(0.0f);
    }];
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
