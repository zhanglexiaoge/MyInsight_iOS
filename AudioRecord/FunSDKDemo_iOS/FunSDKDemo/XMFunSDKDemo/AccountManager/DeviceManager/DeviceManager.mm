//
//  DeviceManager.m
//  MobileVideo
//
//  Created by XM on 2018/4/18.
//  Copyright © 2018年 XM. All rights reserved.
//
#import "FunSDK/FunSDK.h"
#import <FunSDK/FunSDK2.h>
#import <string>
#import "GTMNSString+HTML.h"
#import "AlarmManager.h"
#import "DeviceManager.h"
#import "XMNetInterface/NetInterface.h"

@implementation NSMessage
+ (id)SendMessag:(NSString *) name obj:(void *) obj p1:(int)param1 p2:(int)param2 {
    NSMessage *pNew = [NSMessage alloc];
    [pNew setObj:obj];
    [pNew setParam1:param1];
    [pNew setParam2:param2];
    return pNew;
}
@end

@interface DeviceManager ()
{
    NSString *deviceMac;
}
@end

@implementation DeviceManager
+ (instancetype)getInstance {
    static DeviceManager *Manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Manager = [[DeviceManager alloc]init];
    });
    return Manager;
}
- (id)init {
    self = [super init];
    return self;
}
#pragma mark -通过序列号、局域网搜索、ap模式连接添加设备
- (void)addDeviceByDeviseSerialnumber:(NSString*)serialNumber deviceName:(NSString *)deviceName devType:(int)type {
    //直接通过序列号添加设备
    if (deviceName == nil) {
        deviceName = serialNumber;
    }
    SDBDeviceInfo devInfo = {0};
    STRNCPY(devInfo.loginName, SZSTR(@"admin"));
    STRNCPY(devInfo.loginPsw, SZSTR(@""));
    STRNCPY(devInfo.Devmac, SZSTR(serialNumber));
    devInfo.nType = type;
    STRNCPY(devInfo.Devname, SZSTR(deviceName));
    devInfo.nPort = 34567;
    FUN_SysAdd_Device(self.msgHandle, &devInfo);
}
#pragma mark - 通过ip/域名添加
- (void)addDeviceByDeviceIP:(NSString *)deviceIP deviceName:(NSString *)name password:(NSString *)psw port:(NSString *)port{
    SDBDeviceInfo devInfo = {0};
    STRNCPY(devInfo.Devname, SZSTR(name));
    STRNCPY(devInfo.loginName, SZSTR(@"admin"));
    STRNCPY(devInfo.loginPsw, SZSTR(psw));
    NSString *myPort = (port.length == 0) ? @"34567" :port;
    devInfo.nPort = [myPort intValue];
    
    NSString *index = [NSString stringWithFormat:@"%@:%@",deviceIP, myPort];
    STRNCPY(devInfo.Devmac, SZSTR(index));
    FUN_SysAdd_Device(self.msgHandle, &devInfo);
}
#pragma mark - 局域网搜索设备
//先搜索局域网设备，搜索到之后才能进行添加
- (void)SearchDevice {
     FUN_DevSearchDevice(self.msgHandle, 4000, 0);
}
//搜索到之后，再选择要添加的设备添加
- (void)addDeviceBySerialNum:(NSString *)serialNumber deviceName:(NSString *)name type:(int)devType{
    SDBDeviceInfo devInfo = {0};
    STRNCPY(devInfo.loginName, SZSTR(@"admin"));
    STRNCPY(devInfo.loginPsw, SZSTR(@""));
    STRNCPY(devInfo.Devmac, SZSTR(serialNumber));
    STRNCPY(devInfo.Devname, SZSTR(name));
    devInfo.nType = devType;
    devInfo.nPort = 34567;
    FUN_SysAdd_Device(self.msgHandle, &devInfo);
}

#pragma mark - ap添加设备
- (void)addDeviceByAP {
    
}

