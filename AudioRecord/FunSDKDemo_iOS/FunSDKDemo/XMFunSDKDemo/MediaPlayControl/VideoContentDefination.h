//
//  VideoContentDefination.h
//  TEST
//
//  Created by Megatron on 12/2/14.
//  Copyright (c) 2014 Megatron. All rights reserved.
//

#ifndef TEST_VideoContentDefination_h
#define TEST_VideoContentDefination_h


#endif

#define Unit_Hour 120
#define Unit_Minute 120
#define Unit_Second 120
typedef enum Unit_Type   // 进度条单位
{
    UNIT_TYPE_HOUR,
    UNIT_TYPE_MINUTE,
    UNIT_TYPE_SECOND
}Unit_Type;

//屏幕状态枚举
typedef enum SCREEN_MODE{
    SCREEN_MODE_NONE = 0,
    SCREEN_MODE_V = 1,//竖屏
    SCREEN_MODE_L,   //横屏左
    SCREEN_MODE_R,   //横屏右
}SCREEN_MODE;

//音频开关状态
typedef enum VOICE_MODE{
    VMODE_NONE = 0,
    VMODE_VOICE,
}VOICE_MODE;

//预览界面播放窗口枚举
typedef enum SCREEN_Number{
    SCREEN_Number_ONE = 1,
    SCREEN_Number_FOUR = 4,
    SCREEN_Number_NINE = 9,
    SCREEN_Number_SIXTEEN = 16,
}SCREEN_Number;

typedef enum FUNCTION_TYPE{//菜单栏功能
    FUNCTION_TYPE_TAKE,     //对讲
    FUNCTION_TYPE_STREAM,   //切换码流
    FUNCTION_TYPE_REFRESH,  //刷新
    FUNCTION_TYPE_PLAYBACK, //回放
}FUNCTION_TYPE;

