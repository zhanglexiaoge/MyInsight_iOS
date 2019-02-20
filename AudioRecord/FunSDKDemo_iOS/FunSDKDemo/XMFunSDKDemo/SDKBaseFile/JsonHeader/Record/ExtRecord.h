#pragma once
#include "FunSDK/JObject.h"
//辅码流录像配置，同Record一致
#define JK_ExtRecord "ExtRecord" 
class ExtRecord : public JObject
{
public:
	JObjArray<JObjArray<JIntHex> > Mask;
	JIntObj		PacketLength;
	JIntObj		PreRecord;
	JStrObj		RecordMode;
	JBoolObj		Redundancy;
	JObjArray<JObjArray<JStrObj> >    TimeSection;

public:
    ExtRecord(JObject *pParent = NULL, const char *szName = JK_ExtRecord):
    JObject(pParent,szName),
	Mask(this, "Mask"),
	PacketLength(this, "PacketLength"),
	PreRecord(this, "PreRecord"),
	RecordMode(this, "RecordMode"),
	Redundancy(this, "Redundancy"),
	TimeSection(this, "TimeSection"){
	};

    ~ExtRecord(void){};
};
