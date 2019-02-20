//
//  DeviceObject.m
//  XMEye
//
//  Created by XM on 2018/4/13.
//  Copyright © 2018年 Megatron. All rights reserved.
//

#import "DeviceObject.h"

@implementation DeviceObject

- (instancetype)init {
    self = [super init];
    if (self) {
        _deviceMac = @"";
        _deviceName = @"";
        _loginName = @"admin";
        _loginPsw = @"";
        _nPort = 34567;
        _nType = 0;
        _nID = 0;
        _state = -1;
        _channelArray = [[NSMutableArray alloc] initWithCapacity:0];
        _info = [[ObSysteminfo alloc] init];
        _sysFunction = [[ObSystemFunction alloc] init];
    }
    return self;
}
@end
