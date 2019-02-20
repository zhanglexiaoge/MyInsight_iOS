//
//  PlayFunctionView.h
//  XMEye
//
//  Created by XM on 2016/6/26.
//  Copyright © 2016年 Megatron. All rights reserved.
//

/******
 *
 *工具栏界面，音频、对讲、抓图、录像等
 *
 */

typedef enum CONTROL_TYPE{ //工具栏类型
    //视频预览功能
    CONTROL_REALPLAY_CloseChannle=0,
    CONTROL_REALPLAY_VOICE,
    CONTROL_REALPLAY_MENU,
    CONTROL_REALPLAY_SNAP,
    CONTROL_REALPLAY_VIDEO,
    CONTROL_REALPLAY_TALK,
    CONTROL_REALPLAY_STREAM, //切换码流
    //回放
    CONTROL_TYPE_STOP = 100,
    CONTROL_TYPE_VOICE,
    CONTROL_TYPE_SPEED,
    CONTROL_TYPE_CAPTURE,
    CONTROL_TYPE_RECORD,
    //全屏预览
    CONTROL_FULLREALPLAY_PAUSE=200,
    CONTROL_FULLREALPLAY_VOICE,
    CONTROL_FULLREALPLAY_SNAP,
    CONTROL_FULLREALPLAY_VIDEO,
    CONTROL_FULLREALPLAY_REFRESH,
    CONTROL_FULLREALPLAY_PTZ,
    //全屏回放
    FUNCTIONENUM_FULLPLAYBACK_CLOSECHANNLE = 300,
    FUNCTIONENUM_FULLPLAYBACK_VOIDE,
    FUNCTIONENUM_FULLPLAYBACK_SPEED,
    FUNCTIONENUM_FULLPLAYBACK_SNAP,
    FUNCTIONENUM_FULLPLAYBACK_VIDEO
}CONTROL_TYPE;

//当前的播放类型
typedef enum PLAY_MODE{
    REALPLAY_MODE = 0,              //实时预览
    PLAYBACK_MODE,                  //远程回放
    FULL_SCREEN_REALPLAY_MODE,      //全屏实时预览
    FULL_SCREEN_PLAYBACK_MODE,      //全屏远程回放
}PLAY_MODE;

#define ToolViewHeight 60

#import <UIKit/UIKit.h>
@protocol basePlayFunctionViewDelegate <NSObject>
@optional
-(void)basePlayFunctionViewBtnClickWithBtn:(int)tag;

-(void)dismissPTZControlView;

-(void)showStreamBtn;

@end

@interface PlayFunctionView : UIView

@property (nonatomic,weak) id <basePlayFunctionViewDelegate> Devicedelegate;

@property (nonatomic,strong) NSMutableArray *functionArray;

@property (nonatomic,strong) NSMutableDictionary *btnDic;

@property (nonatomic,strong) UILabel *timeLab;

@property (nonatomic) PLAY_MODE playMode;

@property (nonatomic) BOOL screenVertical;

//背景图片颜色
@property (nonatomic, strong) UIImageView *imageV;

-(void)refreshFunctionView:(int)tag result:(BOOL)result;

-(BOOL)showPlayFunctionView;//显示

@end
