//
//  SDKInitializeModel.h
//  MobileVideo
//
//  Created by XM on 2018/4/23.
//  Copyright © 2018年 XM. All rights reserved.
//
/***
 SDK初始化类，这几个文件是调用大部分sdk接口所必须要使用或者继承之后使用的父类
 SDKInitializeModel  初始化FunSDK的类文件
 *****/
#import <Foundation/Foundation.h>

@interface SDKInitializeModel : NSObject

//SDK初始化
+ (void)SDKInit;
@end
