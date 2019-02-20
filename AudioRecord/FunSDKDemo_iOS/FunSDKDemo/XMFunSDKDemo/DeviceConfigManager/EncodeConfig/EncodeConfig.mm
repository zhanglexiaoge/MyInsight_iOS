//
//  EncodeConfig.m
//  FunSDKDemo
//
//  Created by XM on 2018/10/24.
//  Copyright © 2018年 XM. All rights reserved.
//
/***
 *
 * 设备编码配置
 * Simplify_Encode 编码配置
 * EncodeCapability  编码配置能力级
 * General_Location  通用配置
 *
 *****/
#import "EncodeConfig.h"
#import "Simplify_Encode.h"
#import "NetUse_DigitalEncode.h"
#import "EncodeCapability.h"
#import "NetUse_DigitalAbility.h"
#import "General_Location.h"
#import "EncodeDataSourse.h"

#import "CommonConfig.h"

@interface EncodeConfig () {
    
    JObjArray<Simplify_Encode> encodeCfgs;        //模拟通道编码配置
    JObjArray<NetUse_DigitalEncode> digitalEncodeCfgs;      //数字通道编码配置
    EncodeCapability encAblity;       //编码配置能力级对象
    NetUse_DigitalAbility digitalAblity;        //数字通道编码能力级
    int digitalEncode;     //是否是数字通道，如果是数字通道，digitalEncode = -1
    EncodeDataSourse *dataSourse;    //编码配置常量数据保存对象
    
    CommonConfig *comConfig;//设备本地化配置，这里要用到其中的视频制式参数来配置视频编码。这个配置因为多处用到，所以专门放在一个common类中
}
@end
@implementation EncodeConfig

#pragma  mark 判断编码配置是否可用
- (BOOL)checkEncode {
    if (digitalEncodeCfgs.Size() >0 || encodeCfgs.Size() >0) {
        return YES;
    }
    return NO;
}
#pragma  mark 判断编码能力级是否可用
- (BOOL)checkEncodeAbility {
    //判断数字通道或者模拟通道是否有效
    if ([self checkMoniEncodeAbility] || [self checkDigitalEncodeAbilit]) {
        return YES;
    }
    return NO;
}
- (BOOL)checkMoniEncodeAbility { //数字通道是否有效
    if (encAblity.ImageSizePerChannel.Size() >0 ||encAblity.MaxEncodePowerPerChannel.Size() || encAblity.EncodeInfo.Size() >0) {
        return YES;
    }
    return NO;
}
- (BOOL)checkDigitalEncodeAbilit { //模拟通道是否有效
    if ( digitalAblity.mability.MaxEncodePowerPerChannel.Size() || digitalAblity.mability.EncodeInfo.Size() >0 || digitalAblity.mability.ImageSizePerChannel.Size() >0) {
        return YES;
    }
    return NO;
}