#pragma mark - 开始快速配置
-(void)startConfigWithSSID:(NSString*)ssid password:(NSString*)password{
    
    char data[128] = {0};
    char infof[256] = {0};
    int encmode = 1;
    unsigned char mac[6] = {0};
    sprintf(data, "S:%sP:%sT:%d", [ssid UTF8String], SZSTR(password), encmode);
    NSString* sGateway = [NetInterface getDefaultGateway];
    sprintf(infof, "gateway:%s ip:%s submask:%s dns1:%s dns2:%s mac:0", SZSTR(sGateway), [[NetInterface getCurrent_IP_Address] UTF8String],"255.255.255.0",SZSTR(sGateway),SZSTR(sGateway));
    NSString* sMac = [NetInterface getCurrent_Mac];
    sscanf(SZSTR(sMac), "%x:%x:%x:%x:%x:%x", &mac[0], &mac[1], &mac[2], &mac[3], &mac[4], &mac[5]);
    
    NSLog(@"快速配置流程：发送路由器信息");
    FUN_DevStartAPConfig(self.msgHandle, 3, SZSTR(ssid), data, infof, SZSTR(sGateway), encmode, 0, mac, 180000);
}

#pragma mark - 停止快速配置
-(void)stopConfig{
    FUN_DevStopAPConfig();
}

#pragma mark - 解析二维码
-(NSArray *)decodeDevInfo:(NSString*)info{
    char szDevId[256] = {0};
    char szUserName[64] = {0};
    char szPassword[64] = {0};
    int nType = 0;
    int time = 0;
    FUN_DecDevInfo([info UTF8String], szDevId, szUserName, szPassword, nType, time);
    NSArray* array = [[NSArray alloc] initWithObjects:[NSString stringWithUTF8String:szDevId], [NSString stringWithUTF8String:szUserName],[NSString stringWithUTF8String:szPassword], [NSString stringWithFormat:@"%d", nType], nil];
    return array;
}

#pragma mark - 获取设备状态
- (void)getDeviceState:(NSString *)deviceMac {
    std::string myDev;
    if (deviceMac != nil) {
        myDev.append([deviceMac UTF8String]);
        myDev.append(";");
    }else{
        NSMutableArray *deviceArray = [[DeviceControl getInstance] currentDeviceArray];
        for (int i = 0; i < deviceArray.count; i ++) {
            DeviceObject *devObject = [deviceArray objectAtIndex:i];
            if(devObject!= nil){
                myDev.append([devObject.deviceMac UTF8String]);
                myDev.append(";");
            }
        }
    }
    if (myDev.length() > 0){
        FUN_SysGetDevState(self.msgHandle, myDev.c_str());
    }else{
        //没有设备  直接回调
        if (self.delegate && [self.delegate respondsToSelector:@selector(getDeviceState:result:)]) {
            [self.delegate getDeviceState:nil result:YES];
        }
    }
}

#pragma mark - 唤醒睡眠中的设备
- (void)deviceWeakUp:(NSString*)string {
    DeviceObject *object = [[DeviceControl getInstance] GetDeviceObjectBySN:string];
    //门铃门锁等设备才需要每次唤醒
    if (object.nType == XM_DEV_CAT || object.nType == XM_DEV_DOORBELL || object.nType == CZ_DOORBELL || object.nType == XM_DEV_DOORBELL_A) {
        deviceMac = string;
        FUN_DevWakeUp(self.msgHandle, SZSTR(deviceMac), 0);
    }
}

#pragma mark - 获取设备通道
- (void)getDeviceChannel:(NSString *)devMac {
    DeviceObject *devObject = [[DeviceControl getInstance] GetDeviceObjectBySN:devMac];
    if (devObject == nil) {
        return;
    }
    //1、先判断本地是否有保存，底层库是否已经获取到（DSS设备能直接获取到）
    NSMutableArray *nameArr = [self getChannleFromUserDB:devMac];
    if (devObject.channelArray.count>0 || nameArr.count >0){
        if (devObject.channelArray.count == 0) {
            //本地保存的有通道，则传递给deviceObject对象
            NSMutableArray *channelArray = [[NSMutableArray alloc] initWithCapacity:0];
            for (int i =0; i< nameArr.count; i++) {
                NSString *str = [nameArr objectAtIndex:i];
                ChannelObject *channel = [[DeviceControl getInstance] addName:str ToDeviceObject:devObject];
                channel.channelNumber = i;
                [channelArray addObject:channel];
            }
            devObject.channelArray = [channelArray mutableCopy];
        }
        //本地已经有保存，后台更新通道名称
        FUN_DevGetChnName(self.msgHandle, [devObject.deviceMac UTF8String], "", "", -1);
        return;
    }
    //2、从服务器获取通道信息，获取成功后刷新
    FUN_DevGetChnName(self.msgHandle, [devMac UTF8String], "", "", 0);
}

