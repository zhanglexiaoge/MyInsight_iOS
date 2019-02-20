//
//  IntelData.h
//  XMEye
//
//  Created by XM on 2017/5/8.
//  Copyright © 2017年 Megatron. All rights reserved.
//

/******
 
 设备智能分析数据支持对象
 
 *****/

enum DrawType{
    DrawType_PEA_Line = 0,
    DrawType_PEA_Area,
    DrawType_OSC_Stay,
    DrawType_OSC_Move,
};
#define SCALEWIDEH 8194.0     // 智能分析，例如画面宽度640，那么坐标点200传递给设备的坐标是8194*200/640
#import <Foundation/Foundation.h>

@interface AnalyzeDataSource : NSObject

@property (nonatomic) BOOL AnalyzeEnable;  //智能分析开关
@property (nonatomic) int ModuleType;  //智能分析算法   0周界警戒  1警戒线   2 警戒区域
//周界警戒
@property (nonatomic) int PeaLevel;       //警戒级别
@property (nonatomic) BOOL PeaShowRule;   //显示规则
@property (nonatomic) BOOL PeaShowTrace;  //显示轨迹

@property (nonatomic) BOOL PerimeterEnable;   //周线警戒开关
@property (nonatomic) int DirectionLimit;    //周线警戒方向 YES是双向
@property (nonatomic) int PeaPointNu;       //周界警戒点数量
@property (nonatomic, strong) NSMutableArray *PerimeterArray; //周线警戒点数组

@property (nonatomic) BOOL TripWireEnable;   //单线警戒开关
@property (nonatomic) BOOL IsDoubleDir;     //单线警戒向，YES是双向
@property (nonatomic, strong) NSMutableArray *TripWireArray; //单线警戒点数组

//物品看护
@property (nonatomic) int OscLevel;       //警戒级别
@property (nonatomic) BOOL OscShowRule;   //显示规则
@property (nonatomic) BOOL OscShowTrace;  //显示轨迹

@property (nonatomic) BOOL AbandumEnable;    //物品滞留开关
@property (nonatomic, strong) NSMutableArray *AbandumArray; //物品滞留点数组

@property (nonatomic) BOOL StolenEnable;    //物品盗移开关
@property (nonatomic, strong) NSMutableArray *StolenArray; //物品盗移点数组

//视频诊断
@property (nonatomic) BOOL ChangeEnable;   //场景变换检测
@property (nonatomic) BOOL InterfereEnable;  //人为干扰检测
@property (nonatomic) BOOL FreezeEnable;   //画面冻结检测
@property (nonatomic) BOOL NosignalEnable;  //信号缺失检测

#pragma mark - 获取开关字符串
-(NSString *)getEnableString:(BOOL)enable;
#pragma mark  获取开关BOOL值
-(BOOL)getEnableBool:(NSString *)enableStr;

- (NSArray *)analyzeLevelArray;

- (NSArray *)analyzeTypeArray;

- (NSString *)getAnalyzeTypeString:(NSInteger)type;
#pragma mark  根据String获取int
- (NSInteger)getAnalyzeTypeInt:(NSString*)typeString;


@end
