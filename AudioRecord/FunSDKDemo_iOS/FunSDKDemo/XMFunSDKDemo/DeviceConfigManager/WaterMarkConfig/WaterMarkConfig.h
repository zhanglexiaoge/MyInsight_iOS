//
//  WaterMarkConfig.h
//  FunSDKDemo
//
//  Created by wujiangbo on 2018/12/19.
//  Copyright © 2018 wujiangbo. All rights reserved.
//
/******
 *
 * 水印设置功能
 *1、获取自定义水印及官方水印信息
 *2、根据修改的开关状态及水印文字进行修改
 *3、自定义水印目前只支持数字和字母，汉字需设置点阵ChannelDot
 *4、官方水印开关建议关闭
 ******/
#import <Foundation/Foundation.h>
#import "ConfigControllerBase.h"

NS_ASSUME_NONNULL_BEGIN

@protocol WaterMarkConfigDelegate <NSObject>

@optional
//获取官方水印回调
-(void)getOsdLogoConfigResult:(NSInteger)result;
//获取自定义水印信息回调
-(void)getLogoWidgetResult:(NSInteger)result;
//设置官方水印回调
-(void)setOsdLogoConfigResult:(NSInteger)result;
//设置自定义水印信息回调
-(void)setLogoWidgetResult:(NSInteger)result;

@end

@interface WaterMarkConfig : ConfigControllerBase
@property (nonatomic, assign) id <WaterMarkConfigDelegate> delegate;
#pragma mark - 获取水印信息
- (void)getLogoConfig;
#pragma mark - 设置水印
- (void)setWaterMarkConfig;

#pragma mark - 获取自定义水印开关状态
- (int)getLogoEnable;
#pragma mark - 获取自定义水印文字
- (NSString *)getLogoTitle;
#pragma mark - 获取官方水印开关状态
- (int)getOsdLogoEnable;
#pragma mark - 设置自定义水印开关
- (void)setLossEnable:(int)enable;
#pragma mark - 设置自定义水印文字（目前只支持数字和字母，汉字需设置点阵ChannelDot）
- (void)setLogoTitle:(NSString *)title;
#pragma mark - 设置官方水印开关
- (void)setOsdLogoEnable:(int)enable;
@end

NS_ASSUME_NONNULL_END
