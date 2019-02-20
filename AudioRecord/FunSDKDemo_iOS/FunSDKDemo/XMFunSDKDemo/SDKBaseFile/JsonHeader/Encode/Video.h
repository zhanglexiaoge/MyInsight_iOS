#pragma once
#include "FunSDK/JObject.h"

#define JK_Video "Video" 
class Video : public JObject
{
public:
	JIntObj		BitRate;
	JStrObj		BitRateControl;
	JStrObj		Compression;
	JIntObj		FPS;
	JIntObj		GOP;
	JIntObj		Quality;
	JStrObj		Resolution;

public:
    Video(JObject *pParent = NULL, const char *szName = JK_Video):
    JObject(pParent,szName),
	BitRate(this, "BitRate"),
	BitRateControl(this, "BitRateControl"),
	Compression(this, "Compression"),
	FPS(this, "FPS"),
	GOP(this, "GOP"),
	Quality(this, "Quality"),
	Resolution(this, "Resolution"){
	};

    ~Video(void){};
};
