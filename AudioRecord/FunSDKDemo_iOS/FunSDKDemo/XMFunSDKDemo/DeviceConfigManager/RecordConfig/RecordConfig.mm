//
//  RecordConfig.m
//  FunSDKDemo
//
//  Created by XM on 2018/11/6.
//  Copyright © 2018年 XM. All rights reserved.
//

#import "RecordConfig.h"
#import "SupportExtRecord.h"
#import "Record.h"
#import "ExtRecord.h"
#import "RecordDataSourse.h"

@interface RecordConfig ()
{
    SupportExtRecord suport; //录像能力级
    Record record;  //主码流录像配置
    ExtRecord exRecord; //辅码流录像配置
    NSInteger suporttype; //录像配置支持情况
    
    RecordDataSourse *dataSourse; //录像配置资源支持对象
}
@end

@implementation RecordConfig
#pragma  mark 判断当前录像配置是否可用
- (BOOL)checkRecord {
    if (suporttype == -1) {
        //如果没有获取能力级，肯定不可用
        return NO;
    }else if (suporttype == 0){
        //只支持主码流
        return [self checkMainRecord];
    }else if (suporttype == 1) {
        //只支持辅码流
         return [self checkExtraRecord];
    }else {
        //主辅码流都要正常才可以配置
        return [self checkMainRecord] && [self checkExtraRecord];
    }
}
- (BOOL)checkMainRecord {
    if (suporttype == -1) {
        return NO;
    }
    //判断数组数据是否正常，防止越界
    if (record.Mask.Size() < 7 || record.Mask[0].Size() < 6 || record.TimeSection.Size() < 7 || record.TimeSection[0].Size()< 6) {
        //数据异常，无法配置
        return NO;
    }
    return YES;
}
-(BOOL)checkExtraRecord {
    if (suporttype == -1) {
        return NO;
    }
    //判断数组数据是否正常，防止越界
    if (exRecord.Mask.Size() < 7 || exRecord.Mask[0].Size() < 6 || exRecord.TimeSection.Size() < 7 || exRecord.TimeSection[0].Size()< 6) {
        //数据异常，无法配置
        return NO;
    }
    return YES;
}

#pragma mark - 获取录像配置。 1、获取是否支持主辅码流录像。2、获取支持的录像配置
-(void)getRecordConfig {
    //初始化录像资源支持对象
    dataSourse = [[RecordDataSourse alloc] init];
    //获取通道
    ChannelObject *channel = [[DeviceControl getInstance] getSelectChannel];
    //获取当前通道主码流和辅码流是否支持录像配置
     [self AddConfig:[CfgParam initWithName:channel.deviceMac andConfig:&suport andChannel:channel.channelNumber andCfgType:CFG_GET]];
    [self GetConfig];
}
//获取主码流录像配置
- (void)getMainRecordConfig {
    //获取通道
    ChannelObject *channel = [[DeviceControl getInstance] getSelectChannel];
    //获取当前通道主码流和辅码流是否支持录像配置
    [self AddConfig:[CfgParam initWithName:channel.deviceMac andConfig:&record andChannel:channel.channelNumber andCfgType:CFG_GET_SET]];
    [self GetConfig:NSSTR(record.Name())];
}
//获取辅码流录像配置
-(void)getExtraRecordConfig {
    //获取通道
    ChannelObject *channel = [[DeviceControl getInstance] getSelectChannel];
    //获取当前通道主码流和辅码流是否支持录像配置
    [self AddConfig:[CfgParam initWithName:channel.deviceMac andConfig:&exRecord andChannel:channel.channelNumber andCfgType:CFG_GET_SET]];
    [self GetConfig:NSSTR(exRecord.Name())];
}
#pragma  mark - 获编码配置回调
-(void)OnGetConfig:(CfgParam *)param{
    if ([param.name isEqualToString:NSSTR(suport.Name())]) {
        //读取录像能力级
        suporttype = [NSSTR(suport.AbilityPram.Value()) integerValue];
        if (suporttype == 0) {
            //只支持主码流
            [self getMainRecordConfig];
        }else if(suporttype == 1) {
            //只支持辅码流
            [self getExtraRecordConfig];
        }else if (suporttype == 2) {
            //主码流辅码流都支持
            [self getMainRecordConfig];
            [self getExtraRecordConfig];
        }
        //回调给上层界面当前通道的录像配置支持情况
        if ([self.delegate respondsToSelector:@selector(recordSuportStatu:)]) {
            [self.delegate recordSuportStatu:suporttype];
        }
    }
     if ([param.name isEqualToString:NSSTR(record.Name())]) {
        //主码流录像配置
         if ([self.delegate respondsToSelector:@selector(getRecordConfigResult:)]) {
             [self.delegate getRecordConfigResult:param.errorCode];
         }
    }
    if ([param.name isEqualToString:NSSTR(exRecord.Name())]) {
        //辅码流录像配置
        if ([self.delegate respondsToSelector:@selector(getRecordConfigResult:)]) {
            [self.delegate getRecordConfigResult:param.errorCode];
        }
    }
}

