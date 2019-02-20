#pragma once
#include "FunSDK/JObject.h"
//录像配置
#define JK_Record "Record" 
class Record : public JObject
{
public:
	JObjArray<JObjArray<JIntHex> > Mask; //周一到周日7天里面每一天的录像配置，每天包含6段自定义配置，并且和下面的6段一一对应，如果设置全天可以只设置每天第一段包含全天
	JIntObj		PacketLength; //录像时间
	JIntObj		PreRecord; //预录时间
	JStrObj		RecordMode;//录像状态
	JBoolObj		Redundancy;//冗余开关
	JObjArray<JObjArray<JStrObj> >    TimeSection; //周一到周日7天里每天的录像配置，每天包含6段自定义时间

public:
    Record(JObject *pParent = NULL, const char *szName = JK_Record):
    JObject(pParent,szName),
	Mask(this, "Mask"),
	PacketLength(this, "PacketLength"),
	PreRecord(this, "PreRecord"),
	RecordMode(this, "RecordMode"),
	Redundancy(this, "Redundancy"),
	TimeSection(this, "TimeSection"){
	};

    ~Record(void){};
};
