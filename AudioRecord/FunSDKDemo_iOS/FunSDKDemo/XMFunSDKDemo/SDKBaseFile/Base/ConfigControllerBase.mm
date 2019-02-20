//
//  ConfigControllerBase.mm
//  XMFamily
//
//  Created by hzjf on 14-8-27.
//  Copyright (c) 2014年 hzjf. All rights reserved.
//

#import "ConfigControllerBase.h"
#import "FunSDK/FunSDK.h"
#import "NSString+Extention.h"
@implementation CfgParam
-(instancetype)init
{
    id obj = [super init];
    _name = @"Unknow";
    _devId = @"InvalidId";
    _isGet = YES;
    _isSet = YES;
    _isOnce = NO;
    _isSaveLocal = NO;
    _channel = -1;
    _cfg = NULL;
    _autoUJ = nil;
    _cmdGet = 0;
    _cmdSet = 0;
    return obj;
}

-(instancetype)initWithName:(NSString *)name andDevId:(NSString *)devId andChannel:(NSInteger)channel andConfig:(JObject *)cfg andOnce:(BOOL)once andSaveLocal:(BOOL)savalocal
{
    id obj = [self init];
    _name = name;
    _devId = devId;
    _channel = channel;
    _cfg = cfg;
    _isOnce = once;
    return obj;
}
+(instancetype)initWithName:(NSString *)devId andConfig:(JObject *)cfg andChannel:(NSInteger)channel andCfgType:(int)nCfgType{
    CfgParam *obj = [[CfgParam alloc] init];
    obj.name= [NSString stringWithUTF8String:cfg->Name()] ;
    obj.devId = devId;
    obj.channel = channel;
    obj.cfg = cfg;
    obj.isGet = (nCfgType & 0x1) != 0;
    obj.isSet = (nCfgType & 0x2) != 0;
    return obj;
}
-(void)setAutoUJ:(NSMutableArray *)autoUJ{
    _autoUJ = autoUJ;
}
-(int)UpdateToUI{
    if (_autoUJ == nil) {
        return -1;
    }
    for (int i = 0; i < [_autoUJ count]; i++) {
        UJObject *pUJ = (UJObject *)_autoUJ[i];
        if (pUJ != nil) {
            [pUJ UpdateToUI];
        }
    }
    return 0;
}
-(int)UpdateToJson{
    if (_autoUJ == nil) {
        return -1;
    }
    for (int i = 0; i < [_autoUJ count]; i++) {
        UJObject *pUJ = (UJObject *)_autoUJ[i];
        if (pUJ != nil) {
            [pUJ UpdateToJson];
        }
    }
    return 0;
}
@end

@implementation UJObject

- (instancetype)init {
    id obj = [super init];
    _pJson = NULL;
    _pUI = nil;
    return obj;
}

+(instancetype)init:(NSObject *)ui JsonObj:(JObject *)json intValueType:(int)type{
    return [UJObject init:ui UIType:EUI_Unkown JsonObj:json type:type];
}
+(instancetype)init:(NSObject *)ui JsonObj:(JObject *)json{
    return [UJObject init:ui UIType:EUI_Unkown JsonObj:json type:0];
}
@end

@implementation ConfigControllerBase

- (instancetype)init{
    _cfgs = [[NSMutableDictionary alloc] initWithCapacity:0];
    _cmds = [[NSMutableDictionary alloc] initWithCapacity:0];
    return [super init];
}
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    _cfgs = [[NSMutableDictionary alloc] initWithCapacity:0];
    _cmds = [[NSMutableDictionary alloc] initWithCapacity:0];
    return [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _commboxArray = [[NSMutableArray alloc] initWithCapacity:0];
}

