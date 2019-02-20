#pragma once
#include "FunSDK/JObject.h"

#define JK_ExposureParam "ExposureParam" 
class ExposureParam : public JObject //曝光
{
public:
	JIntHex		LeastTime;
	JIntObj		Level;
	JIntHex		MostTime;

public:
	ExposureParam(JObject *pParent = NULL, const char *szName = JK_ExposureParam):
	JObject(pParent,szName),
	LeastTime(this, "LeastTime"),
	Level(this, "Level"),
	MostTime(this, "MostTime"){
	};

	~ExposureParam(void){};
};
