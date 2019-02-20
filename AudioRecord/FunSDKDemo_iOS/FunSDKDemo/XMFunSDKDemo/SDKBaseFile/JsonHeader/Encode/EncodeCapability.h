#pragma once
#include "FunSDK/JObject.h"
#include "EncodeInfo.h"
#include "CombEncodeInfo.h"
#define JK_EncodeCapability "EncodeCapability"
//模拟通道编码配置能力级
class EncodeCapability : public JObject
{
public:
	JIntObj		ChannelMaxSetSync;
	JObjArray<CombEncodeInfo>		CombEncodeInfo;
	JIntHex		Compression;
	JObjArray<EncodeInfo>		EncodeInfo;
	JObjArray<JIntHex>		ExImageSizePerChannel;
	JObjArray<JObjArray<JIntHex> >	ExImageSizePerChannelEx;
	JObjArray<JIntHex>		FourthStreamImageSize;
	JObjArray<JIntHex>		FrameRateMask;
	JObjArray<JIntHex>		ImageSizePerChannel;
	JIntObj		MaxBitrate;
	JIntObj		MaxEncodePower;
	JObjArray<JIntHex>		MaxEncodePowerPerChannel;
	JObjArray<JIntHex>		ThirdStreamImageSize;

public:
    EncodeCapability(JObject *pParent = NULL, const char *szName = JK_EncodeCapability):
    JObject(pParent,szName),
	ChannelMaxSetSync(this, "ChannelMaxSetSync"),
	CombEncodeInfo(this, "CombEncodeInfo"),
	Compression(this, "Compression"),
	EncodeInfo(this, "EncodeInfo"),
	ExImageSizePerChannel(this, "ExImageSizePerChannel"),
	ExImageSizePerChannelEx(this, "ExImageSizePerChannelEx"),
	FourthStreamImageSize(this, "FourthStreamImageSize"),
	FrameRateMask(this, "FrameRateMask"),
	ImageSizePerChannel(this, "ImageSizePerChannel"),
	MaxBitrate(this, "MaxBitrate"),
	MaxEncodePower(this, "MaxEncodePower"),
	MaxEncodePowerPerChannel(this, "MaxEncodePowerPerChannel"),
	ThirdStreamImageSize(this, "ThirdStreamImageSize"){
	};

    ~EncodeCapability(void){};
};
