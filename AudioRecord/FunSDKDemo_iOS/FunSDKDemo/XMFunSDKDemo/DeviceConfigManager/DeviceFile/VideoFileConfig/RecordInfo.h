//
//  RecordInfo.h
//  XMEye
//
//  Created by XM on 18/10/20.
//  Copyright (c) 2018年 XM. All rights reserved.
//
/*****
 *
 * 按文件查询录像的结果保存对象，包含三个属性，文件名称、录像类型、录像大小、开始时间、结束时间
 *
 *
 *****/
#import <Foundation/Foundation.h>

@interface RecordInfo : NSObject

typedef struct XM_SYSTEM_TIME {
    int  year;
    int  month;
    int  day;
    int  wday;
    int  hour;
    int  minute;
    int  second;
    int  isdst;
}XM_SYSTEM_TIME;

@property (nonatomic,assign) NSInteger channelNo;
@property (nonatomic,assign) NSInteger fileType;
@property (nonatomic,retain) NSString  *fileName;
@property (nonatomic,assign) long      fileSize;
@property (nonatomic,assign) XM_SYSTEM_TIME   timeBegin;
@property (nonatomic,assign) XM_SYSTEM_TIME   timeEnd;
@end