#pragma mark - 保存录像配置
- (void)setRecordConfig {
    [self SetConfig];
}
#pragma mark  保存录像配置回调
-(void)OnSetConfig:(CfgParam *)param{
    if ([param.name isEqualToString:NSSTR(record.Name())] || [param.name isEqualToString:NSSTR(exRecord.Name())]) {
        if ([self.delegate respondsToSelector:@selector(setRecordConfigResult:)]) {
            [self.delegate setRecordConfigResult:param.errorCode];
        }
    }
}

#pragma mark - 读取各项配置的属性值
- (NSString*)getMainPreRecord { //读取主码流录像预录时间
    int PreRecord = record.PreRecord.Value();
    return [NSString stringWithFormat:@"%d",PreRecord];
}
- (NSString*)getExtraPreRecord { //读取辅码流录像预录时间
    int PreRecord = exRecord.PreRecord.Value();
    return [NSString stringWithFormat:@"%d",PreRecord];
}

- (NSString*)getMainPacketLength { //读取主码流录像时长
    int PacketLength = record.PacketLength.Value();
    return [NSString stringWithFormat:@"%d",PacketLength];
}
- (NSString*)getExtraPacketLength { //读取辅码流录像时长
    int PacketLength = exRecord.PacketLength.Value();
    return [NSString stringWithFormat:@"%d",PacketLength];
}

- (NSString*)getMainRecordMode { //获取主码流录像打开状态。包括始终录像、报警联动录像、关闭录像
    //正常来说判断录像状态需要RecordMode、Mask、TimeSection时间设置三个加在一起才能判断，不过可以做简化只判断Mask和RecordMode，然后再保存的时候把RecordMode和TimeSection按各种情形设置
    if (![self checkMainRecord]) {
        return TS("");
    }
    int mask = record.Mask[0][0].Value();
    if ([NSSTR(record.RecordMode.Value()) isEqualToString:@"ClosedRecord"]) {
        // ClosedRecord是不录像，强制设置mask为0，也就是不录像
        mask = 0;
    }
    return [dataSourse getRecordModeString:(int)mask];
}
- (NSString*)getExtraRecordMode { //获取辅码流录像打开状态
    if (![self checkExtraRecord]) {
        return TS("");
    }
    int mask = exRecord.Mask[0][0].Value();
    if ([NSSTR(exRecord.RecordMode.Value()) isEqualToString:@"ClosedRecord"]) {
        // ClosedRecord是不录像，强制设置mask为0，也就是不录像
        mask = 0;
    }
    return [dataSourse getRecordModeString:(int)mask];
}


#pragma mark - 设置各项配置的属性值
- (void)setMainPreRecord:(NSString*)perRecord { //读取主码流录像预置时间
    record.PreRecord = [perRecord intValue];
}
- (void)setExtraPreRecord:(NSString*)perRecord { //读取辅码流录像预置时间
    exRecord.PreRecord = [perRecord intValue];
}

- (void)setMainPacketLength:(NSString*)PacketLength { //读取主码流录像时长
    record.PacketLength = [PacketLength intValue];
}
- (void)setExtraPacketLength:(NSString*)PacketLength { //读取辅码流录像时长
    exRecord.PacketLength = [PacketLength intValue];
}

