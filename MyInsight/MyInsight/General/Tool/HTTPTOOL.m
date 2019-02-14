//
//  HTTPTOOL.m
//  GOpenSource_AppKit
//
//  Created by SongMenglong on 2017/11/2.
//  Copyright © 2017年 Gizwits. All rights reserved.
//

#import "HTTPTOOL.h"

@implementation HTTPTOOL

#pragma mark - GET请求
+ (void)GETWithURL:(NSString *)url body:(NSDictionary *)body httpHead:(NSDictionary *)head resoponseStyle:(responseStyle)style success:(void(^)(id result))success fail:(void(^)(NSError *error))fail {
    /* 判断网络状态 */
    //AFNetworkReachabilityManager *netWorkManager = [AFNetworkReachabilityManager sharedManager];
    
    //[[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    /* 创建一个网络请求管理者 */
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    /* 添加请求头 */
    if (head) {
        for (NSString *key in head) {
            [manager.requestSerializer setValue:head[key] forHTTPHeaderField:key];
        }
    }
    
    switch (style) {
        case DATA:
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            break;
        case JSON:
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
            break;
        case XML:
            manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
            break;
        default:
            break;
    }
    /* 设置请求接受的数据类型 */
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil]];
    
    //创建缓存路径~
    //NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    
    //NSString *path = [NSString stringWithFormat:@"%@/%lu.xml",docPath,[url hash]];
    
    /* GET 请求 */
    [manager GET:url parameters:body progress:^(NSProgress * _Nonnull downloadProgress) {
        NSLog(@"GET请求缓存一下");
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //[netWorkManager stopMonitoring];
        success(responseObject);
        
        //NSData *data = task.responseData;
        //缓存到本地
        //[data writeToFile:path atomically:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        fail(error);
        
        //        if (netWorkManager.reachable == NO) {
        //            NSData *data = [NSData dataWithContentsOfFile:path];
        //            if (data) {
        //
        //                success([NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil]);
        //            }
        //        }
    }];
    //[netWorkManager stopMonitoring];
}

#pragma mark - POST请求
+ (void)POSTWithURL:(NSString *)url body:(id)body bodyStyle:(bodyStyle)bodyStyle httpHeader:(NSDictionary *)header responseStyle:(responseStyle)style success:(void (^)(id result))success fail:(void (^)(NSError *error))fail {
    /* 判断网络状态 */
    //AFNetworkReachabilityManager *netWorkManager = [AFNetworkReachabilityManager sharedManager];
    
    //[[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    /* 创建一个HTTP 请求管理者 */
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    /* 处理body 类型 */
    switch (bodyStyle) {
        case JSONStyle:
            manager.requestSerializer = [AFJSONRequestSerializer serializer];
            break;
        case stringStyle:
            [manager.requestSerializer setQueryStringSerializationWithBlock:^NSString *(NSURLRequest *request, id parameters, NSError **error) {
                return parameters;
            }];
            break;
            
        default:
            break;
    }
    
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil]];
    
    /* 添加请求头 */
    if (header) {
        for (NSString *key in header) {
            //[manager.requestSerializer setValue:head[key] forKey:key];
            [manager.requestSerializer setValue:header[key] forHTTPHeaderField:key];
        }
    }
    /* 判断整体返回值类型 */
    switch (style) {
        case DATA:
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            break;
        case JSON:
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
            break;
        case XML:
            manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
            break;
        default:
            break;
    }
    
    //NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    
    //NSString *path = [NSString stringWithFormat:@"%@/%lu.xml",docPath,[url hash]];
    
    /* 发送post请求 */
    [manager POST:url parameters:body progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //[netWorkManager stopMonitoring];
        if (success) {
            success(responseObject);
            
            //NSData *data = operation.responseData;
            //[data writeToFile:path atomically:YES];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (fail) {
            fail(error);
            
            //            if (netWorkManager.reachable == NO) {
            //                NSData *data = [NSData dataWithContentsOfFile:path];
            //                if (data) {
            //
            //                    success([NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil]);
            //                }
            //            }
        }
    }];
    
    //[netWorkManager stopMonitoring];
}

