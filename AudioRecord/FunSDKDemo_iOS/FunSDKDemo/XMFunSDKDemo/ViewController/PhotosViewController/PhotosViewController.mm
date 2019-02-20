//
//  PhotosViewController.m
//  FunSDKDemo
//
//  Created by XM on 2018/11/30.
//  Copyright © 2018年 XM. All rights reserved.
//

#import "PhotosViewController.h"
#import "FileControl.h"
#import "XMPlayerVC.h"
#import "FishEyeVideoVC.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>

@interface PhotosViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *imageArray;
     NSMutableArray *videoArray;
    UITableView *imageTableView;
    UITableView *videoTableView;
    FileControl *fileControl; //文件管理类
}
@property (nonatomic, strong) UIBarButtonItem *rightBarBtn;
@end

@implementation PhotosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置导航栏样式
    [self setNaviStyle];
    [self initData];
    //配置子试图
    [self configSubView];
}
- (void)chageFileType {
    if (imageTableView.hidden == YES) {
        imageTableView.hidden = NO;
        videoTableView.hidden = YES;
    }else{
        imageTableView.hidden = YES;
        videoTableView.hidden = NO;
    }
}
- (void)setNaviStyle {
    self.navigationItem.title = TS("photos");
    self.rightBarBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(chageFileType)];
    self.navigationItem.rightBarButtonItem = self.rightBarBtn;
    self.rightBarBtn.width = 15;
    self.rightBarBtn.tintColor = [UIColor whiteColor];
}

- (void)initData {
    fileControl = [[FileControl alloc] init];
    imageArray = [[fileControl getLocalImage] mutableCopy];
    videoArray = [[fileControl getLocalVideo] mutableCopy];
}
- (void)configSubView {
    [self.view addSubview:self.imageTableView];
    [self.view addSubview:self.videoTableView];
}

#pragma mark -- UITableViewDelegate/dataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
         return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView.tag == 0) {
        return imageArray.count;
    }
    return videoArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mainCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (tableView.tag == 0) {
        NSString *path = [imageArray objectAtIndex:indexPath.row];
        cell.imageView.image = [UIImage imageWithContentsOfFile:path];
        cell.textLabel.text = path.lastPathComponent;
    }else {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        NSString *path = [videoArray objectAtIndex:indexPath.row];
        cell.textLabel.text = path.lastPathComponent;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView.tag == 0) {
        //图片 (鱼眼图片可以使用鱼眼视频同样的方式展示来获得鱼眼效果，或者直接按照普通图片显示)
//        if (鱼眼图片 || fishImage) {
//            FishEyeVideoVC *fishvc = [[FishEyeVideoVC alloc]init];
//            fishvc.fileName = path;
//            fishvc.fisheyephotoOrvideo = 1;
//            [self presentViewController:fishvc animated:YES completion:nil];
//        }
    }else{
        //播放本地视频文件，先获取文件路径
        NSString *path = [videoArray objectAtIndex:indexPath.row];
        //如果录像类型是 .h265文件,特殊处理
        if ([fileControl getVideoTypeH265:path]) {
            XMPlayerVC *playerVC = [[XMPlayerVC alloc] init];
            playerVC.filePath = path;
            [self presentViewController:playerVC animated:YES completion:nil];
            return;
        }
        //如果是鱼眼视频文件，需要使用鱼眼播放器来播放
        if ([fileControl getVideoTypeFish:path]) {
            FishEyeVideoVC *fishvc = [[FishEyeVideoVC alloc]init];
            fishvc.fileName = path;
            fishvc.fisheyephotoOrvideo = 1;
            [self presentViewController:fishvc animated:YES completion:nil];
            return;
        }
        //普通的视频文件，就是通用的mp4文件
        AVPlayer *player = [AVPlayer playerWithURL:[NSURL fileURLWithPath:path]];
        AVPlayerViewController *playerViewController = [AVPlayerViewController new];
        playerViewController.player = player;
        [self presentViewController:playerViewController animated:YES completion:nil];
        [playerViewController.player play];
    }
}
- (UITableView *)imageTableView {
    if (!imageTableView) {
        imageTableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 0, ScreenWidth - 20, ScreenHeight) style:UITableViewStylePlain];
        imageTableView.delegate = self;
        imageTableView.dataSource = self;
        [imageTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"mainCell"];
        imageTableView.tag = 0;
    }
    return imageTableView;
}
- (UITableView *)videoTableView {
    if (!videoTableView) {
        videoTableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 0, ScreenWidth - 20, ScreenHeight) style:UITableViewStylePlain];
        videoTableView.delegate = self;
        videoTableView.dataSource = self;
        [videoTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"mainCell"];
        videoTableView.tag = 1;
        videoTableView.hidden = YES;
    }
    return videoTableView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
