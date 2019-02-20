//
//  TalkBackControl.m
//  XMEye
//
//  Created by XM on 2017/6/6.
//  Copyright © 2017年 Megatron. All rights reserved.
//

#import "TalkBackControl.h"

@implementation TalkBackControl


- (void)startTalk{
    if (_audioRecode == nil) {
        _audioRecode = [[Recode alloc] init];
    }
    [_audioRecode startRecode:self.deviceMac];
    //先停止音频
    FUN_MediaSetSound(_handle, 0, 0);
    if (_hTalk == 0) {
//        FUN_DevStarTalk(self.msgHandle, [self.deviceMac UTF8String]);
       _hTalk = FUN_DevStarTalk(self.msgHandle, [self.deviceMac UTF8String], FALSE, 0, 0);
    }
    const char *str = "{\"Name\":\"OPTalk\",\"OPTalk\":{\"Action\":\"PauseUpload\"},\"SessionID\":\"0x00000002\"}";
    FUN_DevCmdGeneral(self.msgHandle, [self.deviceMac UTF8String], 1430, "PauseUpload", 0, 0, (char*)str, 0, -1, 0);
    FUN_MediaSetSound(_hTalk, 0, 0);
}
- (void)stopTalk{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (_audioRecode != nil) {
            [_audioRecode stopRecode];
            _audioRecode = nil;
        }
        const char *str = "{\"Name\":\"OPTalk\",\"OPTalk\":{\"Action\":\"ResumeUpload\"},\"SessionID\":\"0x00000002\"}";
        FUN_DevCmdGeneral(self.msgHandle, [self.deviceMac UTF8String], 1430, "ResumeUpload", 0, 0, (char*)str, 0, -1, 0);
        FUN_MediaSetSound(_hTalk, 100, 0);
    });
}
//停止预览->停止对讲
-(void)closeTalk{
    if (_hTalk != 0) {
        if (_audioRecode != nil) {
            [_audioRecode stopRecode];
            _audioRecode = nil;
        }
        if (_hTalk != 0) {
            FUN_DevStopTalk(_hTalk);
            _hTalk = 0;
        }
        FUN_MediaSetSound(_handle, 0, 0);
    }
}

-(void)OnFunSDKResult:(NSNumber *) pParam{
    NSInteger nAddr = [pParam integerValue];
    MsgContent *msg = (MsgContent *)nAddr;
    switch (msg->id) {
        case EMSG_DEV_START_TALK: {//对讲失败
            if(_hTalk != 0 && msg->param1 != EE_OK){
                [MessageUI ShowErrorInt:msg->param1];
                _hTalk = 0;
            }else{
                
            }
        }
            break;
        case EMSG_DEV_STOP_TALK: {
            
        }
            break;
        default:
            break;
    }
}
- (BOOL)isSupportTalk{
    //鱼眼灯泡不支持对讲 其他都支持 所以先直接返回ture 后期修改语言灯泡对讲
    return YES;
}
@end
