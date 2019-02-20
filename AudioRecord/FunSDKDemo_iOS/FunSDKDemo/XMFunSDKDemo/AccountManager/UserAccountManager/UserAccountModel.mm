//
//  UserAccountModel.m
//  MobileVideo
//
//  Created by XM on 2018/4/23.
//  Copyright © 2018年 XM. All rights reserved.
//
#import "FunSDK/FunSDK.h"

#import "UserAccountModel.h"
#import "DeviceManager.h"
@implementation UserAccountModel
- (id)init {
    self = [super init];
    if (self) {
        [self loginOut];
    }
    return self;
}
#pragma mark 用户名登陆
- (void)loginWithName:(NSString *)userName andPassword:(NSString *)psw {
    //初始化将要链接的服务器信息（没有回调）
    FUN_SysInit("arsp.xmeye.net;arsp1.xmeye.net;arsp2.xmeye.net", 15010);
    //初始化底层库Net网络相关（没有回调）
    FUN_InitNetSDK();
    
    //账号登陆接口（有回调） self.msgHandle(model句柄，区分是哪一个model)
    FUN_SysGetDevList(self.msgHandle, SZSTR(userName) , SZSTR(psw),0);
    
    //暂存登陆模式
    [[LoginShowControl getInstance] setLoginType:loginTypeCloud];
    //云登陆需要暂存登陆账号密码
    [[LoginShowControl getInstance] setLoginUserName:userName password:psw];
    
    [self initLogServer];
}

- (void)loginWithTypeLocal {
    //初始化底层库Net网络相关（没有回调）
    FUN_InitNetSDK();
    
    FUN_SysInit([[NSString GetDocumentPathWith:@"LocalDB.db"] UTF8String]);
    //Fun_SysAddDevByFile(self.msgHandle, [[NSString GetCachesPathWith:@"LocalDB.db"] UTF8String],0);
    FUN_SysGetDevList(self.msgHandle,"" ,"",0);
    //设置登陆模式
    [[LoginShowControl getInstance] setLoginType:loginTypeLocal];
    
    [self initLogServer];
}

- (void)initLogServer{
    NSString *serverIP;
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    serverIP=[userDefault objectForKey:@"LOG_SERVER_IP"];
    if (serverIP == nil || [serverIP length] <= 0) {
        serverIP = @"123.59.14.61";
        [userDefault setObject:serverIP forKey:@"LOG_SERVER_IP"];
    }
    
    NSString *serverPort;
    serverPort=[userDefault objectForKey:@"LOG_SERVER_PORT"];
    if (serverPort == nil || [serverPort length] <= 0) {
        serverPort=@"9911";
        [userDefault setObject:serverPort forKey:@"LOG_SERVER_PORT"];
    }
    
    NSString *nType;
    nType=[userDefault objectForKey:@"LOG_SERVER_TYPE"];
    if (nType == nil || [nType length]<= 0) {
        nType=@"3";
        [userDefault setObject:nType forKey:@"LOG_SERVER_TYPE"];
    }
    
    NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [pathArray lastObject];
    path = [path stringByAppendingPathComponent:@"log.txt"];
    const char *logFile = [path UTF8String];
    FunMsgListener *listener = [[FunMsgListener alloc]init];
    Fun_LogInit(listener.msgHandle, [serverIP UTF8String], [serverPort intValue], logFile, [nType intValue]);
    
}

- (void)loginWithTypeAP {
    FUN_InitNetSDK();
    FUN_SysInitAsAPModel([[NSString GetDocumentPathWith:@"SSID"] UTF8String]);
    SDBDeviceInfo devInfo = {0};
    NSData* gb2312data = [NSString AutoCopyUTF8Str:[NSString getCurrent_SSID]];
    [gb2312data getBytes:devInfo.Devname length:sizeof(devInfo.Devname)];
    STRNCPY(devInfo.loginName, SZSTR(@"admin"));
    STRNCPY(devInfo.loginPsw, SZSTR(@""));
    // 判断直连设备的类型
    NSString *sid = [NSString getCurrent_SSID];
    if ([sid hasPrefix:@"socket"]) {
        devInfo.nType = 1;
        devInfo.nPort = 9001;
        strcpy(devInfo.Devmac, "172.16.10.1:9001");
    }
    else{
        devInfo.nType = 0;
        devInfo.nPort = 34567;
        strcpy(devInfo.Devmac, "192.168.10.1:34567");
    }
    FUN_SysAdd_Device(self.msgHandle, &devInfo);
    
    FUN_SysGetDevList(self.msgHandle, "", "",0);
    
    //设置登陆模式
    [[LoginShowControl getInstance] setLoginType:loginTypeAP];
}

