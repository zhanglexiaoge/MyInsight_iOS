//
//  ChatListVC.m
//  MyInsight
//
//  Created by SongMenglong on 2018/3/26.
//  Copyright © 2018年 SongMenglong. All rights reserved.
//

#import "ChatListVC.h"
#import <Masonry.h>
#import "ChatListCell.h"
#import "ChatVC.h"
#import "ChatModel.h"
#import "ChatContentModel.h"

@interface ChatListVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
//消息数据源
@property (nonatomic, strong) NSMutableArray *messagesArray;

@end

/*
 https://github.com/coderMyy/CocoaAsyncSocket_Demo
 */

@implementation ChatListVC

// 重写getter方法
- (NSMutableArray *)messagesArray {
    // 消息数据源
    if (!_messagesArray) {
        _messagesArray = [NSMutableArray array];
    }
    return _messagesArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"聊天列表";
    
    self.tableView = [[UITableView alloc] init];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(0.0f);
        make.left.equalTo(self.view.mas_left).offset(0.0f);
        make.right.equalTo(self.view.mas_right).offset(0.0f);
        make.bottom.equalTo(self.view.mas_bottom).offset(0.0f);
    }];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 60.0f;
    
    
    // 注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"ChatListCell" bundle:nil] forCellReuseIdentifier:@"ChatListCell"];
    
    [self getMessages];
}

#pragma mark - 创建数据
- (void)getMessages {
    //暂时先模拟假数据 , 后面加上数据库结构,再修改
    NSArray *tips = @[@"项目里IM这块因为一直都是在摸索,所以特别乱..",@"这一份相当于是进行重构,分层,尽量减少耦合性",@"还有就是把注释和大体思路尽量写下来",@"UI部分很耗时,因为所有的东西都是自己写的",@"如果有兴趣可以fork一下,有空闲时间我就会更新一些",@"如果觉得有用,麻烦star一下噢....",@"如果觉得有用,麻烦star一下噢....",@"具体IP端口涉及公司隐私东西已经隐藏....",@"具体IP端口涉及公司隐私东西已经隐藏...."];
    
    for (NSInteger index = 0; index < 30; index++) {
        ChatModel *chatModel = [[ChatModel alloc] init];
        ChatContentModel *chatContentModel = [[ChatContentModel alloc] init];
        // 赋值
        chatModel.content = chatContentModel;
        chatModel.nickName = @"小哥哥";
        if (index < tips.count) {
            chatModel.lastMessage = tips[index];
        } else {
            chatModel.lastMessage  = @"滚滚长江东逝水，往事一去不复回";
        }
        chatModel.noDisturb = index%3==0 ? @2 : @1;
        chatModel.unreadCount = @(index);
        //chatModel.lastTimeString = [NSDate timeStringWithTimeInterval:chatModel.sendTime];
        [self.messagesArray addObject:chatModel];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-  (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.messagesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChatListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ChatListCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle]loadNibNamed:@"ChatListCell" owner:self options:nil] lastObject];
        //cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    
    
    
    return cell;
}

// 选中cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"选中聊天啦");
    
    ChatVC *chatVC = [[ChatVC alloc] init];
    chatVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chatVC animated:YES];
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