#pragma mark - 修改设备信息
- (void)changeDevice:(NSString *)devMac devName:(NSString *)name username:(NSString *)user password:(NSString *)psw {
    NSMutableArray *deviceArray = [[DeviceControl getInstance] currentDeviceArray];
    DeviceObject *devObj = [[DeviceControl getInstance] GetDeviceObjectBySN:devMac];
    devObj.loginName = user;
    devObj.loginPsw = psw;
    SDBDeviceInfo devInfo = {0};
    strncpy(devInfo.Devmac, SZSTR(devMac), 64);
    strncpy(devInfo.Devname, SZSTR(name), 128);
    devInfo.nPort = devObj.nPort;
    devInfo.nType = devObj.nType;
    strncpy(devInfo.loginName, SZSTR(user), 16);
    strncpy(devInfo.loginPsw, SZSTR(psw), 16);
    FUN_SysChangeDevInfo(self.msgHandle, &devInfo, "", "",(int)[deviceArray indexOfObject:devObj]);
    FUN_DevSetLocalPwd(devInfo.Devmac, [user UTF8String], [psw UTF8String]);
}

#pragma mark - 修改设备密码
- (void)changeDevicePsw:(NSString *)devMac loginName:(NSString *)name password:(NSString *)psw {
    FUN_DevSetLocalPwd(SZSTR(devMac),SZSTR(name), SZSTR(psw));
}

#pragma mark - 删除设备
- (void)deleteDeviceWithDevMac:(NSString *)devMac {
    NSMutableArray *deviceArray = [[DeviceControl getInstance] currentDeviceArray];
    DeviceObject *devObj = [[DeviceControl getInstance] GetDeviceObjectBySN:devMac];
    FUN_SysDelete_Dev(self.msgHandle, [devMac UTF8String], "", "", (int)[deviceArray indexOfObject:devObj]);
}

#pragma mark - 判断是否是主账号
- (void)checkMasterAccount:(NSString *)devMac {
    if (devMac == nil) {
        ChannelObject *channel = [[DeviceControl getInstance] getSelectChannel];
        devMac = channel.deviceMac;
    }
    Fun_SysIsDevMasterAccountFromServer(self.msgHandle, [devMac UTF8String], 0);
}

#pragma mark 获取设备列表和添加设备成功之后放入内存
- (void)resiveDevicelist:(NSMessage *)msg {
    [[DeviceControl getInstance] clearDeviceArray];
    SDBDeviceInfo *pInfos = (SDBDeviceInfo *)[msg obj];
    for(int i = 0; i < [msg param1]; ++i){
        DeviceObject *devObject = [self addDevice:&(pInfos[i])];
        [[DeviceControl getInstance] addDevice:devObject];
    }
    //获取到的数组，和本地已经保存的数组进行对比
    [[DeviceControl getInstance] checkDeviceValid];
}
- (void)addDeviceToList:(NSMessage *)msg {
    SDBDeviceInfo *pDevInfo = (SDBDeviceInfo *)[msg obj];
    DeviceObject *devObject = [self addDevice:pDevInfo];
    [[DeviceControl getInstance] addDevice:devObject];
}


