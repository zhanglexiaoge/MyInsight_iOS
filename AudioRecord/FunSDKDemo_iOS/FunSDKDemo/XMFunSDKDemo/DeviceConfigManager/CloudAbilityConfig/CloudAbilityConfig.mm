//
//  CloudAbilityConfig.m
//  FunSDKDemo
//
//  Created by XM on 2018/12/27.
//  Copyright © 2018年 XM. All rights reserved.
//

#import "CloudAbilityConfig.h"
#import "CloudAbilityDataSource.h"
@interface CloudAbilityConfig ()
{
    CloudAbilityDataSource *dataSource;
}
@end

@implementation CloudAbilityConfig
- (id)init {
    self = [super init];
    if (self) {
        dataSource = [[CloudAbilityDataSource alloc] init];
    }
    return self;
}

#pragma mark 请求服务器端云存储能力集
-(void)getCloudAbilityServer{
    //这两个接口调用的也是json
    ChannelObject *channel = [[DeviceControl getInstance] getSelectChannel];
    NSArray *caps = @[@"xmc.service.support",@"xmc.service.enable",@"xmc.service.normal"];
    NSDictionary *jsonDic = @{@"hw":@"",@"sw":@"",@"tp":@0,@"appType":[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"],@"sn":channel.deviceMac,@"caps":caps};
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *pCfgBufString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    Fun_SysGetDevAbilitySetFromServer(self.msgHandle, [pCfgBufString UTF8String], 0);
    
}

#pragma mark - 是否支持云视频或云图片
-(void)getVideoOrPicAbilityServer{
    ChannelObject *channel = [[DeviceControl getInstance] getSelectChannel];
    NSArray *caps = @[@"xmc.css.pic.support",@"xmc.css.vid.support"];
    NSDictionary *jsonDic = @{@"hw":@"",@"sw":@"",@"tp":@0,@"appType":[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"],@"sn":channel.deviceMac,@"caps":caps};
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *pCfgBufString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    Fun_SysGetDevAbilitySetFromServer(self.msgHandle, [pCfgBufString UTF8String], 0);
}

#pragma mark   读取云服务状态
- (NSString*)getCloudState {//获取云存储状态
    return  [dataSource getCloudString];
}
- (NSString*)getVideoEnable{ //获取云视频支持情况
    return  [dataSource getVideoString];
}
- (NSString*)getPicEnable{ //获取云图片支持情况
    return  [dataSource getPicString];
}

-(void)OnFunSDKResult:(NSNumber *)pParam {
    NSInteger nAddr = [pParam integerValue];
    MsgContent *msg = (MsgContent *)nAddr;
    
    switch (msg->id) {
        case EMSG_SYS_GET_ABILITY_SET: {
            if (msg->param1 < 0) {
                if (msg->seq == 0) {
                    dataSource.cloudState = CloudState_UnSupport;
                }
                if ([self.delegate respondsToSelector:@selector(getCloudAbilityResult:)]) {
                    [self.delegate getCloudAbilityResult:msg->param1];
                }
            } else {
                NSString *content = NSSTR(msg->szStr);
                [content stringByReplacingOccurrencesOfString:@"\t" withString:@""];
                [content stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                
                NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *tempDictQueryDiamond = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                
                if ([tempDictQueryDiamond objectForKey:@"xmc.css.pic.support"] || [tempDictQueryDiamond objectForKey:@"xmc.css.vid.support"]) {
                    if ([[tempDictQueryDiamond objectForKey:@"xmc.css.pic.support"] boolValue]) {
                        if ([[tempDictQueryDiamond objectForKey:@"xmc.css.vid.support"] boolValue]) {
                            dataSource.VideoOrPicState = VideoOrPicCloudState_All;
                        }
                        else{
                            dataSource.VideoOrPicState = VideoOrPicCloudState_Pic;
                        }
                    }
                    else{
                        if ([[tempDictQueryDiamond objectForKey:@"xmc.css.vid.support"] boolValue]) {
                            dataSource.VideoOrPicState = VideoOrPicCloudState_Video;
                        }
                        else{
                            dataSource.VideoOrPicState = VideoOrPicCloudStateNone;
                        }
                    }
                    if ([self.delegate respondsToSelector:@selector(getVideoOrPicAbilityResult:)]) {
                        [self.delegate getVideoOrPicAbilityResult:msg->param1];
                    }
                }
                else{
                    dataSource.cloudState = CloudState_UnSupport;
                    if ([[tempDictQueryDiamond objectForKey:@"xmc.service.support"] boolValue] == YES) {
                        if ([[tempDictQueryDiamond objectForKey:@"xmc.service.enable"] boolValue]) {
                            if ([[tempDictQueryDiamond objectForKey:@"xmc.service.support"] boolValue]) {
                                dataSource.cloudState = CloudState_Open;
                            }
                            else{
                                dataSource.cloudState = CloudState_Open_Expired;
                            }
                        }
                        else{
                            dataSource.cloudState = CloudState_NotOpen;
                        }
                    }
                    if ([self.delegate respondsToSelector:@selector(getCloudAbilityResult:)]) {
                        [self.delegate getCloudAbilityResult:msg->param1];
                    }
                }
            }
        }
            break;
        default:
            break;
    }
}

@end
