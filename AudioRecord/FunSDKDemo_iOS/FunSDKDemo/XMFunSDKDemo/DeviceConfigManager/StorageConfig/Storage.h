//
//  Storage.h
//  FunSDKDemo
//
//  Created by XM on 2018/5/19.
//  Copyright © 2018年 XM. All rights reserved.
//

/***
 
 设备存储属性对象
 
 *****/

#import <Foundation/Foundation.h>

@interface Storage : NSObject

//总容量
@property (nonatomic, assign) float totalStorage;
//空闲容量
@property (nonatomic, assign) float freeStorage;
//录像总容量
@property (nonatomic, assign) float videoTotalStorage;
//录像空闲容量
@property (nonatomic, assign) float videoFreeStorage;
//图片总容量
@property (nonatomic, assign) float imgTotalStorage;
//图片剩余容量
@property (nonatomic, assign) float imgFreeStorage;


//普通录像循环录像开关
@property (nonatomic, strong) NSString *overWright;
//原始录像循环录像开关
@property (nonatomic, strong) NSString *keyOverWrite;


@end