#pragma mark 登出  login out
- (void)loginOut {
    // clean up SDK
    FUN_UnInitNetSDK();
}

#pragma mark 通过邮箱或者手机号获取验证码
- (void)getCodeWithPhoneOrEmailNumber:(NSString *)phoneEmail {
    if ([phoneEmail containsString:@"@"]) {
        //获取邮箱验证码
        FUN_SysSendEmailCode(self.msgHandle, [phoneEmail UTF8String], 0);
    }else{
        //获取手机验证码
        FUN_SysSendPhoneMsg(self.msgHandle, [@"" UTF8String], [phoneEmail UTF8String], 0);
    }
}
#pragma mark 通过邮箱或者手机号注册，直接注册的话，code和手机号邮箱设置为空""
- (void)registerUserName:(NSString *)username password:(NSString *)psw code:(NSString *)code PhoneOrEmail:(NSString *)phoneEmail {
    FUN_SysRegUserToXM(self.msgHandle, [username UTF8String], [psw UTF8String], [code UTF8String], [phoneEmail  UTF8String], 0);
}
#pragma mark 忘记密码 获取验证码
-(int)fogetPwdWithPhoneNum:(NSString *)phoneNum{
    if ([phoneNum containsString:@"@"]) {
        //该邮箱是否已经注册
      return FUN_SysSendCodeForEmail(self.msgHandle, [phoneNum UTF8String], 0);
    }else{
        //该手机号是否已经注册
        return FUN_SysForgetPwdXM(self.msgHandle, [phoneNum UTF8String], 0);
    }

}

#pragma mark 修改用户密码
- (void)changePassword:(NSString *)userName oldPassword:(NSString *)oldPsw newPsw:(NSString *)newPsw {
    FUN_SysPsw_Change(self.msgHandle, [userName UTF8String], [oldPsw UTF8String], [newPsw UTF8String]);
}

#pragma mark 检查验证码的合法性,找回密码之前需要验证
- (void)checkCode:(NSString *)phoneEmail code:(NSString *)code {
    if ([phoneEmail containsString:@"@"]) {
        //邮箱验证码合法性
        FUN_SysCheckCodeForEmail(self.msgHandle, [phoneEmail UTF8String], [code UTF8String],  0);
    }else{
        //手机验证码合法性
        FUN_CheckResetCodeXM(self.msgHandle, [phoneEmail UTF8String], [code UTF8String],  0);
    }
}
#pragma mark 找回用户登录密码
- (void)resetPassword:(NSString *)phoneEmail newPassword:(NSString *)psw {
    if ([phoneEmail containsString:@"@"]) {
        //通过邮箱进行重置
        FUN_SysChangePwdByEmail(self.msgHandle, [phoneEmail UTF8String], [psw UTF8String],  0);
    }else{
        //通过手机进行重置
        FUN_ResetPwdXM(self.msgHandle, [phoneEmail UTF8String], [psw UTF8String],  0);
    }
}

#pragma mark 请求账户信息（是否绑定手机号或者邮箱）
- (void)requestAccountInfo
{
    FUN_SysGetUerInfo(self.msgHandle, "", "", 0);
}

#pragma mark 获取验证码 (绑定手机号或者邮箱需要)
- (void)getBindingPhoneEmailCode:(NSString *)username password:(NSString *)psw PhoneOrEmail:(NSString *)phoneEmail
{
    if ([phoneEmail containsString:@"@"]) {
        //通过邮箱获取验证码
        FUN_SysSendBindingEmailCode(self.msgHandle, [phoneEmail UTF8String], [username UTF8String], [psw UTF8String], 0);
    }
    else{
        //通过手机获取验证码
        FUN_SysSendBindingPhoneCode(self.msgHandle,[phoneEmail UTF8String], [username UTF8String], [psw UTF8String], 0);
    }
}

