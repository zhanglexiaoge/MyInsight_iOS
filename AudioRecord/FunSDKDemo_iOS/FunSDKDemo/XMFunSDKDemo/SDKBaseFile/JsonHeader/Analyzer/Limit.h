#pragma once
#import "FunSDK/JObject.h"

#define JK_Limit "Limit" 
class Limit : public JObject
{
public:
	JIntObj		MinDist; //最小像素距离
	JIntObj		MinTime; //最短时间

public:
    Limit(JObject *pParent = NULL, const char *szName = JK_Limit):
    JObject(pParent,szName),
	MinDist(this, "MinDist"),
	MinTime(this, "MinTime"){
	};

    ~Limit(void){};
};
