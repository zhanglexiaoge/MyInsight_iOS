//
//  AnalyzeConfig.m
//  FunSDKDemo
//
//  Created by XM on 2018/12/22.
//  Copyright © 2018年 XM. All rights reserved.
//

#import "AnalyzeConfig.h"
#import "Detect_Analyze.h"
#import "AnalyzeDataSource.h"

@interface AnalyzeConfig ()
{
    Detect_Analyze Analyze;//智能分析
    AnalyzeDataSource *dataSource; //智能分析数据支持对象
}
@end

@implementation AnalyzeConfig
#pragma mark  判断当前数据是否有效 （比如获取到的数据异常）
- (BOOL)checkParam  {
    if (Analyze.mRuleConfig.mPEARule.mTripWireRule.TripWire.Size()<=0) {
        return NO;
    }
    if (Analyze.mRuleConfig.mOSCRule.mAbandumRule.SpclRgs.Size()<=0) {
        return NO;
    }
    if (Analyze.mRuleConfig.mOSCRule.mNoParkingRule.SpclRgs.Size()<=0) {
        return NO;
    }
    if (Analyze.mRuleConfig.mOSCRule.mStolenRule.SpclRgs.Size()<=0) {
        return NO;
    }
    return YES;
}

#pragma mark - 请求智能分析
- (void)getAnalyzeConfig {
    ChannelObject *channel = [[DeviceControl getInstance] getSelectChannel];
    DeviceObject *device = [[DeviceControl getInstance] GetDeviceObjectBySN:channel.deviceMac];
    dataSource = [self getAnalyzeDataSource];
    if (device.sysFunction.NewVideoAnalyze == YES) {
        //支持智能分析
    }else {
        return;
    }
    CfgParam* paramsetEnableVideo = [[CfgParam alloc] initWithName:[NSString stringWithUTF8String:Analyze.Name()] andDevId:channel.deviceMac andChannel:channel.channelNumber andConfig:&Analyze andOnce:YES andSaveLocal:NO];
    [self AddConfig:paramsetEnableVideo];
    [self GetConfig];
}

