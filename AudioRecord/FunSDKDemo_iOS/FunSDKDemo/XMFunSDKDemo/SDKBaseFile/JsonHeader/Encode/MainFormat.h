#pragma once
#include "FunSDK/JObject.h"
#include "Audio.h"
#include "Video.h"

#define JK_MainFormat "MainFormat" 
class MainFormat : public JObject
{
public:
	Audio		mAudio;
	JBoolObj		AudioEnable;
	Video		mVideo;
	JBoolObj		VideoEnable;

public:
    MainFormat(JObject *pParent = NULL, const char *szName = JK_MainFormat):
    JObject(pParent,szName),
	mAudio(this, "Audio"),
	AudioEnable(this, "AudioEnable"),
	mVideo(this, "Video"),
	VideoEnable(this, "VideoEnable"){
	};

    ~MainFormat(void){};
};
