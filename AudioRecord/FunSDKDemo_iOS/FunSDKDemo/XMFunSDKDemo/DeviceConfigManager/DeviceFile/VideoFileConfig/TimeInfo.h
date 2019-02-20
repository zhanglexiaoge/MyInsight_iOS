//
//  TimeInfo.h
//  FunSDKDemo
//
//  Created by XM on 2018/11/14.
//  Copyright © 2018年 XM. All rights reserved.
//
/*****
 *
 * 按时间查询录像的结果保存对象，包含三个属性，录像类型、开始时间、结束时间
 *
 *
 *****/

#import <Foundation/Foundation.h>

typedef struct {
    unsigned char t0:4;
    unsigned char t1:4;
} ByteRecordType;

enum Video_Type   {    // 录像类型
    TYPE_NONE = 0,
    TYPE_NORMAL = 1,      // 普通录像
    TYPE_ALARM = 2,       // 报警录像
    TYPE_DETECTION = 3,   // 检测录像
    TYPE_HAND = 4,        // 手动录像
};

@interface TimeInfo : NSObject

@property (nonatomic) enum Video_Type type;
//如果在开始时间和结束时间之内有录像，即使只有一秒的录像，也会认为这段时间有录像
@property (nonatomic, assign) int start_Time;  //时间段开始时间，单位秒 s
@property (nonatomic, assign) int end_Time; //时间段结束时间，单位秒 s
@end
