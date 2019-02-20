//
//  ChannelObject.m
//  FunSDKDemo
//
//  Created by XM on 2018/5/10.
//  Copyright © 2018年 XM. All rights reserved.
//

#import "ChannelObject.h"

@implementation ChannelObject

- (instancetype)init {
    self = [super init];
    if (self) {
        _deviceMac = @"";
        _channelName = @"";
        _loginName = @"admin";
        _loginPsw = @"";
        _channelNumber = 0;
    }
    return self;
}
@end
