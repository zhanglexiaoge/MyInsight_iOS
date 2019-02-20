//
//  RecordSettingViewController.h
//  XMFamily
//
//  Created by hzjf on 14-8-27.
//  Copyright (c) 2014年 hzjf. All rights reserved.
//
/***
 SDK初始化类，这几个文件是调用大部分sdk接口所必须要使用或者继承之后使用的父类
 BaseViewController  普通的视图控制器或者功能类如果要使用FunSDK的json接口，可以继承自这个类，包括FUN_DevGetConfig_Json和FUN_DevSetConfig_Json接口 （在这个demo中，大部分的json接口都已经封装，可以直接使用对应的config类文件）
 *****/
#import <UIKit/UIKit.h>
#import "FunSDK/JObject.h"
#import "BaseViewController.h"
#define CFG_GET 0x1
#define CFG_SET 0x2
#define CFG_GET_SET 0x3
@interface CfgParam:NSObject{
}

@property (nonatomic, copy)   NSString* name;
@property (nonatomic, copy)   NSString* devId;
@property (nonatomic, assign) NSInteger channel;
@property (nonatomic)   JObject* cfg;
@property (nonatomic, copy)   NSString* cfgTmp;
@property (nonatomic, assign) BOOL      isGet;
@property (nonatomic, assign) BOOL      isSet;
@property (nonatomic, assign) BOOL      isOnce;
@property (nonatomic, assign) BOOL      isSaveLocal;
@property (nonatomic, assign) NSInteger errorCode;
@property (nonatomic, assign) NSInteger typeInfo;
@property (nonatomic, copy)   NSString* errorInfo;
@property (nonatomic, assign) NSInteger param2;
@property (nonatomic, copy)   NSMutableArray* autoUJ;

@property (nonatomic, copy)   NSString* cmdString;
@property (nonatomic, assign)   NSInteger cmdGet;
@property (nonatomic, assign) NSInteger cmdSet;

-(instancetype)initWithName:(NSString *)name andDevId:(NSString *)devId andChannel:(NSInteger)channel andConfig:(JObject *)cfg andOnce:(BOOL)once andSaveLocal:(BOOL)savalocal;
-(void)setAutoUJ:(NSMutableArray *)autoUJ;
-(int)UpdateToUI;
-(int)UpdateToJson;
+(instancetype)initWithName:(NSString *)devId andConfig:(JObject *)cfg andChannel:(NSInteger)channel andCfgType:(int)nCfgType;
@end

typedef enum EUI_TYPE{
    EUI_Unkown,
    EUI_Lable,
    EUI_Switch,
    EUI_CommBox_Str,
    EUI_CommBox_Int,
    EUI_Slider_Value,
}EUI_TYPE;

@interface UJObject : NSObject{
}
@property (nonatomic, strong)   NSObject *pUI;
@property (nonatomic, assign) JObject *pJson;
@property (nonatomic, assign) EUI_TYPE type;
@property (nonatomic, strong) NSMutableArray *param;
@property (nonatomic, assign) int intValueType;
-(int)UpdateToUI;
-(int)UpdateToJson;
+(instancetype)init:(NSObject *)ui UIType:(EUI_TYPE)type JsonObj:(JObject *)json type:(int)intValuetype;
+(instancetype)init:(NSObject *)ui JsonObj:(JObject *)json;
+(instancetype)init:(NSObject *)ui JsonObj:(JObject *)json intValueType:(int)type;
@end

@interface ConfigControllerBase : BaseViewController

@property (nonatomic, copy) NSString* devID;                     //设备id
@property (nonatomic, assign) int channel;                       //通道号
@property (nonatomic) JObject *config;
@property (nonatomic, strong) NSMutableArray *commboxArray;//数据和控件关联所需的控件数组
@property (nonatomic, strong) NSMutableDictionary* cfgs;
@property (nonatomic, strong) NSMutableDictionary* cmds;
@property (nonatomic) int nGetCfgCount;
@property (nonatomic) int nSetCfgCount;

- (void)AddConfig:(CfgParam *)param;
- (void)RemoveConfig:(NSString *)name;
- (void)RemoveAllConfig;
- (CfgParam *)GetConfigParam:(NSString *)name;
- (int)GetConfig;
- (int)GetConfig:(NSString *)name;
- (int)SetConfig:(NSString *)name timeOut:(NSInteger)time;
- (int)SetConfig;
- (int)SetConfig:(NSString *)name;
- (void)OnGetConfig:(CfgParam *)param;
- (void)OnInitAutoUI:(CfgParam *)param;
- (void)OnSetConfig:(CfgParam *)param;
- (void)OnFunSDKResult:(NSNumber *)pParam;

- (void)AddCmdfig:(CfgParam *)param;
- (void)RemoveCmdfig:(NSString *)name;
- (void)RemoveAllCmdfig;
- (CfgParam *)GetCmdfigParam:(NSString *)name;
//- (int)GetCmdfig;
//- (int)GetCmdfig:(NSString *)name;
//- (int)SetCmdfig:(NSString *)name timeOut:(NSInteger)time;
//- (int)SetCmdfig;
//- (int)SetCmdfig:(NSString *)name;

- (id)CMD_Result:(NSNumber *) pParam Name:(NSString*)name;
@end