#pragma mark - 获取编码配置
- (void)getEncodeConfig {
    //初始化编码常量数据对象
    dataSourse = [[EncodeDataSourse alloc] init];
    
    //获取通道
    ChannelObject *channel = [[DeviceControl getInstance] getSelectChannel];
    
    //先判断当前配置是模拟通道还是数字通道
    DeviceObject *device = [[DeviceControl getInstance] GetDeviceObjectBySN:channel.deviceMac];
    //选中通道号>模拟通道数   此通道为数字通道。数字通道配置时，需要减去前面的模拟通道数量
    NSInteger digChannel = channel.channelNumber-device.info.nVideoInChanNum;
    if (channel.channelNumber>(device.info.nVideoInChanNum-1)) {
        //设置方法名
        digitalEncodeCfgs.SetName(JK_NetUse_DigitalEncode);
        //把将要请求的接口数据添加进底层管理器
        [self AddConfig:[CfgParam initWithName:channel.deviceMac andConfig:&digitalEncodeCfgs andChannel:digChannel andCfgType:CFG_GET_SET]];
        digitalEncode = -1;
    }else{
        //模拟通道编码配置
        encodeCfgs.SetName(JK_Simplify_Encode);
        [self AddConfig:[CfgParam initWithName:channel.deviceMac andConfig:&encodeCfgs andChannel:-1 andCfgType:CFG_GET_SET]];
        digitalEncode = channel.channelNumber;
    }
    //编码配置能力级
    if (digitalEncode == -1) { //数字通道
        [self AddConfig:[CfgParam initWithName:channel.deviceMac andConfig:&digitalAblity andChannel:digChannel andCfgType:CFG_GET]];
    }else { //模拟通道
        [self AddConfig:[CfgParam initWithName:channel.deviceMac andConfig:&encAblity andChannel:-1 andCfgType:CFG_GET]];
    }
    //调用获取配置的命令
    [self GetConfig];
    
    //通用配置，需要用到其中的视频制式参数
    comConfig = [[CommonConfig alloc] init];
    [comConfig getGeneralLocationConfig];
}
#pragma  mark 获编码配置回调
-(void)OnGetConfig:(CfgParam *)param{
    if ([param.name isEqualToString:NSSTR(encAblity.Name())]) {
        //能力级
        if (encAblity.ImageSizePerChannel.Size() >0) {
            int cm = encAblity.ImageSizePerChannel[0].Value();
            NSLog(@"ImageSizePerChannel = %d",cm);
        }
    }
    if ([param.name isEqualToString:NSSTR(digitalAblity.Name())]) {
        //能力级
        if (digitalAblity.mability.ImageSizePerChannel.Size() >0) {
            int cm = digitalAblity.mability.ImageSizePerChannel[0].Value();
            NSLog(@"ImageSizePerChannel = %d",cm);
        }
    }
    if ([param.name isEqualToString:NSSTR(JK_Simplify_Encode)]) {
        //模拟通道编码配置
        if ([self.delegate respondsToSelector:@selector(getEncodeConfigResult:)]) {
            [self.delegate getEncodeConfigResult:param.errorCode];
        }
    }
    if ([param.name isEqualToString:NSSTR(JK_NetUse_DigitalEncode)]) {
        //数字通道编码配置
        if ([self.delegate respondsToSelector:@selector(getEncodeConfigResult:)]) {
            [self.delegate getEncodeConfigResult:param.errorCode];
        }
    }
}

#pragma mark - 保存编码配置
- (void)setEncodeConfig {
    [self SetConfig];
}
#pragma mark  保存编码配置回调
-(void)OnSetConfig:(CfgParam *)param{
    if ([param.name isEqualToString:NSSTR(encodeCfgs.Name())] || [param.name isEqualToString:NSSTR(digitalEncodeCfgs.Name())]) {
        if ([self.delegate respondsToSelector:@selector(setEncodeConfigResult:)]) {
            [self.delegate setEncodeConfigResult:param.errorCode];
        }
    }
}

#pragma mark - 读取各项配置的属性值
- (NSString*)getMainResolution { //取出主码流分辨率
    if (digitalEncode == -1) {//数字通道
        return NSSTR(digitalEncodeCfgs[0].mMainFormat.mVideo.Resolution.Value());
    }else{//模拟通道
        return NSSTR(encodeCfgs[digitalEncode].mMainFormat.mVideo.Resolution.Value());
    }
}
- (NSString*)getExtraResolution { //取出辅码流分辨率
    if (digitalEncode == -1) {//数字通道
        return NSSTR(digitalEncodeCfgs[0].mExtraFormat.mVideo.Resolution.Value());
    }else{//模拟通道
        return NSSTR(encodeCfgs[digitalEncode].mExtraFormat.mVideo.Resolution.Value());
    }
}
- (NSInteger)getMainFPS {//取出主码流帧率
    if (digitalEncode == -1) {//数字通道
        return digitalEncodeCfgs[0].mMainFormat.mVideo.FPS.Value();
    }else{//模拟通道
        return encodeCfgs[digitalEncode].mMainFormat.mVideo.FPS.Value();
    }
}
- (NSInteger)getExtraFPS {//取出辅码流帧率
    if (digitalEncode == -1) {//数字通道
        return digitalEncodeCfgs[0].mExtraFormat.mVideo.FPS.Value();
    }else{//模拟通道
        return encodeCfgs[digitalEncode].mExtraFormat.mVideo.FPS.Value();
    }
}
- (NSString*)getMainQuality {//取出主码流画质
    if (digitalEncode == -1) {//数字通道
        int quality = digitalEncodeCfgs[0].mMainFormat.mVideo.Quality.Value();
        //因为quality范围是1-7，数组范围是0-6，所以需要减1
        return  [dataSourse getQualityString:quality];
    }else{//模拟通道
        int quality = encodeCfgs[digitalEncode].mMainFormat.mVideo.Quality.Value();
        return  [dataSourse getQualityString:quality];
    }
}
- (NSString*)getExtraQuality {//取出辅码流画质
    if (digitalEncode == -1) {//数字通道
        int quality = digitalEncodeCfgs[0].mExtraFormat.mVideo.Quality.Value();
        return [dataSourse getQualityString:quality];
    }else{//模拟通道
        int quality = encodeCfgs[digitalEncode].mExtraFormat.mVideo.Quality.Value();
        return  [dataSourse getQualityString:quality];
    }
}