#pragma mark - PUT 上传
+ (void)PUTWithURLStr:(NSString *)url bodyDic:(NSDictionary *)body bodyStyle:(bodyStyle)bodyStyle headerDic:(NSDictionary *)header responseStyle:(responseStyle)style finish:(void(^)(id responseObject))finish enError:(void(^)(NSError *error))enError {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    /* 处理body 类型 */
    switch (bodyStyle) {
        case JSONStyle:
            manager.requestSerializer = [AFJSONRequestSerializer serializer];
            break;
        case stringStyle:
            [manager.requestSerializer setQueryStringSerializationWithBlock:^NSString *(NSURLRequest *request, id parameters, NSError **error) {
                return parameters;
            }];
            break;
        default:
            break;
    }
    
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil]];
    
    NSLog(@"lalalalal :%@", manager.responseSerializer.acceptableContentTypes);
    
    /* 添加请求头 */
    if (header) {
        for (NSString *key in header) {
            [manager.requestSerializer setValue:header[key] forHTTPHeaderField:key];
        }
    }
    
    /* 判断整体返回值类型 */
    switch (style) {
        case DATA:
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            break;
        case JSON:
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
            break;
        case XML:
            manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
            break;
        default:
            break;
    }
    //
    [manager PUT:url parameters:body success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        finish(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        enError(error);
    }];
}

#pragma mark - DELETE 删除
+ (void)DELETEWithURLStr:(NSString *)url bodyDic:(NSDictionary *)body bodyStyle:(bodyStyle)bodyStyle headerDic:(NSDictionary *)header responseStyle:(responseStyle)style finish:(void(^)(id responseObject))finish enError:(void(^)(NSError *error))enError {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    /* 处理body 类型 */
    switch (bodyStyle) {
        case JSONStyle:
            manager.requestSerializer = [AFJSONRequestSerializer serializer];
            break;
        case stringStyle:
            [manager.requestSerializer setQueryStringSerializationWithBlock:^NSString *(NSURLRequest *request, id parameters, NSError **error) {
                return parameters;
            }];
            break;
        default:
            break;
    }
    
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil]];
    
    NSLog(@"lalalalal :%@", manager.responseSerializer.acceptableContentTypes);
    
    /* 添加请求头 */
    if (header) {
        for (NSString *key in header) {
            [manager.requestSerializer setValue:header[key] forHTTPHeaderField:key];
        }
    }
    
    /* 判断整体返回值类型 */
    switch (style) {
        case DATA:
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            break;
        case JSON:
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
            break;
        case XML:
            manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
            break;
        default:
            break;
    }
    
    // 发送请求
    [manager DELETE:url
         parameters:body success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             finish(responseObject);
         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             enError(error);
         }];
    
}

#pragma mark  上传图片
/**
 上传图片
 
 @param URLString URL
 @param content 弹框的内容
 @param parameters 参数体
 @param uploadDatas 上传图片NSData
 @param completeSuccess 成功回调
 @param completeFailure 失败回调
 */
+ (void)uploadFeedbackImageWithURLString:(NSString *)URLString content:(NSString *)content parameters:(id)parameters uploadDatas:(NSData *)uploadImageData completeSuccess:(void (^)(NSDictionary *respinseDic, id responseObject))completeSuccess completeFailure:(void (^)())completeFailure{
    NSString *tips = nil;
    // 展示等待框
    //    if ([Public isNum:content]) {
    //        tips = LOAD_STRING(@"net_wait");
    //    }else {
    //        tips = content;
    //    }
    
    // 弹框
    //[ECGCustomAlertView showWaitPopViewWithContent:tips];
    
    // 请求的url转码
    URLString = [URLString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    // 初始化网络请求管理
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 设置接受类型
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json", @"text/html",nil];
    
    // 设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = 20.f;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    __weak typeof(self) weakSelf = self;
    [manager POST:URLString parameters:parameters constructingBodyWithBlock:^(id< AFMultipartFormData >  _Nonnull formData) {
        
        NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
        formatter.dateFormat=@"yyyyMMddHHmmss";
        NSString *str=[formatter stringFromDate:[NSDate date]];
        NSString *fileName=[NSString stringWithFormat:@"%@.jpg",str];
        
        //[formData appendPartWithFileData:uploadImageData name:@"content_pic" fileName:fileName mimeType:ECGBJKeyJPEG];
        [formData appendPartWithFileData:uploadImageData name:@"content_pic" fileName:fileName mimeType:[NSString stringWithFormat:@"%@", kUTTypeJPEG]];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        // 转换responseObject对象
        NSDictionary *dict = nil;
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            dict = (NSDictionary *)responseObject;
        } else {
            dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        }
        
        // 成功后弹框处理，回调出去
        //        [weakSelf notDismissedWith:dict responseObject:responseObject complete:^(NSDictionary *respinseDic, id responseObject) {
        //            completeSuccess(respinseDic,responseObject);
        //        } failedComplete:^{
        //            completeFailure();
        //        }];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        // 网络问题，弹框处理
        //        [weakSelf notNetconnetNotDismissComplete:^{
        //            completeFailure();
        //        }];
    }];
    
}


/*
 [ios 上传图片file文件格式](https://www.jianshu.com/p/7c51ad62dbc6)
 */


@end