#pragma mark - 保存智能分析配置
- (void)setAnalyzeConfig {
    //当前算法配置
    Analyze.Enable = dataSource.AnalyzeEnable;
    Analyze.mEventHandler.RecordEnable = dataSource.AnalyzeEnable;
    Analyze.ModuleType = dataSource.ModuleType;
    
    //PEA配置
    Analyze.mRuleConfig.mPEARule.PerimeterEnable = dataSource.PerimeterEnable;//周线警戒开关
    Analyze.mRuleConfig.mPEARule.TripWireEnable = dataSource.TripWireEnable; //单线警戒开关
    Analyze.mRuleConfig.mPEARule.ShowRule = dataSource.PeaShowRule;  //显示规则
    Analyze.mRuleConfig.mPEARule.ShowTrace = dataSource.PeaShowTrace;  //显示踪迹
    Analyze.mRuleConfig.mPEARule.ShowTrack = dataSource.PeaShowRule;
    Analyze.mRuleConfig.mPEARule.mPerimeterRule.mLimitPara.DirectionLimit = dataSource.DirectionLimit; //周线警戒方向
    if (Analyze.mRuleConfig.mPEARule.mTripWireRule.TripWire.Size()>0) {//单线警戒方向
        Analyze.mRuleConfig.mPEARule.mTripWireRule.TripWire[0].IsDoubleDir = dataSource.IsDoubleDir;
        Analyze.mRuleConfig.mPEARule.mTripWireRule.TripWire[0].Valid = dataSource.PeaShowRule;
    }
    //OSC配置
    Analyze.mRuleConfig.mOSCRule.AbandumEnable = dataSource.AbandumEnable;
    Analyze.mRuleConfig.mOSCRule.StolenEnable = dataSource.StolenEnable;
    Analyze.mRuleConfig.mOSCRule.ShowRule = dataSource.OscShowRule;
    Analyze.mRuleConfig.mOSCRule.ShowTrace = dataSource.OscShowTrace;
    Analyze.mRuleConfig.mOSCRule.ShowTrack = dataSource.OscShowRule;
    //设置是否显示规则
    Analyze.mRuleConfig.mOSCRule.mAbandumRule.SpclRgs[0].Valid = dataSource.OscShowRule;
    Analyze.mRuleConfig.mOSCRule.mNoParkingRule.SpclRgs[0].Valid = dataSource.OscShowRule;
    Analyze.mRuleConfig.mOSCRule.mStolenRule.SpclRgs[0].Valid = dataSource.OscShowRule;
    
    //场景变换检测
    Analyze.mRuleConfig.mAVDRule.ChangeEnable = dataSource.ChangeEnable;
    //人为干扰检测
    Analyze.mRuleConfig.mAVDRule.InterfereEnable = dataSource.InterfereEnable;
    //画面冻结检测
    Analyze.mRuleConfig.mAVDRule.FreezeEnable = dataSource.FreezeEnable;
    //信号缺失检测
    Analyze.mRuleConfig.mAVDRule.NosignalEnable = dataSource.NosignalEnable;
    
    [self SetConfig];
}
#pragma mark - 请求智能分析回调
-(void)OnGetConfig:(CfgParam *)param{
    if ([param.name isEqualToString:[NSString stringWithUTF8String:Analyze.Name()]]) {
        if (param.errorCode <= 0) {
        }else{
            //智能分析开关
            dataSource.AnalyzeEnable = Analyze.Enable.Value();
            //智能分析算法
            dataSource.ModuleType = Analyze.ModuleType.Value();

            //警戒级别
            dataSource.PeaLevel = Analyze.mRuleConfig.mPEARule.Level.Value();
            //显示规则
            dataSource.PeaShowRule = Analyze.mRuleConfig.mPEARule.ShowRule.Value();
            //显示轨迹
            dataSource.PeaShowTrace = Analyze.mRuleConfig.mPEARule.ShowTrace.Value();

            //周线警戒开关
            dataSource.PerimeterEnable = Analyze.mRuleConfig.mPEARule.PerimeterEnable.Value();
            //周线警戒方向
            dataSource.DirectionLimit = Analyze.mRuleConfig.mPEARule.mPerimeterRule.mLimitPara.DirectionLimit.Value();
            //周线警戒点数组
            dataSource.PerimeterArray = [[self getAnalyzePointArray:DrawType_PEA_Area] mutableCopy];

            //单线警戒开关
            dataSource.TripWireEnable = Analyze.mRuleConfig.mPEARule.TripWireEnable.Value();
            //单线警戒是否是双向
            if (Analyze.mRuleConfig.mPEARule.mTripWireRule.TripWire.Size()>0) {
                dataSource.IsDoubleDir = Analyze.mRuleConfig.mPEARule.mTripWireRule.TripWire[0].IsDoubleDir.Value();
            }
            //单线警戒点数组
            dataSource.TripWireArray = [[self getAnalyzePointArray:DrawType_PEA_Line] mutableCopy];

            //警戒级别
            dataSource.OscLevel = Analyze.mRuleConfig.mOSCRule.Level.Value();
            //显示规则
            dataSource.OscShowRule = Analyze.mRuleConfig.mOSCRule.ShowRule.Value();
            //显示轨迹
            dataSource.OscShowTrace = Analyze.mRuleConfig.mOSCRule.ShowTrace.Value();

            //物品滞留开关
            dataSource.AbandumEnable = Analyze.mRuleConfig.mOSCRule.AbandumEnable.Value();
            //物品滞留点数组
            dataSource.AbandumArray = [[self getAnalyzePointArray:DrawType_OSC_Stay] mutableCopy];

            //物品盗移开关
            dataSource.StolenEnable = Analyze.mRuleConfig.mOSCRule.StolenEnable.Value();
            //物品盗移点数组
            dataSource.StolenArray = [[self getAnalyzePointArray:DrawType_OSC_Move] mutableCopy];

            //场景变换检测
            dataSource.ChangeEnable = Analyze.mRuleConfig.mAVDRule.ChangeEnable.Value();
            //人为干扰检测
            dataSource.InterfereEnable = Analyze.mRuleConfig.mAVDRule.InterfereEnable.Value();
            //画面冻结检测
            dataSource.FreezeEnable = Analyze.mRuleConfig.mAVDRule.FreezeEnable.Value();
            //信号缺失检测
            dataSource.NosignalEnable = Analyze.mRuleConfig.mAVDRule.NosignalEnable.Value();
        }
        if ([self.delegate respondsToSelector:@selector(getAnalyzeConfigResult:)]) {
            [self.delegate getAnalyzeConfigResult:param.errorCode];
        }
    }
}
#pragma mark - 设置智能分析配置回调
-(void)OnSetConfig:(CfgParam *)param {
    if ( [param.name isEqualToString:[NSString stringWithUTF8String:Analyze.Name()]] ) {
        if ([self.delegate respondsToSelector:@selector(setAnalyzeConfigResult:)]) {
            [self.delegate setAnalyzeConfigResult:param.errorCode];
        }
    }
}

