//
//  TalkBackControl.h
//  XMEye
//
//  Created by XM on 2017/6/6.
//  Copyright © 2017年 Megatron. All rights reserved.
//
/***
 
 视频预览时的对讲功能控制器，继承自 FunMsgListener

 *****/
#import "FunMsgListener.h"
#import "Recode.h"
@interface TalkBackControl : FunMsgListener
{
    Recode *_audioRecode;
    long _hTalk;
}

@property (nonatomic, strong) NSString *deviceMac;
@property (nonatomic) int channel;
@property (nonatomic) long handle;

-(void)startTalk;//开始对讲
//停止预览->停止对讲
-(void)stopTalk;
- (void)closeTalk;//关闭对讲画面
@end
