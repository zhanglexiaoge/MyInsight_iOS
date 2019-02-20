#pragma once
#include "FunSDK/JObject.h"
#include "ChannelTitle.h"
#include "ChannelTitleAttribute.h"
#include "TimeTitleAttribute.h"

#define JK_AVEnc_VideoWidget "AVEnc.VideoWidget"
class AVEnc_VideoWidget : public JObject
{
public:
    ChannelTitle		mChannelTitle;
    ChannelTitleAttribute		mChannelTitleAttribute;
    JObjArray<JObject>		Covers;
    JIntObj		CoversNum;
    TimeTitleAttribute		mTimeTitleAttribute;
    
public:
    AVEnc_VideoWidget(JObject *pParent = NULL, const char *szName = JK_AVEnc_VideoWidget):
    JObject(pParent,szName),
    mChannelTitle(this, "ChannelTitle"),
    mChannelTitleAttribute(this, "ChannelTitleAttribute"),
    Covers(this, "Covers"),
    CoversNum(this, "CoversNum"),
    mTimeTitleAttribute(this, "TimeTitleAttribute"){
    };
    
    ~AVEnc_VideoWidget(void){};
};
