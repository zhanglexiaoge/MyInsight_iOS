//
//  EncodeConfig.h
//  FunSDKDemo
//
//  Created by XM on 2018/10/24.
//  Copyright © 2018年 XM. All rights reserved.
//
/***
 *
 * 设备编码配置
 * Simplify_Encode 编码配置   获取当前正在使用的配置
 * EncodeCapability  编码配置能力级   获取设备可以进行选择的配置
 * General_Location  通用配置    判断当前设备视频制式，对分辨率和帧率有些影响
 *
 *****/
@protocol EncodeConfigDelegate <NSObject>
//获取编码配置代理回调
- (void)getEncodeConfigResult:(NSInteger)result;
//保存编码配置代理回调
- (void)setEncodeConfigResult:(NSInteger)result;

@end

#import "ConfigControllerBase.h"

@interface EncodeConfig : ConfigControllerBase

@property (nonatomic, assign) id <EncodeConfigDelegate> delegate;

#pragma mark 获取编码配置
- (void)getEncodeConfig;
#pragma mark 保存编码配置
- (void)setEncodeConfig;

#pragma  mark - 判断编码配置是否可用，显示配置时用到
- (BOOL)checkEncode;//这两个方法必须判断，如果不判断可能会因为数据异常崩溃
#pragma  mark 判断编码能力级是否可用，计算设置范围时用到
- (BOOL)checkEncodeAbility;

#pragma mark - - -下面是上层界面读取配置数据和修改配置数据的方法
#pragma mark 读取各项配置的属性值
- (NSString*)getMainResolution; //读取主码流分辨率
- (NSString*)getExtraResolution; //读取辅码流分辨率

- (NSInteger)getMainFPS;//读取主码流帧率
- (NSInteger)getExtraFPS;//读取辅码流帧率

- (NSString*)getMainQuality;//读取主码流画质
- (NSString*)getExtraQuality;//读取辅码流画质

- (NSString*)getMainAudioEnable;//读取主码流音频开关状态
- (NSString*)getExtraAudioEnable;//读取主码流音频开关状态

- (NSString *)getMainCompressionEnable; //取出注码流视频编码格式

-(NSString*)getExtraVideoEnable;//读取辅码流视频开关

#pragma mark 设置各项配置的属性值
- (void)setMainResolution:(NSString*)Resolution; //设置主码流分辨率
- (void)setExtraResolution:(NSString*)Resolution; //设置辅码流分辨率

- (void)setMainFPS:(NSInteger)Fps;//设置主码流帧率
- (void)setExtraFPS:(NSInteger)Fps;//设置辅码流帧率

- (void)setMainQuality:(NSString*)Quality;//设置主码流画质
- (void)setExtraQuality:(NSString*)Quality;//设置辅码流画质

- (void)setMainAudioEnable:(NSString*)AudioEnable;//设置主码流音频开关状态
- (void)setExtraAudioEnable:(NSString*)AudioEnable;//设置主码流音频开关状态

-(void)setExtraVideoEnable:(NSString*)VideoEnable;//设置辅码流视频开关

#pragma mark --- 获取各种配置的设置范围（需要根据能力级动态计算）
-(NSMutableArray*)getMainResolutionArray; //获取主码流分辨率的设置范围
-(NSMutableArray*)getExtraResolutionArray; //获取辅码流分辨率的设置范围

-(NSMutableArray*)getMainFpsArray; //获取主码流帧率的设置范围
-(NSMutableArray*)getExtraFpsArray; //获取辅码流帧率的设置范围

- (NSMutableArray*)getMainQualityArray;//获取主码流支持的清晰度
- (NSMutableArray*)getExtraQualityArray;//获取辅码流支持的清晰度

- (NSMutableArray*)getEnableArray;//获取码流开关数组


@end
