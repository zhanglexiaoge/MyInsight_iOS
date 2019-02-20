#pragma once
#include "FunSDK/JObject.h"

#define JK_Audio "Audio" 
class Audio : public JObject
{
public:
	JIntObj		BitRate;
	JIntObj		MaxVolume;
	JIntObj		SampleRate;

public:
    Audio(JObject *pParent = NULL, const char *szName = JK_Audio):
    JObject(pParent,szName),
	BitRate(this, "BitRate"),
	MaxVolume(this, "MaxVolume"),
	SampleRate(this, "SampleRate"){
	};

    ~Audio(void){};
};