- (void)OnFunSDKResult:(NSNumber *) pParam{
    NSInteger nAddr = [pParam integerValue];
    MsgContent *msg = (MsgContent *)nAddr;
    //json回调
    if ( EMSG_DEV_GET_CONFIG_JSON == msg->id || EMSG_DEV_SET_CONFIG_JSON  == msg->id ) {
        
        NSString* name  = [NSString stringWithUTF8String:msg->szStr];
        CfgParam* param = _cfgs[name];
        param.errorCode = msg->param1;
        param.typeInfo = msg->param3;
        param.param2 = msg->param2;
        
        if (EMSG_DEV_GET_CONFIG_JSON == msg->id){
            if ( param.errorCode >= 0 ) {
                if ( param.cfg ) {
                    NSString* strName;
                    if ( param.channel >= 0 ) {
                        strName = [NSString stringWithFormat:@"%@.[%ld]", name, (long)param.channel];
                    }
                    else{
                        strName = name;
                    }
                    if (msg->pObject == nil) {
                        return;
                    }
                    param.cfgTmp = [NSString stringWithUTF8String:msg->pObject];
                    if (param.cfgTmp == nil) {
                        NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
                        NSData *data = [NSData dataWithBytes:msg->pObject length:strlen(msg->pObject)];
                        param.cfgTmp = [[NSString alloc] initWithData:data encoding:enc];
                    }
                    NSLog(@"msg->pObject =%s",msg->pObject);
                    NSString *tmpStr = [param.cfgTmp stringByReplacingOccurrencesOfString:strName withString:param.name];
                    param.cfgTmp = tmpStr;
                    int nRet = param.cfg->Parse([param.cfgTmp UTF8String]);
                    NSLog(@"Parse result[%d]", nRet);
                }
            }
            [self OnGetConfig:param];
        }else if ( EMSG_DEV_SET_CONFIG_JSON == msg->id) {
            
            [self OnSetConfig:param];
        }
        //cmd回调
    }else if (msg->id ==  EMSG_DEV_CMD_EN) {
        
        NSString* name  = [NSString stringWithUTF8String:msg->szStr];
        CfgParam* param = _cmds[name];
        param.errorCode = msg->param1;
        param.typeInfo = msg->param3;
        param.param2 = msg->param2;
        
        if (param.isGet == YES){
            if ( param.errorCode >= 0 ) {
                if ( param.cfg ) {
                    NSString* strName;
                    if ( param.channel >= 0 ) {
                        strName=  name;
                        //strName = [NSString stringWithFormat:@"%@.[%ld]", name, (long)param.channel];
                    }
                    else{
                        strName = name;
                    }
                    if (msg->pObject == nil) {
                        return;
                    }
                    param.cfgTmp = [NSString stringWithUTF8String:msg->pObject];
                    if (param.cfgTmp == nil) {
                        NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
                        NSData *data = [NSData dataWithBytes:msg->pObject length:strlen(msg->pObject)];
                        param.cfgTmp = [[NSString alloc] initWithData:data encoding:enc];
                    }
                    NSLog(@"msg->pObject =%s",msg->pObject);
                    NSString *tmpStr = [param.cfgTmp stringByReplacingOccurrencesOfString:strName withString:param.name];
                    param.cfgTmp = tmpStr;
                    int nRet = param.cfg->Parse([param.cfgTmp UTF8String]);
                    NSLog(@"Parse result[%d]", nRet);
                }
            }
            [self OnGetConfig:param];
        }else if ( param.isSet == YES) {
            [self OnSetConfig:param];
        }
    }
}
//添加json Config
- (void)AddConfig:(CfgParam *)param{
    if ( param ) {
        if ([[_cfgs allKeys] containsObject:param.name]) {
            _cfgs[param.name] = param;
            return;
        }
        _cfgs[param.name] = param;
        
        if (param.isSet) {
            _nSetCfgCount++;
        }
        if (param.isGet) {
            _nGetCfgCount++;
        }
    }
}
//添加cmdConfig
- (void)AddCmdfig:(CfgParam *)param{
    if ( param ) {
        if ([[_cmds allKeys] containsObject:param.name]) {
            _cmds[param.name] = param;
            return;
        }
        _cmds[param.name] = param;
    }
}
//删除json
- (void)RemoveConfig:(NSString *)name{
    [_cfgs removeObjectForKey:name];
}
//删除cmd
- (void)RemoveCmdfig:(NSString *)name {
    [_cmds removeObjectForKey:name];
}
//删除json
- (void)RemoveAllConfig{
    
}
//删除cmd
- (void)RemoveAllCmdfig {
    [_cmds removeAllObjects];
}
//返回json对象
- (CfgParam *)GetConfigParam:(NSString *)name{
    return [_cfgs objectForKey:name];
}
//返回cmd对象
- (CfgParam *)GetCmdfigParam:(NSString *)name {
    return [_cmds objectForKey:name];
}

//获取所有json配置,一般界面第一次出现时需要调用。其他需要调用的地方（更新配置时）调用下
- (int)GetConfig{
    for( NSString* name in _cfgs ){
        [self GetConfig:name];
    }
    return 0;
}
//获取所有cmd配置,一般界面第一次出现时需要调用。其他需要调用的地方（更新配置时）调用下
- (int)GetCmdfig{
    for( NSString* name in _cmds ){
        [self GetCmdfig:name];
    }
    return 0;
}
//获取json配置
- (int)GetConfig:(NSString *)name{
    CfgParam* param = _cfgs[name];
    if ( param && param.isGet) {
        FUN_DevGetConfig_Json(SELF, SZSTR(param.devId), SZSTR(param.name), 0, (int)param.channel);
    }
    return 0;
}
//获取cmd配置
- (int)GetCmdfig:(NSString *)name{
    CfgParam* param = _cmds[name];
    if ( param && param.isGet) {
        if (param.cmdString == nil) {
            FUN_DevCmdGeneral(SELF, SZSTR(param.devId), (int)param.cmdGet, SZSTR(param.name), 0, 5000, NULL, 0, -1, 0);
        }else{
            char * cmd = (char *)[param.cmdString UTF8String];
            FUN_DevCmdGeneral(SELF, SZSTR(param.devId), (int)param.cmdGet, SZSTR(param.name), 0, 5000, cmd, (int)strlen(cmd) + 1, -1, 0);
        }
    }
    return 0;
}

//保存所有json配置
- (int)SetConfig{
    for( NSString* name in _cfgs ){
        [self SetConfig:name];
    }
    return 0;
}
//保存所有cmd配置
- (int)SetCmdfig{
    for( NSString* name in _cmds ){
        [self SetCmdfig:name];
    }
    return 0;
}

