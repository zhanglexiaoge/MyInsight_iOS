#pragma once
#include "FunSDK/JObject.h"

#define JK_StorageGlobal "StorageGlobal"
class StorageGlobal : public JObject
{
public:
    JBoolObj		KeyOverWrite;
    
public:
    StorageGlobal(JObject *pParent = NULL, const char *szName = JK_StorageGlobal):
    JObject(pParent,szName),
    KeyOverWrite(this, "KeyOverWrite"){
    };
    
    ~StorageGlobal(void){};
};
