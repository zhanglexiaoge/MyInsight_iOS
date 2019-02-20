//
//  XMAlarmMsgResource.h
//  XWorld
//
//  Created by XM on 2018/12/22.
//  Copyright © 2018年 xiongmaitech. All rights reserved.
//
/*****
 云服务资源信息对象
 
 ****/
#import <Foundation/Foundation.h>

@interface XMAlarmMsgResource : NSObject

@property (nonatomic, copy) NSString *ID;//资源ID
@property (nonatomic,assign) int size;//文件大小
@property (nonatomic,assign) int channel;
@property (nonatomic,assign) int event;
@property (nonatomic, copy) NSString *picUrl;
@property (nonatomic, copy) NSString *thumbnailPicUrl;
@property (nonatomic, copy) NSString *startTime;
@property (nonatomic,assign) int status;
@property (nonatomic,copy) NSString *alarmEvent;
@property (nonatomic, copy) NSString *JsonStr;

@property (nonatomic,copy) NSString *ObjName;
@property (nonatomic,copy) NSString *StorageBucket;

- (NSString*)getEventString;
@end
