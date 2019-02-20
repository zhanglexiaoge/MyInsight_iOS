#pragma once
#import "FunSDK/JObject.h"

#define JK_InputMethod "InputMethod" 
class InputMethod : public JObject
{
public:
	JBoolObj		NoSupportChinese;

public:
    InputMethod(JObject *pParent = NULL, const char *szName = JK_InputMethod):
    JObject(pParent,szName),
	NoSupportChinese(this, "NoSupportChinese"){
	};

    ~InputMethod(void){};
};
