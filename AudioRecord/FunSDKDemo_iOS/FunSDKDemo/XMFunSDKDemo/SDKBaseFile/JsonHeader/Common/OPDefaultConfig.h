#pragma once
#import <FunSDK/JObject.h>

#define JK_OPDefaultConfig "OPDefaultConfig" 
class OPDefaultConfig : public JObject
{
public:
	JIntObj		General;
	JIntObj		Encode;
	JIntObj		Record;
	JIntObj		CommPtz;
	JIntObj		NetServer;
	JIntObj		NetCommon;
	JIntObj		Alarm;
	JIntObj		Account;
	JIntObj		Preview;
	JIntObj		CameraPARAM;

public:
    OPDefaultConfig(JObject *pParent = NULL, const char *szName = JK_OPDefaultConfig):
    JObject(pParent,szName),
	General(this, "General"),
	Encode(this, "Encode"),
	Record(this, "Record"),
	CommPtz(this, "CommPtz"),
	NetServer(this, "NetServer"),
	NetCommon(this, "NetCommon"),
	Alarm(this, "Alarm"),
	Account(this, "Account"),
	Preview(this, "Preview"),
	CameraPARAM(this, "CameraPARAM"){
	};

    ~OPDefaultConfig(void){};
};
