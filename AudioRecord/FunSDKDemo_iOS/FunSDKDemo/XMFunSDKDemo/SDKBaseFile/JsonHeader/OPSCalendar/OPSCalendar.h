#pragma once
#include "FunSDK/JObject.h"

//查询设备存储中的文件
#define JK_OPSCalendar "OPSCalendar" 
class OPSCalendar : public JObject
{
public:
	JIntObj		Mask;//二进制，每一位里面的1代表有，0代表没有

public:
    OPSCalendar(JObject *pParent = NULL, const char *szName = JK_OPSCalendar):
    JObject(pParent,szName),
	Mask(this, "Mask"){
	};

    ~OPSCalendar(void){};
};