//如果设置报警联动录像，那么设备报警功能需要打开才会录像，否则不会录像
- (void)setMainRecordMode:(NSString*)maskString { //设置主码流录像开关状态
    if (![self checkRecord]) { //数据异常，不能保存
        return;
    }
    //先获取录像状态对应的mask值
    NSInteger mask = [dataSourse getRecordModeMask:maskString];
    if (mask == 0) { //停止录像
        //1、设置RecordMode为停止录像
        record.RecordMode = SZSTR(@"ClosedRecord") ;
    }else{
        //1、设置RecordMode为配置录像(联动录像和一直录像都可以找通过配置实现)
        record.RecordMode = SZSTR(@"ConfigRecord") ;
    }
    //2、设置每一天的mask都为传递进来的值
    for (int i =0; i< record.Mask.Size(); i++) {
        // mask：0停止录像。6报警联动录像。7一直录像
        record.Mask[i][0] = (int)mask;
    }
    //3、设置TimeSection第一段为一整天（这里可以根据需求，一共可以设置6段时间）
    for (int j = 0; j< record.TimeSection.Size(); j++) {
        //第一个1表示这一段有效，后面的是有效时间
        record.TimeSection[j][0] = SZSTR(@"1 00:00:00-24:00:00");
        //如果想自定义录像时间段和录像类型，可以通过设置每一天的6段TimeSection和对应的6段mask实现
    }
}

- (void)setExtraRecordMode:(NSString*)maskString { //设置辅码流录像开关状态
    if (![self checkRecord]) { //数据异常，不能保存
        return;
    }
    NSInteger mask = [dataSourse getRecordModeMask:maskString];
    if (mask == 0) { //停止录像
        //1、设置RecordMode为停止录像
        exRecord.RecordMode = SZSTR(@"ClosedRecord") ;
    }else{
        //1、设置RecordMode为配置录像(联动录像和一直录像都可以找通过配置实现)
        exRecord.RecordMode = SZSTR(@"ConfigRecord") ;
    }
    //2、设置每一天的mask都为传递进来的值
    for (int i =0; i< exRecord.Mask.Size(); i++) {
        // mask：0停止录像。6报警联动录像。7一直录像
        exRecord.Mask[i][0] = (int)mask;
    }
    //3、设置TimeSection第一段为一整天（这里可以根据需求，一共可以设置6段时间）
    for (int j = 0; j< exRecord.TimeSection.Size(); j++) {
        //第一个1表示这一段有效，后面的是有效时间
        exRecord.TimeSection[j][0] = SZSTR(@"1 00:00:00-24:00:00");
        //如果想自定义录像时间段和录像类型，可以通过设置每一天的6段TimeSection和对应的6段mask实现
    }
}

#pragma mark - 获取各种配置的设置范围
- (NSMutableArray *)getMainRecordModeArray { //主码流录像状态数组
    //录像状态有3种，没有录像、报警录像、一直录像
    return [[dataSourse getRecordModeArray] mutableCopy];
}
- (NSMutableArray *)getMainPrerecordArray { //主码流预录时间数组
    
    return [[dataSourse getPreRecordArray] mutableCopy];
}
- (NSMutableArray *)getMainPacketLengthArray { //主码流录像时长数组
    return [[dataSourse getPacketLengthArray] mutableCopy];
}

- (NSMutableArray *)getExtraRecordModeArray { //辅码流录像状态数组
    //录像状态有3种，没有录像、报警录像、一直录像
    return [[dataSourse getRecordModeArray] mutableCopy];
}
- (NSMutableArray *)getExtraPrerecordArray { //辅码流预录时间数组
    return [[dataSourse getPreRecordArray] mutableCopy];
}
- (NSMutableArray *)getExtraPacketLengthArray { //辅码流录像时长数组
     return [[dataSourse getPacketLengthArray] mutableCopy];
}


#pragma mark - 示例：设置周二晚上主码流为报警联动录像
- (void)setTuesdayNightAlarmRecord {
    if ( ![self checkRecord]) {//判断数据是否正常
        return;
    }
    //1、设置RecordMode为配置录像
    record.RecordMode = SZSTR(@"ConfigRecord") ;
    //2、设置周二的mask都为6。（周日-周六对应0-6）
    record.Mask[2][0] = 6;
    //3、设置时间。假设晚上从6点开始，就是18:00:00-24:00:00
    record.TimeSection[2][0] = SZSTR(@"1 18:00:00-24:00:00");
    //4、保存配置
    //  ～～～～～～
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
