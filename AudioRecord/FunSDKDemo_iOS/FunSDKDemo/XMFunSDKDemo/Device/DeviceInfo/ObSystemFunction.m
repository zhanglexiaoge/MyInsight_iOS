//
//  ObSystemFunction.m
//  FunSDKDemo
//
//  Created by XM on 2018/5/11.
//  Copyright © 2018年 XM. All rights reserved.
//

#import "ObSystemFunction.h"

@implementation ObSystemFunction

- (instancetype)init {
    self = [super init];
    if (self) {
        _deviceMac = @"";
        _channelNumber = 0;
        _NewVideoAnalyze = NO;
        _SupportIntelligentPlayBack = NO;
        _SupportSetDigIP = NO;
        _IPConsumer433Alarm = NO;
        _SupportSmartH264 = NO;
    }
    return self;
}
@end
