#pragma once
#import "FunSDK/FunSDK.h"

#define JK_NetWork_Wifi "NetWork.Wifi" 
class NetWork_Wifi : public JObject
{
public:
	JStrObj		Auth;    //加密方式
	JIntObj		Channel;   //通道号
	JBoolObj	Enable;    //使能开关
	JStrObj		EncrypType; //加密算法
	JStrObj		GateWay;  // 网关
	JStrObj		HostIP;   // IP
	JIntObj		KeyType;  // 密匙保存方式
	JStrObj		Keys;    // 密码
	JStrObj		NetType;  //网络类型
	JStrObj		SSID;    //Wi-Fi名称
	JStrObj		Submask;  //子网掩码

public:
    NetWork_Wifi(JObject *pParent = NULL, const char *szName = JK_NetWork_Wifi):
    JObject(pParent,szName),
	Auth(this, "Auth"),
	Channel(this, "Channel"),
	Enable(this, "Enable"),
	EncrypType(this, "EncrypType"),
	GateWay(this, "GateWay"),
	HostIP(this, "HostIP"),
	KeyType(this, "KeyType"),
	Keys(this, "Keys"),
	NetType(this, "NetType"),
	SSID(this, "SSID"),
	Submask(this, "Submask"){
	};

    ~NetWork_Wifi(void){};
};