- (NSString*)getMainAudioEnable {//取出主码流音频开关状态
    if (digitalEncode == -1) {//数字通道
        BOOL enable =  digitalEncodeCfgs[0].mMainFormat.AudioEnable.Value();
        return [dataSourse getEnableString:enable];
    }else{//模拟通道
        BOOL enable = encodeCfgs[digitalEncode].mMainFormat.AudioEnable.Value();
        return [dataSourse getEnableString:enable];
    }
}
- (NSString*)getExtraAudioEnable {//取出辅码流音频开关状态
    if (digitalEncode == -1) {//数字通道
         BOOL enable = digitalEncodeCfgs[0].mExtraFormat.AudioEnable.Value();
        return [dataSourse getEnableString:enable];
    }else{//模拟通道
        BOOL enable =  encodeCfgs[digitalEncode].mExtraFormat.AudioEnable.Value();
         return [dataSourse getEnableString:enable];
    }
}

- (NSString *)getMainCompressionEnable {//取出注码流视频编码格式
    if (digitalEncode == -1) {//数字通道
        return NSSTR(digitalEncodeCfgs[0].mMainFormat.mVideo.Compression.Value());
    }else{//模拟通道
        return NSSTR(encodeCfgs[digitalEncode].mMainFormat.mVideo.Compression.Value());
    }
}

-(NSString*)getExtraVideoEnable {//取出辅码流视频开关
    if (digitalEncode == -1) {//数字通道
        BOOL enable = digitalEncodeCfgs[0].mExtraFormat.VideoEnable.Value();
        return [dataSourse getEnableString:enable];
    }else{//模拟通道
        BOOL enable =  encodeCfgs[digitalEncode].mExtraFormat.VideoEnable.Value();
         return [dataSourse getEnableString:enable];
    }
}

#pragma mark - 设置各项配置的属性值
- (void)setMainResolution:(NSString*)Resolution {//设置主码流分辨率
    if (digitalEncode == -1) {//数字通道
        digitalEncodeCfgs[0].mMainFormat.mVideo.Resolution =  SZSTR(Resolution);
    }else{//模拟通道
        encodeCfgs[digitalEncode].mMainFormat.mVideo.Resolution =  SZSTR(Resolution);
    }
}
- (void)setExtraResolution:(NSString*)Resolution { //设置辅码流分辨率
    if (digitalEncode == -1) {//数字通道
        digitalEncodeCfgs[0].mExtraFormat.mVideo.Resolution =  SZSTR(Resolution);
    }else{//模拟通道
        encodeCfgs[digitalEncode].mExtraFormat.mVideo.Resolution =  SZSTR(Resolution);
    }
}
- (void)setMainFPS:(NSInteger)Fps {//设置主码流帧率
    if (digitalEncode == -1) {//数字通道
        digitalEncodeCfgs[0].mMainFormat.mVideo.FPS =  (int)Fps;
    }else{//模拟通道
        encodeCfgs[digitalEncode].mMainFormat.mVideo.FPS =  (int)Fps;
    }
}
- (void)setExtraFPS:(NSInteger)Fps {//设置辅码流帧率
    if (digitalEncode == -1) {//数字通道
        digitalEncodeCfgs[0].mExtraFormat.mVideo.FPS =  (int)Fps;
    }else{//模拟通道
        encodeCfgs[digitalEncode].mExtraFormat.mVideo.FPS =  (int)Fps;
    }
}

