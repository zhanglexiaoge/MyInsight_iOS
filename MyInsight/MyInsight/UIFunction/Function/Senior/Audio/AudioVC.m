
//
//  AudioVC.m
//  MyInsight
//
//  Created by SongMenglong on 2018/1/18.
//  Copyright © 2018年 SongMenglong. All rights reserved.
//

#import "AudioVC.h"
#import <Masonry.h>
#import "SoundVC.h" // 音效
#import "MusicVC.h"

@interface AudioVC ()<UITableViewDelegate, UITableViewDataSource>
// 列表
@property (nonatomic, strong) UITableView *tableView;
// 数组
@property (nonatomic, strong) NSArray *dataArray;

@end

/*
 [iOS开发系列--音频播放、录音、视频播放、拍照、视频录制](http://www.cnblogs.com/kenshincui/p/4186022.html)
 */

/*
 定义功能
 音频：
 音效
 音乐
 音频会话
 录音
 音频队列服务
 
 视频：
 摄像头：
 
 
 */

static const NSString *YinXiaoStr = @"音效";
static const NSString *YinYueStr = @"音乐";
static const NSString *HuiHuaStr = @"音频会话";
static const NSString *LuYin_Str = @"录音";
static const NSString *DuiLieStr = @"音频队列服务";

@implementation AudioVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"音频学习";
        
    self.dataArray = @[YinXiaoStr, YinYueStr, HuiHuaStr, LuYin_Str, DuiLieStr];
    
    // 创建列表
    [self creatTableView];
    // 代码约束布局
    [self masonryLayoutSubview];
}

#pragma mark 创建列表页面
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

#pragma mark 实现TableView的代理协议
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    if (cell == nil) {
        //cell = [[[NSBundle mainBundle]loadNibNamed:@"MineCell" owner:self options:nil]lastObject];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    // 赋值    
    cell.textLabel.text = self.dataArray[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"选中cell");
    NSString *selectStr = self.dataArray[indexPath.row];
    if ([selectStr isEqual:YinXiaoStr]) {
        // 音效
        SoundVC *soundVC = [[SoundVC alloc] init];
        soundVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:soundVC animated:YES];
    }
    if ([selectStr isEqual:YinYueStr]) {
        // 音乐
        MusicVC *musicVC = [[UIStoryboard storyboardWithName:@"Mine" bundle:NULL] instantiateViewControllerWithIdentifier:@"MusicVC"];
        //MusicVC *musicVC = [[MusicVC alloc] init];
        musicVC.hidesBottomBarWhenPushed = YES;
        // MusicVC
        [self.navigationController pushViewController:musicVC animated:YES];
    }
}

// 代码约束布局
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
