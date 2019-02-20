//
//  WaterMarkConfig.m
//  FunSDKDemo
//
//  Created by wujiangbo on 2018/12/19.
//  Copyright © 2018 wujiangbo. All rights reserved.
//

#import "WaterMarkConfig.h"
#import "fVideo_OsdLogo.h"
#import "AVEnc_VideoWidget.h"
#import <FunSDK/FunSDK.h>

@implementation WaterMarkConfig
{
    fVideo_OsdLogo videoLogo;   //雄迈官方水印  建议关闭
    AVEnc_VideoWidget widgetCfg;//自定义水印
}

#pragma mark - 获取官方logo设置
- (void)getLogoConfig{
    //获取通道
    ChannelObject *channel = [[DeviceControl getInstance] getSelectChannel];
    
    [self AddConfig:[CfgParam initWithName:channel.deviceMac andConfig:&widgetCfg andChannel:0 andCfgType:CFG_GET_SET]];
    [self AddConfig:[CfgParam initWithName:channel.deviceMac andConfig:&videoLogo andChannel:-1 andCfgType:CFG_GET_SET]];
    
    [self GetConfig];
}


#pragma mark - 保存设置
- (void)setWaterMarkConfig{
    //发送保存配置的请求
    [self SetConfig];
}

#pragma mark 获取配置回调信息
-(void)OnGetConfig:(CfgParam *)param {
    if ([param.name isEqualToString:[NSString stringWithUTF8String:videoLogo.Name()]]) {
        if([self.delegate respondsToSelector:@selector(getOsdLogoConfigResult:)]){
            [self.delegate getOsdLogoConfigResult:param.errorCode];
        }
    }
    else if ([param.name isEqualToString:[NSString stringWithUTF8String:widgetCfg.Name()]]){
        if ([self.delegate respondsToSelector:@selector(getLogoWidgetResult:)]) {
            [self.delegate getLogoWidgetResult:param.errorCode];
        }
    }
}

#pragma mark 保存配置回调信息
- (void)OnSetConfig:(CfgParam *)param {
    if ([param.name isEqualToString:[NSString stringWithUTF8String:videoLogo.Name()]]) {
        if ([self.delegate respondsToSelector:@selector(setOsdLogoConfigResult:)]) {
            [self.delegate setOsdLogoConfigResult:param.errorCode];
        }
    }
    else if ([param.name isEqualToString:[NSString stringWithUTF8String:widgetCfg.Name()]]){
       
    }
}

#pragma mark 读取各项配置的属性值
- (int)getLogoEnable {      //自定义水印开关
    return widgetCfg.mChannelTitleAttribute.EncodeBlend.Value();
}

- (NSString *)getLogoTitle{ //自定义水印文字
    return [NSString stringWithUTF8String:widgetCfg.mChannelTitle.Name.Value()];
}

- (int)getOsdLogoEnable{     //获取官方水印开关状态
    return videoLogo.Enable.Value();
}

#pragma - mark 设置各项配置具体的属性值
- (void)setLossEnable:(int)enable {         //设置自定义水印开关
    widgetCfg.mTimeTitleAttribute.EncodeBlend = enable;
    widgetCfg.mTimeTitleAttribute.PreviewBlend = enable;
    widgetCfg.mChannelTitleAttribute.EncodeBlend = enable;
    widgetCfg.mChannelTitleAttribute.PreviewBlend = enable;
}

- (void)setLogoTitle:(NSString *)title{     //设置自定义水印文字
    const char *name = [title UTF8String];
    widgetCfg.mChannelTitle.Name = name;
}

- (void)setOsdLogoEnable:(int)enable{       //设置官方水印开关
    videoLogo.Enable = enable;
}

@end