- (void)setMainQuality:(NSString*)Quality {//设置主码流画质
    //因为quality范围是1-7，数组范围是0-6，所以需要+1
    int quality = (int)[dataSourse getQualityInt:Quality];
    if (digitalEncode == -1) {//数字通道
        digitalEncodeCfgs[0].mMainFormat.mVideo.Quality =  quality;
    }else{//模拟通道
        encodeCfgs[0].mMainFormat.mVideo.Quality =  quality;
    }
}
- (void)setExtraQuality:(NSString*)Quality {//设置辅码流画质
     int quality = (int)[dataSourse getQualityInt:Quality];
    if (digitalEncode == -1) {//数字通道
        digitalEncodeCfgs[0].mExtraFormat.mVideo.Quality =  quality;
    }else{//模拟通道
        encodeCfgs[0].mExtraFormat.mVideo.Quality =  quality;
    }
}

- (void)setMainAudioEnable:(NSString*)AudioEnable {//设置主码流音频开关状态
    BOOL enable = [dataSourse getEnableBool:AudioEnable];
    if (digitalEncode == -1) {//数字通道
        digitalEncodeCfgs[0].mMainFormat.AudioEnable = enable;
    }else{//模拟通道
        encodeCfgs[digitalEncode].mMainFormat.AudioEnable =  AudioEnable;
    }
}
- (void)setExtraAudioEnable:(NSString*)AudioEnable {//设置辅码流音频开关状态
    BOOL enable = [dataSourse getEnableBool:AudioEnable];
    if (digitalEncode == -1) {//数字通道
        digitalEncodeCfgs[0].mExtraFormat.AudioEnable = enable;
    }else{//模拟通道
        encodeCfgs[digitalEncode].mExtraFormat.AudioEnable =  enable;
    }
}

- (void)setMainCompression:(NSString*)Compression {
    //设置主码流视频编码格式 （需要通过其他能力级获取支持的格式，这里暂时没有支持）
    if (digitalEncode == -1) {//数字通道
        digitalEncodeCfgs[0].mMainFormat.mVideo.Compression =  SZSTR(Compression);
    }else{//模拟通道
        encodeCfgs[digitalEncode].mMainFormat.mVideo.Compression =  SZSTR(Compression);
    }
}

-(void)setExtraVideoEnable:(NSString*)VideoEnable {//设置辅码流视频开关
    BOOL enable = [dataSourse getEnableBool:VideoEnable];
    if (digitalEncode == -1) {//数字通道
        digitalEncodeCfgs[0].mExtraFormat.VideoEnable = enable;
    }else{//模拟通道
        encodeCfgs[digitalEncode].mExtraFormat.VideoEnable =  enable;
    }
}

#pragma mark - 获取各种配置的设置范围（需要根据能力级动态计算）
-(NSMutableArray*)getMainResolutionArray { //获取主码流分辨率的设置范围
    //1、获取总能力级
    long maxSize = [self getMaxImageSize];
    //2、获取辅码流已经使用的能力级
    long extraSize = [self getExtraImageSize];
    //3、获取主码流目前可用能力级
    long size = maxSize - extraSize;
    //4、获取主码流支持的分辨率
    NSInteger supportMark = [self GetMainResolutionMark];
    //5、根据支持的分辨率和当前可用能力级计算设置范围
    NSInteger resolutionMark = [dataSourse getResolutionMark:size rate:[self getMainFPS] range:supportMark];
    //6、根据当前可用的分辨率二进制来获取分辨率名称字符串
    NSMutableArray *array = [dataSourse getResolutionArrayWithMark:resolutionMark];
    return array;
}
-(NSMutableArray*)getExtraResolutionArray { //获取辅码流分辨率的设置范围
    //1、获取总能力级
    long maxSize = [self getMaxImageSize];
    //2、获取主码流已经使用的能力级
    long extraSize = [self getMainImageSize];
    //3、获取辅码流目前可用能力级
    long size = maxSize = extraSize;
    //4、获取辅码流支持的分辨率
    NSInteger supportMark = [self GetExtraResolutionMark];
    //5、根据支持的分辨率和可用能力级计算设置范围
    NSInteger resolutionMark = [dataSourse getResolutionMark:size rate:[self getMainFPS] range:supportMark];
    //6、根据当前可用的分辨率二进制来获取分辨率名称字符串 （辅码流分辨率必须比当前主码流低）
    NSMutableArray *array = [dataSourse getResolutionArrayWithMark:resolutionMark];
    return array;
}

