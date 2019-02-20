//
//  TimeSynConfig.h
//  FunSDKDemo
/******
 *
 * 设备时间同步，包括时间同步、时区同步、夏令时设置等等,
 * 其中时间同步使用的是 FUN_DevCmdGeneral接口，和另外两个json接口有些不同
 *
 *
 ******/
@protocol TimeSynConfigDelegate <NSObject>
//获取时间时区夏令时代理回调
- (void)getTimeSynConfigResult:(NSInteger)result;
//保存时间时区夏令时代理回调
- (void)setTimeSynConfigResult:(NSInteger)result;

@end
#import "ConfigControllerBase.h"

@interface TimeSynConfig : ConfigControllerBase

@property (nonatomic, assign) id <TimeSynConfigDelegate> delegate;


#pragma mark - 获取设备夏令时、时间、时区
- (void)getTimeZoneConfig;
#pragma mark - 保存设备夏令时、时区、时间
- (void)setTimeSynConfig;//设置时间、时区、夏令时同步e

#pragma mark - 读取各项配置的属性值
- (NSString *)getTimeZone ; //读取时区
- (NSString *)getTimeQuery; //读取时间
- (NSString *)getDSTRule; //获取当前夏令时状态

@end