#pragma mark 读取数据、数组中添加设备
- (DeviceObject *)addDevice:(SDBDeviceInfo *)pInfo {
    DeviceObject *devObject = [[DeviceObject alloc] init];
    devObject.deviceMac = [NSString stringWithUTF8String:(pInfo->Devmac)];
    devObject.deviceName = [NSString stringWithUTF8String:(pInfo->Devname)];
    devObject.loginName = [NSString stringWithUTF8String:(pInfo->loginName)];
    devObject.loginPsw = [NSString stringWithUTF8String:(pInfo->loginPsw)];
    devObject.nPort = pInfo->nPort;
    devObject.nType = pInfo->nType;
    return devObject;
}

#pragma mark 获取通道名称数组
- (NSMutableArray *)getChannleFromUserDB:(NSString *)devMac {
    int nChnCount = FUN_GetDevChannelCount(SZSTR(devMac));
    NSMutableArray *channel = [[NSMutableArray alloc] initWithCapacity:0];
    if (nChnCount > 0) {
        for (int i = 0; i < nChnCount; i++) {
            [channel addObject:[NSString stringWithFormat:@"%@%d", TS("Channel"), i + 1]];
        }
    }
    return channel;
}

#pragma mark - 回调 OnFunSDKResult
- (void)OnFunSDKResult:(NSNumber *) pParam {
    NSInteger nAddr = [pParam integerValue];
    MsgContent *msg = (MsgContent *)nAddr;
    switch (msg->id) {
            #pragma mark 添加设备回调
        case EMSG_SYS_ADD_DEVICE:{
            [SVProgressHUD dismiss];
            if (msg->param1 < 0) {
                
                if (msg->param1 == -99992) {
                    if ([NSString checkSSID:[NSString getCurrent_SSID]]) {//直连方式增加设备
                    }else{
                       [MessageUI ShowErrorInt:msg->param1];//非直连增加设备
                    }
                }else{
                    [MessageUI ShowErrorInt:msg->param1];
                }
            }else{
                //添加设备成功
                [SVProgressHUD showSuccessWithStatus:TS("Success")];
                [[DeviceManager getInstance] addDeviceToList:[NSMessage SendMessag:nil obj:msg->pObject p1:msg->param1 p2:0]];
            }
            if (self.delegate && [self.delegate respondsToSelector:@selector(addDeviceResult:)]) {
                [self.delegate addDeviceResult:msg->param1];
            }
        }
            break;
        #pragma mark 获取设备状态回调
        case EMSG_SYS_GET_DEV_STATE:{
            //回调结束刷新
            DeviceObject *devObject = [[DeviceControl getInstance] GetDeviceObjectBySN:NSSTR(msg->szStr)];
            if(devObject != nil){
                //设备状态
                devObject.state = msg->param1;
            }
            if (msg->param1 >0) {
                //获取门铃状态
                 if (devObject.nType == XM_DEV_DOORBELL || devObject.nType == XM_DEV_CAT || devObject.nType == CZ_DOORBELL || devObject.nType == XM_DEV_INTELLIGENT_LOCK || devObject.nType == XM_DEV_DOORBELL_A || devObject.nType == XM_DEV_DOORLOCK_V2) {
                    //下面这个方法在获取设备状态回调后调用准确度最高
                    devObject.info.eFunDevState = FUN_GetDevState(SZSTR(devObject.deviceMac), EFunDevStateType_IDR);
                    NSLog(@"eFunDevState %@ %i",devObject.deviceMac,devObject.info.eFunDevState);
                }
            }
            if (self.delegate && [self.delegate respondsToSelector:@selector(getDeviceState:result:)]) {
                [self.delegate getDeviceState:devObject.deviceMac result:devObject.state];
            }
        }
            break;
             #pragma mark 设备唤醒回调
        case EMSG_DEV_WAKE_UP:{
            //门铃门锁类产品唤醒回调，这类产品根据设备类型不同，无操作一段时间（15/30秒）后可能会自动休眠，所以这一类设备每次操作前最好都能执行一次唤醒功能。如果想要准确实时获取这类设备的休眠状态，那么需要每过一段时间去获取一下。另外门铃门锁等智能唤醒设备，直接按门铃唤醒，会以报警推送的方式发消息给手机，app可以在收到消息后刷新状态
            //回调结束刷新，deviceMac是开始唤醒设备时保存的
                if (self.delegate && [self.delegate respondsToSelector:@selector(deviceWeakUp:result:)]) {
                    [self.delegate deviceWeakUp:deviceMac result:msg->param1];
            }
        }
            break;
        #pragma mark 获取设备通道回调
        case EMSG_DEV_GET_CHN_NAME:{
            DeviceObject *devObject = [[DeviceControl getInstance] GetDeviceObjectBySN:NSSTR(msg->szStr)];
            if (devObject == nil) {
                [SVProgressHUD dismiss];
            }
            //获取通道信息成功并且通道数>0
            if (msg->param1 >= 0 && msg->param3 > 0) {
                SDK_ChannelNameConfigAll *pChannels = (SDK_ChannelNameConfigAll *)msg->pObject;
                NSMutableArray *channelArray = [[NSMutableArray alloc] initWithCapacity:0];
                for (int i = 0; i < msg->param3; i ++) {
                    NSString *str = NSSTR(pChannels->channelTitle[i]);
                    ChannelObject *channel = [[DeviceControl getInstance] addName:str ToDeviceObject:devObject];
                    channel.channelNumber = i;
                    [channelArray addObject: channel];
                }
                devObject.channelArray = [channelArray mutableCopy];
            }
            if (self.delegate &&  [self.delegate respondsToSelector:@selector(getDeviceChannel:result:)]) {
                [self.delegate getDeviceChannel:devObject.deviceMac result:msg->param1];
            }
        }
            break;
        #pragma mark 修改用户信息回调
        case  EMSG_SYS_CHANGEDEVINFO:{   // 修改用户设备信息
            NSMutableArray *deviceArray = [[DeviceControl getInstance] currentDeviceArray];
            if (deviceArray.count <= msg->seq) {
                return;
            }
            DeviceObject *devObject = [deviceArray objectAtIndex:msg->seq];
            if (devObject == nil) {
                return;
            }
            //修改成功，更新一下本地数据
            if (msg->param1 >= 0) {
                SDBDeviceInfo *pDevInfo = (SDBDeviceInfo *)msg->pObject;
                devObject.deviceName = [NSSTR(pDevInfo->Devname) gtm_stringByUnescapingFromHTML];
                devObject.loginPsw = NSSTR(pDevInfo->loginPsw);
                [deviceArray replaceObjectAtIndex:msg->seq withObject:devObject];
                //修改用户信息之后也要重新保存一遍
                [[DeviceControl getInstance] saveDeviceList];
            }
            if (self.delegate &&  [self.delegate respondsToSelector:@selector(changeDevice:changedResult:)]) {
                [self.delegate changeDevice:devObject.deviceMac changedResult:msg->param1];
            }
        }
            break;
            
#pragma mark - 修改密码
        case EMSG_SYS_EDIT_PWD_XM:
        {
            NSLog(@"修改密码成功");
        }
        #pragma mark 删除设备回调
        case EMSG_SYS_DELETE_DEV:{   // 删除设备
            NSMutableArray *deviceArray = [[DeviceControl getInstance] currentDeviceArray];
            if (deviceArray.count <= msg->seq) {
                return;
            }
            DeviceObject *devObject = [deviceArray objectAtIndex:msg->seq];
            if (devObject == nil) {
                return;
            }
            if (msg->param1 >= 0) {
                //收到删除成功信息之后，注销设备报警通知
                [[AlarmManager getInstance] UnlinkAlarm:devObject.deviceMac];
                //删除设备之后需要把数据保存本地一遍
                [deviceArray removeObject:devObject];
                [[DeviceControl getInstance] saveDeviceList];
            }
            //刷新界面
            if (self.delegate && [self.delegate respondsToSelector:@selector(deleteDevice:result:)]) {
                [self.delegate deleteDevice:devObject.deviceMac result:msg->param1];
            }
        }
            break;
        #pragma mark 局域网搜索回调
        case EMSG_DEV_SEARCH_DEVICES:{
            NSMutableArray *searchArray = [[NSMutableArray alloc] initWithCapacity:0];
            if (msg->param1 <= 0) {
                //没有搜索到设备
                [MessageUI ShowErrorInt:msg->param1];
                break;
            }
            [SVProgressHUD dismiss];
            struct SDK_CONFIG_NET_COMMON_V2* netCommonBuf = (struct SDK_CONFIG_NET_COMMON_V2*)msg->pObject;
            for (int i = 0; i < msg->param2; i++) {
                //屏蔽掉地址非法的设备
                if (netCommonBuf[i].HostIP.l == 0 || netCommonBuf[i].TCPPort == 0) {
                    continue;
                }
                DeviceObject *object = [[DeviceObject alloc] init];
                object.deviceMac  = [NSString stringWithUTF8String:netCommonBuf[i].sSn]; //设备序列号
                object.nType = netCommonBuf[i].DeviceType; //设备类型
                if (object.deviceMac == nil || object.deviceMac.length != 16) {
                    //序列号无效的话，改为设置IP
                    object.deviceMac  = [NSString stringWithFormat:@"%d.%d.%d.%d",netCommonBuf[i].HostIP.c[0],netCommonBuf[i].HostIP.c[1],netCommonBuf[i].HostIP.c[2],netCommonBuf[i].HostIP.c[3]];
                }
                object.deviceName = [NSString stringWithUTF8String:netCommonBuf[i].HostName]; //设备名称
                object.deviceIp  = [NSString stringWithFormat:@"%d.%d.%d.%d",netCommonBuf[i].HostIP.c[0],netCommonBuf[i].HostIP.c[1],netCommonBuf[i].HostIP.c[2],netCommonBuf[i].HostIP.c[3]];
                object.loginName = @"admin";
                object.loginPsw = @"";
                object.nPort = netCommonBuf[i].TCPPort;
                if (searchArray.count == 0) {
                    //设备数组为空时不需判断直接添加
                    [searchArray addObject:object];
                    continue;
                }
                BOOL find = NO;
                for (DeviceObject *device in searchArray) {
                    if ([device.deviceMac isEqualToString:object.deviceMac]) {
                        find = YES;
                    }
                }
                if (find == NO) {
                    //如果不包含则添加设备
                    [searchArray addObject:object];
                }
            }
            if (self.delegate && [self.delegate respondsToSelector:@selector(searchDevice:result:)]) {
                //局域网设备 搜索结果回调
                [self.delegate searchDevice:searchArray result:msg->param1];
            }
        }
            break;
        #pragma mark 快速配置回调
        case EMSG_DEV_AP_CONFIG:
        {
            if (msg->param1 <= 0) {
                //没有搜索到设备
                [MessageUI ShowErrorInt:msg->param1];
                break;
            }
            [SVProgressHUD dismiss];
            DeviceObject *object = [[DeviceObject alloc] init];
            SDK_CONFIG_NET_COMMON_V2 *pCfg = (SDK_CONFIG_NET_COMMON_V2 *)msg->pObject;
            NSString* devSn = @"";
            NSString* name = @"";
            int nDevType = 0;
            int nResult = msg->param1;
            if ( nResult>=0 && pCfg) {
                name = NSSTR(pCfg->HostName);
                devSn = NSSTR(pCfg->sSn);
                nDevType = pCfg->DeviceType;
            }
            object.deviceMac = devSn;
            object.nType = nDevType;
            object.deviceName = name;
            if (self.delegate && [self.delegate respondsToSelector:@selector(quickConfiguration:result:)] ) {
                [self.delegate quickConfiguration:object result:msg->param1];
            }
        }
            break;
        case EMSG_DEV_SET_WIFI_CFG:
        {
            NSLog(@"");
        }
            break;
            #pragma mark 判断是否是主账号回调
        case EMSG_SYS_IS_MASTERMA: {
            if ([self.delegate respondsToSelector:@selector(checkMaster:Result:)]) {
                [self.delegate checkMaster:nil Result:msg->param1];
            }
        }
        default:
            break;
    }
}
@end
