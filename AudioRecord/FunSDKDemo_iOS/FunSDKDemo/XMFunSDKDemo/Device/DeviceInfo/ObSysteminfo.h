//
//  ObSysteminfo.h
//  FunSDKDemo
//
//  Created by XM on 2018/5/11.
//  Copyright © 2018年 XM. All rights reserved.
//
/***
 
设备信息类
 
 *****/
typedef enum NetTypeModel {
    
    NetTypeNone = -1,
    NetTypeP2P_Mode = 0,//P2P
    NetTypeTransmit_Mode,//转发
    NetTypeIP_Mode,//IP
    NetTypeRPS_Mode = 5, //RPS
    NetTypeRTS_P2P,
    NetTypeRTS_Proxy,
    NetTypeP2P_V2,
    NetTypeProxy_V2,
    
}NetTypeModel;

#import "ObjectCoder.h"

@interface ObSysteminfo : ObjectCoder

@property (nonatomic, copy) NSString *deviceMac;
@property (nonatomic) int channelNumber;

@property (nonatomic, assign) int  type;                    //设备类型
@property (nonatomic, assign) int eFunDevState;              //其他设备状态 EFunDevState 0 未知 1 唤醒 2 睡眠 3 不能被唤醒的休眠 4正在准备休眠

@property (nonatomic, copy) NSString *SerialNo;
@property (nonatomic, copy) NSString *buildTime;
@property (nonatomic, copy) NSString *softWareVersion;
@property (nonatomic, copy) NSString *hardWare;
@property (nonatomic) enum NetTypeModel netType;
@property (nonatomic) int  nVideoInChanNum;      //模拟通道数量，超过的都是数字通道
@end
