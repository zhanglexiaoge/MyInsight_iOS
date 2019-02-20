#pragma once
#include "FunSDK/JObject.h"

#define JK_Partition "Partition" 
class Partition : public JObject   //硬盘相关
{
public:
	JIntObj		DirverType;
	JBoolObj		IsCurrent;
	JIntObj		LogicSerialNo;
	JStrObj		NewEndTime;
	JStrObj		NewStartTime;
	JStrObj		OldEndTime;
	JStrObj		OldStartTime;
	JIntHex		RemainSpace;
	JIntObj		Status;
	JIntHex		TotalSpace;

public:
	Partition(JObject *pParent = NULL, const char *szName = JK_Partition):
	JObject(pParent,szName),
	DirverType(this, "DirverType"),
	IsCurrent(this, "IsCurrent"),
	LogicSerialNo(this, "LogicSerialNo"),
	NewEndTime(this, "NewEndTime"),
	NewStartTime(this, "NewStartTime"),
	OldEndTime(this, "OldEndTime"),
	OldStartTime(this, "OldStartTime"),
	RemainSpace(this, "RemainSpace"),
	Status(this, "Status"),
	TotalSpace(this, "TotalSpace"){
	};

	~Partition(void){};
};
