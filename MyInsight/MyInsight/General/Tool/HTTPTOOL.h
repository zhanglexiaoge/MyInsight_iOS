//
//  HTTPTOOL.h
//  GOpenSource_AppKit
//
//  Created by SongMenglong on 2017/11/2.
//  Copyright © 2017年 Gizwits. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>

typedef NS_ENUM(NSUInteger, responseStyle)  {
    DATA,
    JSON,
    XML,
};

typedef NS_ENUM(NSUInteger, bodyStyle) {
    JSONStyle,
    stringStyle,
};


@interface HTTPTOOL : NSObject

/* GET请求
 * @param url: 请求网址
 * @param body: 请求参数
 * @param sucess:请求成功时返回的数据
 * @param fail: 请求失败时的错误信息
 */
+ (void)GETWithURL:(NSString *)url body:(NSDictionary *)body httpHead:(NSDictionary *)head resoponseStyle:(responseStyle)style success:(void(^)(id result))success fail:(void(^)(NSError *error))fail;

/**
 *  POST请求
 *
 *  @param url       网址
 *  @param body      body
 *  @param bodyStyle body数据类型
 *  @param header      请求头
 *  @param style     返回数据类型
 *  @param success   请求成功
 *  @param fail      请求失败
 */
+ (void)POSTWithURL:(NSString *)url body:(id)body bodyStyle:(bodyStyle)bodyStyle httpHeader:(NSDictionary *)header responseStyle:(responseStyle)style success:(void (^)(id result))success fail:(void (^)(NSError *error))fail;

+ (void)PUTWithURLStr:(NSString *)url bodyDic:(NSDictionary *)body bodyStyle:(bodyStyle)bodyStyle headerDic:(NSDictionary *)header responseStyle:(responseStyle)style finish:(void(^)(id responseObject))finish enError:(void(^)(NSError *error))enError;
// DELETE 删除
//+ (void)requestDELETEWithURLStr:(NSString *)urlStr paramDic:(NSDictionary *)paramDic Api_key:(NSString *)api_key finish:(void(^)(id responseObject))finish enError:(void(^)(NSError *error))enError;

+ (void)DELETEWithURLStr:(NSString *)url bodyDic:(NSDictionary *)body bodyStyle:(bodyStyle)bodyStyle headerDic:(NSDictionary *)header responseStyle:(responseStyle)style finish:(void(^)(id responseObject))finish enError:(void(^)(NSError *error))enError;

@end
