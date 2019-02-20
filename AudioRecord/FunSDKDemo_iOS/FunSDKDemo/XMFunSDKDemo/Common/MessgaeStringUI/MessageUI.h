//
//  MessageUI.h
//  FunSDKDemo
//
//  Created by XM on 2018/11/9.
//  Copyright © 2018年 XM. All rights reserved.
//
/****
 *
 *错误提示显示模块 这个模块主要用来提示SDK返回的错误警告
 *
 *
 *///


#import <Foundation/Foundation.h>

@interface MessageUI : NSObject

//显示传递的错误信息
+(void)ShowError:(NSString *) str;
//显示传递的错误信息和标题
+(void)ShowError:(NSString *) str title:(NSString *)title;

//格局传递的错误int值显示错误信息
+(void)ShowErrorInt:(int) errorno;
//根据传入的错误值和标题显示错误信息
+(void)ShowErrorInt:(int) errorno  title:(NSString *)title;
@end
