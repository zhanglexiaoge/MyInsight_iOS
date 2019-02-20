#pragma once
#include "FunSDK/JObject.h"
#include "Audio.h"
#include "Video.h"

#define JK_ExtraFormat "ExtraFormat" 
class ExtraFormat : public JObject
{
public:
	Audio		mAudio;
	JBoolObj		AudioEnable;
	Video		mVideo;
	JBoolObj		VideoEnable;

public:
    ExtraFormat(JObject *pParent = NULL, const char *szName = JK_ExtraFormat):
    JObject(pParent,szName),
	mAudio(this, "Audio"),
	AudioEnable(this, "AudioEnable"),
	mVideo(this, "Video"),
	VideoEnable(this, "VideoEnable"){
	};

    ~ExtraFormat(void){};
};
