#pragma once
#import "FunSDK/JObject.h"

#define JK_PreviewFunction "PreviewFunction" 
class PreviewFunction : public JObject
{
public:
	JBoolObj		GUISet;
	JBoolObj		Tour;

public:
    PreviewFunction(JObject *pParent = NULL, const char *szName = JK_PreviewFunction):
    JObject(pParent,szName),
	GUISet(this, "GUISet"),
	Tour(this, "Tour"){
	};

    ~PreviewFunction(void){};
};