-(NSMutableArray*)getMainFpsArray { //获取主码流帧率的设置范围
    //1、获取总能力级
    long maxSize = [self getMaxImageSize];
    //2、获取辅码流已经使用的能力级
     long extraSize = [self getExtraImageSize];
    //3、获取主码流目前可用能力级
    long size = maxSize - extraSize;
    //4、获取当前主码流分辨率字符串
    NSString *resolution = [self getMainResolution];
    //5、获取当前主码流索引，用于获取分辨率数值
    long index = [dataSourse getResolutionIndex:resolution];
    //6、判断当前是PAL还是NSTC（两种制式部分分辨率不同)
     NSInteger fps,imageSize;
    if ([self isNSTC]) { //NSTC最高支持30帧
        fps = 30;
        imageSize = [dataSourse getResolutionSizeNSTC:index];
    }else{
        fps = 25;
        imageSize = [dataSourse getResolutionSize:index];
    }
    //7、通过主码流可用能力级以及分辨率计算主码流帧率的范围
    for (; fps>0; fps--) {
        //如果当前的帧率*分辨率小于可用能力级，说明当前帧率是可用的，直接跳出
        if (fps*imageSize < size) {
            break;
        }
    }
    //8、根据可用的最大帧率，组装数组
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i =0 ; i< fps; i++) {
        [array addObject:[NSString stringWithFormat:@"%d",i+1]];//帧率是从1开始，所以要+1
    }
    return array;
}
-(NSMutableArray*)getExtraFpsArray { //获取辅码流帧率的设置范围
    //1、获取总能力级
    long maxSize = [self getMaxImageSize];
    //2、获取主码流已经使用的能力级
    long mainSize = [self getMainImageSize];
    //3、获取辅码流目前可用能力级
    long size = maxSize - mainSize;
    //4、获取当前辅码流分辨率字符串
    NSString *resolution = [self getExtraResolution];
    //5、获取当前辅码流索引，用于获取分辨率数值
    long index = [dataSourse getResolutionIndex:resolution];
    //6、判断当前是PAL还是NSTC（两种制式部分分辨率不同)
    NSInteger fps,imageSize; //声明帧率和分辨率数值
    if ([self isNSTC]) { //NSTC最高支持30帧，其他支持25帧
        fps = 30;
        imageSize = [dataSourse getResolutionSizeNSTC:index];
    }else{
        fps = 25;
        imageSize = [dataSourse getResolutionSize:index];
    }
    //7、通过辅码流可用能力级以及分辨率计算辅码流帧率的范围
    for (; fps>0; fps--) {
        //如果当前的帧率*分辨率小于可用能力级，说明当前帧率是可用的，直接跳出
        if (fps*imageSize < size) {
            break;
        }
    }
    //8、根据可用的最大帧率，组装数组
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i =0 ; i< fps; i++) {
        [array addObject:[NSString stringWithFormat:@"%d",i+1]];
    }
    return array;
}
- (NSMutableArray*)getMainQualityArray {//获取主码流支持的清晰度
    NSMutableArray *qualityArray = [[NSMutableArray alloc] initWithCapacity:0];
    //画质清晰度范围为1-6，一共有6种
    for (int i =1 ; i< 7; i++) {
        NSString *quality = [dataSourse getQualityString:i];
        [qualityArray addObject:quality];
    }
    return qualityArray;
}
- (NSMutableArray*)getExtraQualityArray {//获取辅码流支持的清晰度
    //目前所有的设备主辅码流清晰度范围一致
    return [self getMainQualityArray];
}
- (NSMutableArray*)getEnableArray {//获取码流开关数组
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i =0 ; i< 2; i++) {
        NSString *enable = [dataSourse getEnableString:i];
        [array addObject:enable];
    }
    return array;
}

