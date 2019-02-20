#pragma once
#import "FunSDK/JObject.h"

#define JK_AlarmFunction "AlarmFunction" 
class AlarmFunction : public JObject
{
public:
	JBoolObj		AlarmConfig;
	JBoolObj		BlindDetect;
	JBoolObj		IPCAlarm;
	JBoolObj		LossDetect;
	JBoolObj		MotionDetect;
	JBoolObj		NetAbort;
	JBoolObj		NetAbortExtend;
	JBoolObj		NetAlarm;
	JBoolObj		NetIpConflict;
	JBoolObj		NewVideoAnalyze;
	JBoolObj		PIRAlarm;
	JBoolObj		SerialAlarm;
	JBoolObj		StorageFailure;
	JBoolObj		StorageLowSpace;
	JBoolObj		StorageNotExist;
    JBoolObj        Consumer433Alarm;
	JBoolObj		VideoAnalyze;
    

public:
    AlarmFunction(JObject *pParent = NULL, const char *szName = JK_AlarmFunction):
    JObject(pParent,szName),
	AlarmConfig(this, "AlarmConfig"),
	BlindDetect(this, "BlindDetect"),
	IPCAlarm(this, "IPCAlarm"),
	LossDetect(this, "LossDetect"),
	MotionDetect(this, "MotionDetect"),
	NetAbort(this, "NetAbort"),
	NetAbortExtend(this, "NetAbortExtend"),
	NetAlarm(this, "NetAlarm"),
	NetIpConflict(this, "NetIpConflict"),
	NewVideoAnalyze(this, "NewVideoAnalyze"),
	PIRAlarm(this, "PIRAlarm"),
	SerialAlarm(this, "SerialAlarm"),
	StorageFailure(this, "StorageFailure"),
	StorageLowSpace(this, "StorageLowSpace"),
	StorageNotExist(this, "StorageNotExist"),
    Consumer433Alarm(this, "Consumer433Alarm"),
	VideoAnalyze(this, "VideoAnalyze"){
	};

    ~AlarmFunction(void){};
};
