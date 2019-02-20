//
//  RecordConfig.h
//  FunSDKDemo
//
//  Created by XM on 2018/11/6.
//  Copyright © 2018年 XM. All rights reserved.
//
/****
 *
 *设备录像配置
 *第一步：先获取设备主辅码流录像能力级，判断设备是否分别支持主码流和辅码流录像（如果能确认app所支持的设备类型都支持录像，可以不做这个判断）
 *第二部：根据获取到的能力级，来获取设备录像状态，并进行修改保存
 * SupportExtRecord.h 设备是否支持主码流和辅码流录像
 * Record.h 录像配置
 *ExtRecord.h 辅码流录像配置
 *
 ***/
@protocol RecordConfigDelegate <NSObject>
//录像配置支持情况回调 statu = 0：只支持主码流。statu=1:只支持辅码流。statu=2:主辅码流都支持
- (void)recordSuportStatu:(NSInteger)statu;
//获取录像配置代理回调
- (void)getRecordConfigResult:(NSInteger)result;
//保存录像配置代理回调
- (void)setRecordConfigResult:(NSInteger)result;

@end

#import "ConfigControllerBase.h"

@interface RecordConfig : ConfigControllerBase

@property (nonatomic, assign) id <RecordConfigDelegate> delegate;

#pragma  mark 判断当前录像配置是否可用
- (BOOL)checkRecord;

#pragma mark - 获取录像配置。 1、获取是否支持主辅码流录像。2、获取支持的录像配置
-(void)getRecordConfig;
#pragma mark - 保存录像配置
- (void)setRecordConfig;

#pragma mark - 读取各项配置的属性值
- (NSString*)getMainPreRecord; //读取主码流录像预录时间  单位s  0-30
- (NSString*)getExtraPreRecord; //读取辅码流录像预录时间  单位s

- (NSString*)getMainPacketLength ;//读取主码流录像时长  单位minute  1-120
- (NSString*)getExtraPacketLength ; //读取辅码流录像时长 单位minute

- (NSString*)getMainRecordMode; //获取主码流录像打开状态。包括始终录像、报警联动录像、关闭录像
- (NSString*)getExtraRecordMode; //获取辅码流录像打开状态。包括始终录像、报警录像、关闭录像

#pragma mark - 设置各项配置的属性值
- (void)setMainPreRecord:(NSString*)perRecord; //读取主码流录像预录时间
- (void)setExtraPreRecord:(NSString*)perRecord; //读取辅码流录像预录时间

- (void)setMainPacketLength:(NSString*)PacketLength ; //读取主码流录像时长
- (void)setExtraPacketLength:(NSString*)PacketLength ;//读取辅码流录像时长

- (void)setMainRecordMode:(NSString*)maskString;//设置主码流录像开关状态
- (void)setExtraRecordMode:(NSString*)maskString; //设置辅码流录像开关状态

#pragma mark - 获取各种配置的设置范围
- (NSMutableArray *)getMainRecordModeArray;//主码流录像状态数组
- (NSMutableArray *)getExtraRecordModeArray ;//辅码流录像状态数组

- (NSMutableArray *)getMainPrerecordArray ; //主码流预录时间数组
- (NSMutableArray *)getExtraPrerecordArray; //辅码流预录时间数组

- (NSMutableArray *)getMainPacketLengthArray ; //主码流录像时长数组
- (NSMutableArray *)getExtraPacketLengthArray; //辅码流录像时长数组

#pragma mark - 示例：设置周二晚上主码流为报警联动录像
- (void)setTuesdayNightAlarmRecord;
@end
