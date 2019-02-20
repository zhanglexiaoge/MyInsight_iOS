//
//  RecordDataSourse.h
//  FunSDKDemo
//
//  Created by XM on 2018/11/7.
//  Copyright © 2018年 XM. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecordDataSourse : NSObject
#pragma mark - 通过mask值获取对应的录像状态字符串
- (NSString*)getRecordModeString:(int)mask;
#pragma mark 通过字符串获取对应的录像mask值
- (NSInteger)getRecordModeMask:(NSString*)maskString; //通过字符串获取对应的录像mask值

#pragma mark - 获取各个配置的设置范围
- (NSArray *)getRecordModeArray; //获取录像状态数组,3种状态
- (NSMutableArray *)getPreRecordArray; //获取预录时间数组 0-30
- (NSMutableArray *)getPacketLengthArray; //获取录像时长数组 1-120
@end