//保存所有json配置
- (int)SetConfig:(NSString *)name{
    CfgParam* param = _cfgs[name];
    if (param == nil || (param.isGet && param.cfgTmp == nil)) {
        return 0;
    }
    if (param && param.isSet ) {
        [param UpdateToJson];
        const char * pConfig = param.cfg->ToString();
        if ((strlen(pConfig) > 0) && (!param.isGet || strcmp(pConfig, [param.cfgTmp UTF8String]))) {
            //配置改变了才需要设置
            FUN_DevSetConfig_Json(SELF, SZSTR(param.devId), SZSTR(param.name), pConfig, (int)strlen(pConfig), (int)param.channel);
        }
    }
    return 0;
}
//保存所有cmd配置
- (int)SetCmdfig:(NSString *)name{
    CfgParam* param = _cmds[name];
    if (param == nil || (param.isGet && param.cfgTmp == nil)) {
        return 0;
    }
    if (param && param.isSet ) {
        [param UpdateToJson];
        const char * pConfig = param.cfg->ToString();
        if ((strlen(pConfig) > 0) && (!param.isGet || strcmp(pConfig, [param.cfgTmp UTF8String]))) {
            //配置改变了才需要设置
            if (param.cmdString == nil) {
                FUN_DevCmdGeneral(SELF, SZSTR(param.devId), (int)param.cmdGet, SZSTR(param.name), 0, 5000, NULL, 0, -1, 0);
            }else{
                char * cmd = (char *)[param.cmdString UTF8String];
                FUN_DevCmdGeneral(SELF, SZSTR(param.devId), (int)param.cmdGet, SZSTR(param.name), 0, 5000, cmd, (int)strlen(cmd) + 1, -1, 0);
            }
        }
    }
    return 0;
}

//保存json配置
- (int)SetConfig:(NSString *)name timeOut:(NSInteger)time {
    CfgParam* param = _cfgs[name];
    if (param == nil || (param.isGet && param.cfgTmp == nil)) {
        return 0;
    }
    if (param && param.isSet ) {
        [param UpdateToJson];
        const char * pConfig = param.cfg->ToString();
        if ((strlen(pConfig) > 0) && (!param.isGet || strcmp(pConfig, [param.cfgTmp UTF8String]))) {
            //配置改变了才需要设置
            FUN_DevSetConfig_Json(SELF, SZSTR(param.devId), SZSTR(param.name), pConfig, (int)strlen(pConfig), (int)param.channel, (int)time);
        }
    }
    return 0;
}
//保存cmd配置
- (int)SetCmdfig:(NSString *)name timeOut:(NSInteger)time {
    CfgParam* param = _cmds[name];
    if (param == nil || (param.isGet && param.cfgTmp == nil)) {
        return 0;
    }
    if (param && param.isSet ) {
        [param UpdateToJson];
        const char * pConfig = param.cfg->ToString();
        if ((strlen(pConfig) > 0) && (!param.isGet || strcmp(pConfig, [param.cfgTmp UTF8String]))) {
            //配置改变了才需要设置
            if (param.cmdString == nil) {
                FUN_DevCmdGeneral(SELF, SZSTR(param.devId), (int)param.cmdGet, SZSTR(param.name), 0, (int)time, NULL, 0, -1, 0);
            }else{
                char * cmd = (char *)[param.cmdString UTF8String];
                FUN_DevCmdGeneral(SELF, SZSTR(param.devId), (int)param.cmdGet, SZSTR(param.name), 0, (int)time, cmd, (int)strlen(cmd) + 1, -1, 0);
            }
        }
    }
    return 0;
}

//获取到一个配置
//errorCode>=0 为成功 <0 为错误码， 此时errorInfo为错误信息
//this param is readonly !!
- (void)OnGetConfig:(CfgParam *)param {
    if (param.autoUJ == nil && param.errorCode > 0) {
        [self OnInitAutoUI:param];
    }
    [param UpdateToUI];
    if (param.errorCode <0) {
    }
}
- (void)OnInitAutoUI:(CfgParam *)param {
}

//完成设置一个配置
//errorCode>=0 为成功 <0 为错误码， 此时errorInfo为错误信息
//this param is readonly !!
- (void)OnSetConfig:(CfgParam *)param {
    [param UpdateToJson];
}

- (id)CMD_Result:(NSNumber *) pParam Name:(NSString*)name {
    NSInteger nAddr = [pParam integerValue];
    MsgContent *msg = (MsgContent *)nAddr;
    //1、先取出数据
    char *result = (char *)msg->pObject;
    if (result == nil || strlen(result) == 0) {
        return nil;
    }
    // 2.0 将c的jason字符串转化为NSData
    NSData *resultData = [NSData dataWithBytes:result length:strlen(result)];
    if (resultData == nil) {
        return nil;
    }
    // 3.0 将NSData转化为字典
    NSError *error;
    NSMutableDictionary *socketInfoDic = (NSMutableDictionary*)[NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableLeaves error:&error];
    
    return [socketInfoDic objectForKey:name];
}
@end
