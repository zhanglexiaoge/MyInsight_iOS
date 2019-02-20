//
//  FunMsgListener.h
//  XWorld
//
//  Created by XM on 16/5/23.
//  Copyright © 2016年 XM. All rights reserved.
//
/***
 SDK初始化类，这几个文件是调用大部分sdk接口所必须要使用或者继承之后使用的父类
 FunMsgListener  最简单的接口使用继承类，继承自这个类之后可以直接调用接口，除了获取msgHandle并不会做其他任何操作
 *****/
#import <Foundation/Foundation.h>
#import "FunSDK/FunSDK.h"

@interface FunMsgListener : NSObject

@property (nonatomic,assign) UI_HANDLE msgHandle;

@end

@protocol FunSDKResultDelegate <NSObject>

@required
-(void)OnFunSDKResult:(NSNumber *)pParam;

@end
