//
//  EncodeDataSourse.h
//  FunSDKDemo
//
//  Created by XM on 2018/10/25.
//  Copyright © 2018年 XM. All rights reserved.
//
#define N_RESOLUTION_COUNT 32
#import <Foundation/Foundation.h>

@interface EncodeDataSourse : NSObject

#pragma mark - 获取当前画质字符串
- (NSString *)getQualityString:(NSInteger)quality;
#pragma mark获取当前画质的int值
- (NSInteger)getQualityInt:(NSString*)qualityString;

#pragma mark - 获取开关字符串
-(NSString *)getEnableString:(BOOL)enable;
#pragma mark  获取开关BOOL值
-(BOOL)getEnableBool:(NSString *)enableStr;

#pragma mark - 根据索引获取当前分辨率名称
-(NSString*)getResolotionName:(NSInteger)nResIndex;
#pragma mark  根据分辨率名称获取当前索引
- (NSInteger)getResolutionIndex:(NSString*)name;

#pragma mark 根据索引获取当前分辨率大小
- (NSInteger)getResolutionSize:(NSInteger)nResIndex;
#pragma mark  NSTC 分辨率大小稍微有些不同，单独列出来供NSTC读取
- (NSInteger)getResolutionSizeNSTC:(NSInteger)nResIndex;

#pragma mark 根据传递的可用能力级、帧率、支持的分辨率来获取当前可用的分辨率
- (NSInteger)getResolutionMark:(NSInteger)size rate:(NSInteger)fps  range:(NSInteger)suppor;

#pragma mark 根据当前可用的分辨率二进制来获取分辨率名称字符串
- (NSMutableArray*)getResolutionArrayWithMark:(NSInteger)support;
@end