#pragma mark -  获取区域警戒点数组
-(NSMutableArray*)getAnalyzePointArray:(DrawType)type
{
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
    switch (type) {
        case DrawType_PEA_Line: {
            [self getTripWireData:array];
        }
            break;
        case DrawType_PEA_Area: {
            [self getPerimeterData:array];
        }
            break;
        case DrawType_OSC_Move: {
            [self getStolenRuleData:array];
        }
            break;
        case DrawType_OSC_Stay: {
            [self getAbandumData:array];
        }
            break;
        default:
            break;
    }
    return array;
}
//获取区域警戒数组
-(void)getPerimeterData:(NSMutableArray*)array {
    for (int i = 0; i< Analyze.mRuleConfig.mPEARule.mPerimeterRule.mLimitPara.mBoundary.PointNum.Value(); i++) {
        float x = Analyze.mRuleConfig.mPEARule.mPerimeterRule.mLimitPara.mBoundary.Points[i].x.Value();
        float y = Analyze.mRuleConfig.mPEARule.mPerimeterRule.mLimitPara.mBoundary.Points[i].y.Value();
        CGPoint point = CGPointMake(x/SCALEWIDEH*ScreenWidth, y/SCALEWIDEH*ScreenWidth);
        [array addObject:[NSValue valueWithCGPoint:point]];
    }
}
//获取单线警戒数组
-(void)getTripWireData:(NSMutableArray*)array {
    if (Analyze.mRuleConfig.mPEARule.mTripWireRule.TripWire.Size() >0 ) {
        float xStart = Analyze.mRuleConfig.mPEARule.mTripWireRule.TripWire[0].mLine.mStartPt.x.Value();
        float yStart = Analyze.mRuleConfig.mPEARule.mTripWireRule.TripWire[0].mLine.mStartPt.y.Value();
        CGPoint pStart = CGPointMake(xStart/SCALEWIDEH*ScreenWidth, yStart/SCALEWIDEH*ScreenWidth);
        float xEnd = Analyze.mRuleConfig.mPEARule.mTripWireRule.TripWire[0].mLine.mEndPt.x.Value();
        float yEnd = Analyze.mRuleConfig.mPEARule.mTripWireRule.TripWire[0].mLine.mEndPt.y.Value();
        CGPoint pEnd = CGPointMake(xEnd/SCALEWIDEH*ScreenWidth, yEnd/SCALEWIDEH*ScreenWidth);
        [array addObject:[NSValue valueWithCGPoint:pStart]];
        [array addObject:[NSValue valueWithCGPoint:pEnd]];
    }
}

//获取物品滞留数组
-(void)getAbandumData:(NSMutableArray*)array {
    if (Analyze.mRuleConfig.mOSCRule.mAbandumRule.SpclRgs.Size() > 0 ) {
        for (int i =0; i< Analyze.mRuleConfig.mOSCRule.mAbandumRule.SpclRgs[0].mOscRg.PointNu.Value(); i++) {
            float x = Analyze.mRuleConfig.mOSCRule.mAbandumRule.SpclRgs[0].mOscRg.Points[i].x.Value();
            float y = Analyze.mRuleConfig.mOSCRule.mAbandumRule.SpclRgs[0].mOscRg.Points[i].y.Value();
            CGPoint point = CGPointMake(x/SCALEWIDEH*ScreenWidth, y/SCALEWIDEH*ScreenWidth);
            [array addObject:[NSValue valueWithCGPoint:point]];
        }
    }
}
//获取物品盗移数组
-(void)getStolenRuleData:(NSMutableArray*)array {
    if (Analyze.mRuleConfig.mOSCRule.mStolenRule.SpclRgs.Size() > 0 ) {
        for (int i =0; i< Analyze.mRuleConfig.mOSCRule.mStolenRule.SpclRgs[0].mOscRg.PointNu.Value(); i++) {
            float x = Analyze.mRuleConfig.mOSCRule.mStolenRule.SpclRgs[0].mOscRg.Points[i].x.Value();
            float y = Analyze.mRuleConfig.mOSCRule.mStolenRule.SpclRgs[0].mOscRg.Points[i].y.Value();
            CGPoint point = CGPointMake(x/SCALEWIDEH*ScreenWidth, y/SCALEWIDEH*ScreenWidth);
            [array addObject:[NSValue valueWithCGPoint:point]];
        }
    }
}

- (AnalyzeDataSource*)getAnalyzeDataSource {
    if (dataSource == nil) {
        dataSource = [[AnalyzeDataSource alloc] init];
    }
    return dataSource;
}

- (NSMutableArray*)getEnableArray {//获取开关数组
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i =0 ; i< 2; i++) {
        NSString *enable = [dataSource getEnableString:i];
        [array addObject:enable];
    }
    return array;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
