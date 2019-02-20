//
//  ObSysteminfo.m
//  FunSDKDemo
//
//  Created by XM on 2018/5/11.
//  Copyright © 2018年 XM. All rights reserved.
//

#import "ObSysteminfo.h"

@implementation ObSysteminfo
- (instancetype)init {
    self = [super init];
    if (self) {
        _deviceMac = @"";
        _channelNumber = 0;
        _type = -1;
        _eFunDevState = 0;
        _SerialNo = @"";
        _buildTime = @"";
        _softWareVersion = @"";
        _hardWare = @"";
        _netType =NetTypeNone;
    }
    return self;
}
@end