#pragma mark 绑定手机或者邮箱
- (void)bindPhoneEmail:(NSString *)username password:(NSString *)psw PhoneOrEmail:(NSString *)phoneEmail code:(NSString *)code
{
    if ([phoneEmail containsString:@"@"]) {
        //绑定邮箱
        FUN_SysBindingEmail(self.msgHandle, [username UTF8String], [psw UTF8String], [phoneEmail UTF8String], [code UTF8String], 0);
    }
    else{
        //绑定手机
        FUN_SysBindingPhone(self.msgHandle , [username UTF8String],  [psw UTF8String], [phoneEmail UTF8String], [code UTF8String], 0);
    }
    
}

#pragma mark - 网络请求回调接口 有回调信息的所有FUN接口都会回调进这个方法
- (void)OnFunSDKResult:(NSNumber *) pParam {
    NSInteger nAddr = [pParam integerValue];
    MsgContent *msg = (MsgContent *)nAddr;
    switch (msg->id) {
#pragma mark  账号登陆结果回调信息
        case EMSG_SYS_GET_DEV_INFO_BY_USER:{
            if (msg->param1 < 0){
                //用户名登录失败，根据错误信息msg->param1判断错误类型
                if (msg->param1 == EE_PASSWORD_NOT_VALID)
                {
                    //密码错误示例
                }
            }else{
                //用户名登录成功，返回用户名下的设备列表信息
                [[DeviceManager getInstance]  resiveDevicelist:[NSMessage SendMessag:nil obj:msg->pObject p1:msg->param1 p2:0]];
            }
            //用户登录回调
            if ([self.delegate respondsToSelector:@selector(loginWithNameDelegate:)]) {
                [self.delegate loginWithNameDelegate:msg->param1];
            }
        }
            break;
        case EMSG_SYS_ADD_DEV_BY_FILE:{
            //本地登录
            FUN_SysGetDevList(self.msgHandle, "", "");
        }
#pragma mark 收到通过邮箱注册账户结果消息
        case EMSG_SYS_REGISTE_BY_EMAIL:
#pragma mark 收到通过手机注册账户结果消息
        case EMSG_SYS_REGISER_USER_XM:
#pragma mark 收到直接注册账户结果消息
        case EMSG_SYS_NO_VALIDATED_REGISTER_EXTEND:
        {
            if (msg->param1 >=0) {
                //注册成功
            }else{
                //注册失败，错误信息msg->param1
            }
            //用户注册回调
            if ([self.delegate respondsToSelector:@selector(registerUserNameDelegateResult:)]) {
                [self.delegate registerUserNameDelegateResult:msg->param1];
            }
        }
            break;
            
#pragma mark 获取验证码结果
        case EMSG_SYS_SEND_EMAIL_CODE:
        case EMSG_SYS_GET_PHONE_CHECK_CODE:{
            if (msg->param1 >= 0) {
                //获取验证码成功，手机或者邮箱将会收到验证码
            }else{
                //获取验证码失败，可以选择是否跳过验证码直接进行注册
                if(msg->param1 !=EE_AS_PHONE_CODE2&&msg->param1!=EE_AS_SEND_EMAIL_CODE3){
                    //手机号或者邮箱已经被注册
                }
            }
            //获取验证码回调
            if ([self.delegate respondsToSelector:@selector(getCodeDelegateResult:)]) {
                [self.delegate getCodeDelegateResult:msg->param1];
            }
        }
            break;
#pragma mark 忘记密码 收到验证码（邮箱\手机）
        case EMSG_SYS_SEND_EMAIL_FOR_CODE:
        case EMSG_SYS_FORGET_PWD_XM:
        {
            if (msg->param1 >= 0) {
                //获取验证码成功，手机或者邮箱将会收到验证码
            }else{
                //获取验证码失败
            }
            //获取验证码回调
            if ([self.delegate respondsToSelector:@selector(forgetPwdGetCodeDelegateResult:userName:)]) {
                [self.delegate forgetPwdGetCodeDelegateResult:msg->param1 userName:[NSString stringWithUTF8String:msg->szStr]];
            }
        }
            break;
#pragma mark 手机号和邮箱验证码校验回调
        case EMSG_SYS_CHECK_CODE_FOR_EMAIL:
        case EMSG_SYS_REST_PWD_CHECK_XM:
        {
            [SVProgressHUD dismiss];
            if (msg->param1 < 0) {
                //验证码校验失败
            }else{
                //验证码校验成功
            }
            //验证码校验合法性回调
            if ([self.delegate respondsToSelector:@selector(checkCodeDelegateResult:)]) {
                [self.delegate checkCodeDelegateResult:msg->param1];
            }
        }
            break;
            
#pragma mark 通过邮箱和手机号找回密码回调
        case  EMSG_SYS_PSW_CHANGE_BY_EMAIL:
        case  EMSG_SYS_RESET_PWD_XM:
        {
            if (msg->param1 < 0) {
                //修改密码失败
            }else{
                //回调成功，找回密码成功，已经修改为新的密码
            }
            //找回密码重置密码回调
            if ([self.delegate respondsToSelector:@selector(resetPasswordDelegateResult:)]) {
                [self.delegate resetPasswordDelegateResult:msg->param1];
            }
        }
            break;
            
#pragma mark 修改密码结果
        case EMSG_SYS_PSW_CHANGE:
        {
            [SVProgressHUD dismiss];
            if (msg->param1 < 0){
                //修改密码失败
            }else{
                //修改密码成功
            }
            //修改密码回调
            if ([self.delegate respondsToSelector:@selector(changePasswordDelegateResult:)]) {
                [self.delegate changePasswordDelegateResult:msg->param1];
            }
        }
            break;
#pragma mark 请求账户信息（是否绑定手机号或者邮箱）
        case EMSG_SYS_GET_USER_INFO:
        {
            [SVProgressHUD dismiss];
            NSMutableDictionary *userInfoDic = [[NSMutableDictionary alloc] init];
            if(msg->param1 >= 0)
            {
                char *result = (char *)msg->szStr;
                // 将c的jason字符串转化为NSData
                NSData *resultData = [NSData dataWithBytes:result length:strlen(result)];
                
                // 将NSData转化为字典
                NSError *error;
                userInfoDic = (NSMutableDictionary*)[NSJSONSerialization JSONObjectWithData:resultData options:NSJSONReadingMutableLeaves error:&error];
            
            }
            
            if ([self.delegate respondsToSelector:@selector(getUserInfo:result:)]) {
                [self.delegate getUserInfo:userInfoDic result:msg->param1];
            }
        }
            break;
#pragma mark 获取验证码回调（绑定邮箱/手机）
        case EMSG_SYS_SEND_BINDING_EMAIL_CODE:
        case EMSG_SYS_SEND_BINDING_PHONE_CODE:
        {
            [SVProgressHUD dismiss];
            if (msg->param1 < 0){
                //获取验证码失败
            }else{
                //获取验证码成功
            }
            //获取验证码回调
            if ([self.delegate respondsToSelector:@selector(getCodeForBindPhoneEmailResult:)]) {
                [self.delegate getCodeForBindPhoneEmailResult:msg->param1];
            }
        }
            break;
#pragma mark 绑定邮箱/手机回调
        case EMSG_SYS_BINDING_EMAIL:
        case EMSG_SYS_BINDING_PHONE:
        {
            [SVProgressHUD dismiss];
            if (msg->param1 < 0){
                //绑定邮箱/手机失败
            }else{
                //绑定邮箱/手机成功
            }
            //修改密码回调
            if ([self.delegate respondsToSelector:@selector(bindPhoneEmailResult:)]) {
                [self.delegate bindPhoneEmailResult:msg->param1];
            }
        }
            break;
        default:
            break;
    }
}

@end
