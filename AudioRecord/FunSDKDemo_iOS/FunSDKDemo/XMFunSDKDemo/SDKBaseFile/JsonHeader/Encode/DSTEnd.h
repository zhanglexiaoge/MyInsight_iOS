#pragma once
#include "FunSDK/JObject.h"

#define JK_DSTEnd "DSTEnd" 
class DSTEnd : public JObject
{
public:
	JIntObj		Day;
	JIntObj		Hour;
	JIntObj		Minute;
	JIntObj		Month;
	JIntObj		Week;
	JIntObj		Year;

public:
	DSTEnd(JObject *pParent = NULL, const char *szName = JK_DSTEnd):
	JObject(pParent,szName),
	Day(this, "Day"),
	Hour(this, "Hour"),
	Minute(this, "Minute"),
	Month(this, "Month"),
	Week(this, "Week"),
	Year(this, "Year"){
	};

	~DSTEnd(void){};
};
