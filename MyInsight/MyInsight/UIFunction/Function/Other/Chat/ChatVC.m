//
//  ChatVC.m
//  MyInsight
//
//  Created by SongMenglong on 2018/3/26.
//  Copyright © 2018年 SongMenglong. All rights reserved.
//

#import "ChatVC.h"
#import <Masonry.h>
#import "ChatTextCell.h"
#import "ChatImageCell.h"
#import "ChatAudioCell.h"
#import "ChatVideoCell.h"
#import "ChatTipCell.h"
#import "ChatFileCell.h"

@interface ChatVC ()<UITableViewDelegate, UITableViewDataSource>
// 聊天列表
@property (nonatomic, strong) UITableView *chatTableView;

@end

@implementation ChatVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"隔壁王大叔";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.chatTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, CGRectGetHeight(self.view.bounds)-49) style:UITableViewStylePlain];
    self.chatTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.chatTableView.backgroundColor = [UIColor redColor];
    self.chatTableView.allowsSelection = NO;
    self.chatTableView.delegate     = self;
    self.chatTableView.dataSource = self;
    //普通文本,表情消息类型
    [self.chatTableView registerClass:[ChatTextCell class] forCellReuseIdentifier:@"ChatTextCell"];
    //语音消息类型
    [self.chatTableView registerClass:[ChatAudioCell class] forCellReuseIdentifier:@"ChatAudioCell"];
    //图片消息类型
    [self.chatTableView registerClass:[ChatImageCell class] forCellReuseIdentifier:@"ChatImageCell"];
    //视频消息类型
    [self.chatTableView registerClass:[ChatVideoCell class] forCellReuseIdentifier:@"ChatVideoCell"];
    //文件消息类型
    [self.chatTableView registerClass:[ChatFileCell class] forCellReuseIdentifier:@"ChatFileCell"];
    //提示消息类型
    [self.chatTableView registerClass:[ChatTipCell class] forCellReuseIdentifier:@"ChatTipCell"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    return NULL;
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
