//
//  ProgressBackView.h
//  XMEye
//
//  Created by XM on 2017/3/11.
//  Copyright © 2017年 Megatron. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoContentDefination.h"
//#import "MacroDefinication.h"
#import "MyProgressView.h"
@interface ProgressBackView : UIView
{
    UIView *pView;      //时间轴上方的红线
    UILabel *_labTime;  //播放时间
    UISegmentedControl *_control;
    
    float _add;         //每次跳转的时间
    float _standardNum;
    int _leftNum;       //左边界时间
    int _rightNum;      //边界时间
}
@property (nonatomic, strong) NSDate *date;//当前搜索播放日期
@property (nonatomic, strong) MyProgressView *MPView; //时间轴
@property (nonatomic ,copy) void (^TouchSeektoTime)(NSInteger addTime);//根据拖动时间切换播放
@property (nonatomic) BOOL ifSliding;      // 是否在滑动
//根据返回的录像文件刷新时间轴
-(void)refreshProgressWithSearchResult:(NSMutableArray*)array;
//通过搜索录像返回的时间来刷新时间轴
-(void)refreshWithAddTime:(NSInteger)add;
// 录像回放时间帧回调，用来刷新label时间显示和时间轴
-(void)refreshTimeAndProgress:(int)time;
@end
