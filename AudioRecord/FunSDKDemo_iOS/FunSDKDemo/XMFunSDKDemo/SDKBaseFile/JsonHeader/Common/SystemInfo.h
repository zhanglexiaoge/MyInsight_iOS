#pragma once
#include "FunSDK/JObject.h"
#define JK_SystemInfo "SystemInfo"
class SystemInfo : public JObject //关于设备硬件软件版本信息等等设备信息头文件
{
public:
	JIntObj		AlarmInChannel;
	JIntObj		AlarmOutChannel;
	JIntObj		AudioInChannel;
	JStrObj		BuildTime;
	JIntObj		CombineSwitch;
	JIntHex		DeviceRunTime;
	JIntObj		DigChannel;
	JStrObj		EncryptVersion;
	JIntObj		ExtraChannel;
	JStrObj		HardWare;
	JStrObj		HardWareVersion;
	JStrObj		SerialNo;
	JStrObj		SoftWareVersion;
	JIntObj		TalkInChannel;
	JIntObj		TalkOutChannel;
	JStrObj		UpdataTime;
	JIntHex		UpdataType;
	JIntObj		VideoInChannel;
	JIntObj		VideoOutChannel;

public:
	SystemInfo(JObject *pParent = NULL, const char *szName = JK_SystemInfo):
	JObject(pParent,szName),
	AlarmInChannel(this, "AlarmInChannel"),
	AlarmOutChannel(this, "AlarmOutChannel"),
	AudioInChannel(this, "AudioInChannel"),
	BuildTime(this, "BuildTime"),
	CombineSwitch(this, "CombineSwitch"),
	DeviceRunTime(this, "DeviceRunTime"),
	DigChannel(this, "DigChannel"),
	EncryptVersion(this, "EncryptVersion"),
	ExtraChannel(this, "ExtraChannel"),
	HardWare(this, "HardWare"),
	HardWareVersion(this, "HardWareVersion"),
	SerialNo(this, "SerialNo"),
	SoftWareVersion(this, "SoftWareVersion"),
	TalkInChannel(this, "TalkInChannel"),
	TalkOutChannel(this, "TalkOutChannel"),
	UpdataTime(this, "UpdataTime"),
	UpdataType(this, "UpdataType"),
	VideoInChannel(this, "VideoInChannel"),
	VideoOutChannel(this, "VideoOutChannel"){
	};

	~SystemInfo(void){};
};