# pragma mark 获取各种能力级和分辨率
//获取通道总的能力级
-(long)getMaxImageSize {
    if (digitalEncode == -1) {//数字通道
        if (digitalAblity.mability.MaxEncodePowerPerChannel.Size() >0) {
            return digitalAblity.mability.MaxEncodePowerPerChannel[0].Value();
        }
        return 0;
    }else{
        if (encAblity.MaxEncodePowerPerChannel.Size() >digitalEncode) {
            return encAblity.MaxEncodePowerPerChannel[digitalEncode].Value();
        }
        return 0;
    }
}
//获取主码流已经使用的能力级
- (long)getMainImageSize {
    //先获取主码流分辨率数值
     long resolution = [dataSourse getResolutionIndex: [self getMainResolution]];
    long imageSize = [dataSourse getResolutionSize:resolution];
    if (digitalEncode == -1) {//数字通道
        //分辨率*帧率就是已经使用的能力级
        return imageSize * digitalEncodeCfgs[0].mMainFormat.mVideo.FPS.Value();
    }else{
        //分辨率*帧率就是已经使用的能力级
        return imageSize * encodeCfgs[digitalEncode].mMainFormat.mVideo.FPS.Value();
    }
}
//获取辅码流已经使用的能力级
- (long)getExtraImageSize {
    //先获取辅码流当前的分辨率
    long resolution = [dataSourse getResolutionIndex: [self getExtraResolution]];
     long imageSize = [dataSourse getResolutionSize:resolution];
    if (digitalEncode == -1) {//数字通道
        //分辨率*帧率就是已经使用的能力级
        return imageSize * digitalEncodeCfgs[0].mExtraFormat.mVideo.FPS.Value();
    }else{
        //分辨率*帧率就是已经使用的能力级
        return imageSize * encodeCfgs[digitalEncode].mExtraFormat.mVideo.FPS.Value();
    }
}
//获取主码流支持的分辨率
-(unsigned int) GetMainResolutionMark{
    unsigned int nRetMark = 0;
    int tmpChannelNum = digitalEncode;
    if (digitalEncode == -1) {
        //数字通道的能力级只包含对应通道的，需要传递0
        tmpChannelNum = 0;
        if (digitalAblity.mability.ImageSizePerChannel.Size() >tmpChannelNum) {
            nRetMark = digitalAblity.mability.ImageSizePerChannel[tmpChannelNum].Value();
        }
        if (nRetMark == 0) {
            nRetMark = digitalAblity.mability.EncodeInfo[tmpChannelNum].ResolutionMask.Value();
        }
    }else{  // 模拟通道
        if (encAblity.ImageSizePerChannel.Size() >tmpChannelNum) {
            nRetMark = encAblity.ImageSizePerChannel[tmpChannelNum].Value();
        }
        if (nRetMark == 0) {
            nRetMark = encAblity.EncodeInfo[tmpChannelNum].ResolutionMask.Value();
        }
    }
    
    return nRetMark;
}
//获取辅码流支持的分辨率
-(unsigned int) GetExtraResolutionMark{
    unsigned int nResolutionMark = 0;
    ChannelObject *channel = [[DeviceControl getInstance] getSelectChannel];
    int tmpChannelNum = channel.channelNumber;
    if (digitalEncode == -1) {
        //数字通道的能力级只包含对应通道的，需要传递0
        tmpChannelNum = 0;
        if (digitalAblity.mability.ExImageSizePerChannelEx.Size() >tmpChannelNum) {
            //获取主码流索引
            int reIndex = (int)[dataSourse getResolutionIndex: [self getMainResolution]];
            //数字通道的辅码流能力级和主码流分辨率有关
            nResolutionMark = digitalAblity.mability.ExImageSizePerChannelEx[tmpChannelNum][reIndex].Value();
        }
        if (nResolutionMark == 0) {
            //如果上面的方式失败，尝试直接读取 ResolutionMask
            nResolutionMark = digitalAblity.mability.CombEncodeInfo[tmpChannelNum].ResolutionMask.Value();
        }
    }else { //模拟通道
        if (encAblity.ImageSizePerChannel.Size() >tmpChannelNum) {
            nResolutionMark = encAblity.ExImageSizePerChannel[tmpChannelNum].Value();
        }
        if (nResolutionMark == 0) {
            nResolutionMark = encAblity.EncodeInfo[tmpChannelNum].ResolutionMask.Value();
        }
    }
    
    return nResolutionMark;
}
- (BOOL)isNSTC {
    NSString *videoFormat = [comConfig getVideoFormat];
    if (videoFormat != nil && [ videoFormat  isEqualToString:@"NSTC"]) { //NSTC格式帧率最高为30，其他格式帧率最高为25
        return YES;
    }else{
        return NO;
    }
}
#pragma mark - SDK回调  这个是必须的
-(void)OnFunSDKResult:(NSNumber *) pParam{
    [super OnFunSDKResult:pParam];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
