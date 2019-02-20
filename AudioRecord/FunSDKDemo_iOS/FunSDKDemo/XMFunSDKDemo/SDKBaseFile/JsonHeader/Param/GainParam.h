#pragma once
#include "FunSDK/JObject.h"

#define JK_GainParam "GainParam" 
class GainParam : public JObject
{
public:
	JIntObj		AutoGain;
	JIntObj		Gain;

public:
	GainParam(JObject *pParent = NULL, const char *szName = JK_GainParam):
	JObject(pParent,szName),
	AutoGain(this, "AutoGain"),
	Gain(this, "Gain"){
	};

	~GainParam(void){};
};
