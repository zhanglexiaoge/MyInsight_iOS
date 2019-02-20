#pragma once
#include "FunSDK/JObject.h"
#include "EncodeInfo.h"
#include "CombEncodeInfo.h"
#define JK_ability "ability" 
class ability : public JObject
{
public:
    JIntObj        ChannelMaxSetSync;
    JObjArray<CombEncodeInfo>        CombEncodeInfo;
    JObjArray<EncodeInfo>        EncodeInfo;
    JObjArray<JIntHex>        ExImageSizePerChannel;
    JObjArray<JObjArray<JIntHex> >    ExImageSizePerChannelEx;
    JObjArray<JIntHex>        ImageSizePerChannel;
    JIntObj        MaxBitrate;
    JIntObj        MaxEncodePower;
    JObjArray<JIntHex>        MaxEncodePowerPerChannel;


public:
    ability(JObject *pParent = NULL, const char *szName = JK_ability):
    JObject(pParent,szName),
    ChannelMaxSetSync(this, "ChannelMaxSetSync"),
    CombEncodeInfo(this, "CombEncodeInfo"),
    EncodeInfo(this, "EncodeInfo"),
    ExImageSizePerChannel(this, "ExImageSizePerChannel"),
    ExImageSizePerChannelEx(this, "ExImageSizePerChannelEx"),
    ImageSizePerChannel(this, "ImageSizePerChannel"),
    MaxBitrate(this, "MaxBitrate"),
    MaxEncodePower(this, "MaxEncodePower"),
    MaxEncodePowerPerChannel(this, "MaxEncodePowerPerChannel"){
    };

    ~ability(void){};
};
