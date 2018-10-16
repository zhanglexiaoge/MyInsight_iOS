//
//  ChatModel.h
//  MyInsight
//
//  Created by SongMenglong on 2018/3/27.
//  Copyright © 2018年 SongMenglong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChatContentModel.h"
#import <UIKit/UIKit.h>

@interface ChatModel : NSObject
// 群ID
@property (nonatomic, copy) NSString *groupID;
// 消息发送者ID
@property (nonatomic, copy) NSString *fromUserID;
// 对方ID
@property (nonatomic, copy) NSString *toUserID;
// 发送者头像url
@property (nonatomic, copy) NSString *fromPortrait;
// 对方头像url
@property (nonatomic, copy) NSString *toPortrait;
// 我对好友命名的昵称
@property (nonatomic, copy) NSString *nickName;
// @目标ID
@property (nonatomic, copy) NSArray<NSString *> *atToUserIDs;
// 消息类型
@property (nonatomic, copy) NSString *messageType;
// 内容类型
@property (nonatomic, copy) NSString *contenType;
// 聊天类型 , 群聊,单聊
@property (nonatomic, copy) NSString *chatType;
// 设备类型
@property (nonatomic, copy) NSString *deviceType;
// TCP版本码
@property (nonatomic, copy) NSString *versionCode;
// 消息ID
@property (nonatomic, copy) NSString *messageID;
// 消息是否为本人所发
@property (nonatomic, strong) NSNumber *byMyself;
// 是否已经发送成功
@property (nonatomic, copy) NSNumber *isSend;
// 是否已读
@property (nonatomic, strong) NSNumber *isRead;
// 时间戳
@property (nonatomic, copy) NSString *sendTime;
// 心跳标识
@property (nonatomic, copy) NSString *beatID;
// 群名称
@property (nonatomic, copy) NSString *groupName;
// 免打扰状态  , 1为正常接收  , 2为免打扰状态 , 3为屏蔽状态
@property (nonatomic, strong) NSNumber *noDisturb;
// 内容
@property (nonatomic, strong) ChatContentModel *content;
// 是否正在发送中
@property (nonatomic, strong) NSNumber *isSending;
// 进度
@property (nonatomic, strong) NSNumber *progress;

#pragma mark - chatlist独有部分
// 未读数
@property (nonatomic, strong) NSNumber *unreadCount;
// 最后一条消息
@property (nonatomic, copy) NSString *lastMessage;
// 最后一条消息时间
@property (nonatomic, copy) NSString *lastTimeString;

# pragma mark - 额外需要部分属性
// 消息高度
@property (nonatomic , assign) CGFloat messageHeight;
// 是否展示时间
@property (nonatomic, assign,getter=shouldShowTime) BOOL showTime;

@end


