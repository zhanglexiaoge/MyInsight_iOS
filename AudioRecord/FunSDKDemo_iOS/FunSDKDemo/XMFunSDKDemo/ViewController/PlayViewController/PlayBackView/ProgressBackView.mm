//
//  ProgressBackView.m
//  XMEye
//
//  Created by XM on 2017/3/11.
//  Copyright © 2017年 Megatron. All rights reserved.
//

#import "ProgressBackView.h"
#import "FunSDK/FunSDK.h"
#import "NSDate+TimeCategory.h"

@implementation ProgressBackView
{
    NSTimer *_timer;        //拖动时间轴时候的定时器
    NSInteger _percens;     //毫秒
    CGPoint _start_Point;   // 上一次移动的点
    int _countNum;          //这个参数原先是用来判断是否要调用拖动时间轴接口的
    BOOL _canUpdateTime;    //这个参数原先是用来判断是否要调用拖动时间轴接口的
}
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //创建时间轴
        self.MPView = [[MyProgressView alloc] initWithFrame:CGRectMake(0,  44, ScreenWidth, 100)];
        self.MPView.backgroundColor = [UIColor clearColor];
        self.MPView.num = 0;
        self.MPView.dataArray = nil;
        self.MPView.userInteractionEnabled = YES;
        self.MPView.type = UNIT_TYPE_MINUTE;
        [self addSubview:self.MPView];
        //回访界面时间轴中间红线
        pView = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth * 0.5 -1.5, 50, 3, 80)];
        pView.backgroundColor = [UIColor colorWithRed:255/255.0 green:67/255.0 blue:76/255.0 alpha:1];
        pView.hidden = YES;
        [self addSubview:pView];
        //时间单位
        UILabel *labUnit = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - 200, frame.size.height - 40, 100, 30)];
        labUnit.text = TS("Unit");
        labUnit.textAlignment = NSTextAlignmentRight;
        [self addSubview:labUnit];
        [self addSubview:self.labTime];
        [self addSubview:self.control];
        self.userInteractionEnabled = YES;
    }
    return self;
}
#pragma mark - 录像回放时间帧回调，用来刷新label时间显示和时间轴
time_t ToTime_t(SDK_SYSTEM_TIME *pDvrTime);
-(void)refreshTimeAndProgress:(int)timeInfo
{
    //刷新时间轴
    SDK_SYSTEM_TIME time = {0};
    time.year = [NSDate getYearFormDate:_date];
    time.month = [NSDate getMonthFormDate:_date];
    time.day = [NSDate getDayFormDate:_date];
    time.hour = 0;
    time.second = 0;
    time.minute = 0;
    int thisTime = (int)ToTime_t(&time);
    _add = timeInfo - thisTime;
    [self refreshProgress];
    //刷新时间label
    if (_add == 0) {
        return;
    }
    _labTime.text = [self getSecondStringWithSecond:_add];
}
#pragma mark - 通过搜索录像返回的时间来刷新时间轴
-(void)refreshWithAddTime:(NSInteger)add
{
    pView.hidden = NO;
    _MPView.middleT = add;
    _add = add;
    if (_MPView == nil || _MPView.dataArray == nil || _MPView.dataArray.count == 0) {
        return;
    }
    [self refreshProgress];
}
#pragma mark -根据返回的录像文件刷新时间轴
-(void)refreshProgressWithSearchResult:(NSMutableArray*)array
{
    if (_MPView) {
        _MPView.dataArray = [array mutableCopy];
        [self refreshProgress];
    }
}
-(void)refreshProgress
{
    [self showProgressWithUnit:_MPView.type andMiddleSecond:_add];
    [_MPView refreshViewWithDataFrom:_leftNum to:_rightNum andMiddleNum:_standardNum andMiddleTime:_add andType:_MPView.type];
    [_MPView setNeedsDisplay];
}
#pragma mark - 根据回放时间_add刷新时间轴
-(void)showProgressWithUnit:(Unit_Type)type andMiddleSecond:(float)second
{
    if(_MPView.dataArray.count == 0) {
        return ;
    }
    
    if (UNIT_TYPE_HOUR == type) {
        for (int i = 0; i < _MPView.dataArray.count; i ++) {
            TimeInfo *info = [_MPView.dataArray objectAtIndex:i];
            if (info.start_Time <= second && second <= info.end_Time) {
                _standardNum = i;
                break;
            }
        }
        for (int i = _standardNum; i >= 0; i --) {
            TimeInfo *info = [_MPView.dataArray objectAtIndex:i];
            if ( ((second - info.end_Time) / (3600.0 * 24) * Unit_Hour * 24) > (ScreenWidth * 0.5)) {
                _leftNum = i;
                break;
            }
            if (i == 0)
            {
                _leftNum = 0;
            }
        }
        for (int i = _standardNum; i < _MPView.dataArray.count; i ++) {
            TimeInfo *info = [_MPView.dataArray objectAtIndex:i];
            if (((info.start_Time - second) / 3600.0 * Unit_Hour) > (ScreenWidth * 0.5)) {
                _rightNum = i;
                break;
            }
        }
    }
    else if (UNIT_TYPE_MINUTE == type)
    {
        for (int i = 0; i < _MPView.dataArray.count; i ++) {
            TimeInfo *info = [_MPView.dataArray objectAtIndex:i];
            if (info.start_Time <= second && second <= info.end_Time) {
                _standardNum = i;
                break;
            }
        }
        for (int i = _standardNum; i >= 0; i --) {
            TimeInfo *info = [_MPView.dataArray objectAtIndex:i];
            float myWidth = ((second - info.end_Time) / (3600.0 * 24) * Unit_Minute * 24 * 6);
            float halfWidth = ScreenWidth * 0.5;
            if ( myWidth > halfWidth) {
                _leftNum = i;
                break;
            }
            if (i == 0)
            {
                _leftNum = 0;
            }
        }
        for (int i = _standardNum; i < _MPView.dataArray.count; i ++) {
            TimeInfo *info = [_MPView.dataArray objectAtIndex:i];
            float myWidth = ((info.start_Time - second) / (3600.0 * 24) * Unit_Minute * 24 * 6);
            float halfWidth = (ScreenWidth * 0.5);
            if ( myWidth > halfWidth ) {
                _rightNum = i;
                break;
            }
        }
    }
    else if (UNIT_TYPE_SECOND == type)
    {
        for (int i = 0; i < _MPView.dataArray.count; i ++) {
            TimeInfo *info = [_MPView.dataArray objectAtIndex:i];
            if (info.start_Time <= second && second <= info.end_Time) {
                _standardNum = i;
                break;
            }
        }
        for (int i = _standardNum; i >= 0; i --) {
            TimeInfo *info = [_MPView.dataArray objectAtIndex:i];
            if ( ((second - info.start_Time) / (3600.0 * 24) * Unit_Second * 60 * 24 * 6) > (ScreenWidth * 0.5)) {
                _leftNum = i;
                break;
            }
            if (i == 0)
            {
                _leftNum = 0;
            }
        }
        for (int i = _standardNum; i < _MPView.dataArray.count; i ++) {
            TimeInfo *info = [_MPView.dataArray objectAtIndex:i];
            if (((info.end_Time - second) / (3600.0 * 24) * Unit_Second * 60 * 24 * 6) > (ScreenWidth * 0.5)) {
                _rightNum = i;
                break;
            }
        }
    }
}
#pragma mark - UITouchEvent 触摸事件
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(startTimer) userInfo:nil repeats:YES];
    _percens = 0;
    _start_Point = [[touches anyObject] locationInView:self];
    if (_start_Point.y >= 50) {
        _countNum = 0;
        _ifSliding = YES;
        _canUpdateTime = NO;
    }
}
-(void)startTimer
{
    _percens++;
}
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_ifSliding == YES) {
        if (_percens >= 20) {
            CGPoint point = [[touches anyObject] locationInView:self];
            float number = - (point.x - _start_Point.x);
            [self updateDataWithFloatNumber:number];
            _start_Point = point;
            _labTime.text = [self getSecondStringWithSecond:_add];
        }
    }
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_ifSliding == YES) {
        if (_percens < 20) {
            CGPoint point = [[touches anyObject] locationInView:self];
            float number = 0.0;
            if (point.x < _start_Point.x) {
                if (self.MPView.type == UNIT_TYPE_SECOND) {
                    number = 180.0;
                }
                if (self.MPView.type == UNIT_TYPE_MINUTE) {
                    number = 3.0;
                }
                if (self.MPView.type == UNIT_TYPE_HOUR) {
                    number = 0.5;
                }
            } else {
                if (self.MPView.type == UNIT_TYPE_SECOND) {
                    number = -180.0;
                }
                if (self.MPView.type == UNIT_TYPE_MINUTE) {
                    number = -3.0;
                }
                if (self.MPView.type == UNIT_TYPE_HOUR) {
                    number = -0.5;
                }
            }
            [self updateDataWithFloatNumber:number];
            _labTime.text = [self getSecondStringWithSecond:_add];
        }
        NSString *current = _labTime.text;
        NSRange range1 = NSMakeRange(0, 2);
        NSRange range2 = NSMakeRange(3, 2);
        NSRange range3 = NSMakeRange(6, 2);
        
        _add = [[current substringWithRange:range1] integerValue] * 60 * 60 + [[current substringWithRange:range2] integerValue] * 60 + [[current substringWithRange:range3] integerValue];
        //调用接口进行跳转，并且界面刷新
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(seekToTime) object:nil];
        [self performSelector:@selector(seekToTime) withObject:nil afterDelay:1.0];
    }
    
    [_timer invalidate];
}
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    _ifSliding = NO;
    _canUpdateTime = YES;
}
-(void)seekToTime
{
    if (self.TouchSeektoTime) {
        self.TouchSeektoTime(_add);
    }
    _ifSliding = NO;
    _canUpdateTime = YES;

}
//拖动时间轴时候的处理
-(void)updateDataWithFloatNumber:(float)number
{
    if (self.MPView.type == UNIT_TYPE_HOUR) {
        float time = number / (24 * Unit_Hour) * 24 * 60 * 60;
        _add = _add + time;
        if (_add >= 0 && _add <= (24*60*60)) {
            [self showProgressWithUnit:UNIT_TYPE_HOUR andMiddleSecond:_add];
            [self.MPView refreshViewWithDataFrom:_leftNum to:_rightNum andMiddleNum:_standardNum andMiddleTime:_add andType:self.MPView.type];
        }
        else if ( _add < 0)
        {
            [self showProgressWithUnit:UNIT_TYPE_HOUR andMiddleSecond:0];
            [self.MPView refreshViewWithDataFrom:_leftNum to:_rightNum andMiddleNum:_standardNum andMiddleTime:_add andType:self.MPView.type];
            _add = 0;
        }
        else if (_add > (24*60*60))
        {
            [self showProgressWithUnit:UNIT_TYPE_HOUR andMiddleSecond:(24*60*60)];
            [self.MPView refreshViewWithDataFrom:_leftNum to:_rightNum andMiddleNum:_standardNum andMiddleTime:_add andType:self.MPView.type];
            _add = 24*60*60;
        }
    }
    else if (self.MPView.type == UNIT_TYPE_MINUTE)
    {
        float time = number / (24 * 6 * Unit_Minute) * 24 * 60 * 60;
        _add = _add + time;
        if (_add >= 0 && _add <= (24*60*60)) {
            [self showProgressWithUnit:UNIT_TYPE_MINUTE andMiddleSecond:_add];
            [self.MPView refreshViewWithDataFrom:_leftNum to:_rightNum andMiddleNum:_standardNum andMiddleTime:_add andType:self.MPView.type];
        }
        else if ( _add < 0)
        {
            [self showProgressWithUnit:UNIT_TYPE_MINUTE andMiddleSecond:0];
            [self.MPView refreshViewWithDataFrom:_leftNum to:_rightNum andMiddleNum:_standardNum andMiddleTime:_add andType:self.MPView.type];
            _add = 0;
        }
        else if (_add > (24*60*60))
        {
            [self showProgressWithUnit:UNIT_TYPE_MINUTE andMiddleSecond:(24*60*60)];
            [self.MPView refreshViewWithDataFrom:_leftNum to:_rightNum andMiddleNum:_standardNum andMiddleTime:_add andType:self.MPView.type];
            _add = 24*60*60;
        }
    }
    else if (self.MPView.type == UNIT_TYPE_SECOND)
    {
        float time = number / (24 * 6 * Unit_Second * 60) * 24 * 60 * 60;
        _add = _add + time;
        if (_add >= 0 && _add <= (24*60*60)) {
            [self showProgressWithUnit:UNIT_TYPE_SECOND andMiddleSecond:_add];
            [self.MPView refreshViewWithDataFrom:_leftNum to:_rightNum andMiddleNum:_standardNum andMiddleTime:_add andType:self.MPView.type];
        }
        else if ( _add < 0)
        {
            [self showProgressWithUnit:UNIT_TYPE_SECOND andMiddleSecond:0];
            [self.MPView refreshViewWithDataFrom:_leftNum to:_rightNum andMiddleNum:_standardNum andMiddleTime:_add andType:self.MPView.type];
            _add = 0;
        }
        else if (_add > (24*60*60))
        {
            [self showProgressWithUnit:UNIT_TYPE_SECOND andMiddleSecond:(24*60*60)];
            [self.MPView refreshViewWithDataFrom:_leftNum to:_rightNum andMiddleNum:_standardNum andMiddleTime:_add andType:self.MPView.type];
            _add = 24*60*60;
        }
    }
}
// 秒数转为时分秒
-(NSString *)getSecondStringWithSecond:(int)second
{
    int h = second / 3600;
    int m = (second % 3600) / 60;
    int s = ((second % 3600) % 60);
    if (s<0) {
        s=0;
    }
    NSString *str = [NSString stringWithFormat:@"%@:%@:%@",h>=10?[NSString stringWithFormat:@"%i",h]:[NSString stringWithFormat:@"0%i",h],m>=10?[NSString stringWithFormat:@"%i",m]:[NSString stringWithFormat:@"0%i",m],s>=10?[NSString stringWithFormat:@"%i",s]:[NSString stringWithFormat:@"0%i",s]];
    return str;
}
#pragma mark - 点击事件单位，修改时间单位
-(void)segValueChanged:(UISegmentedControl*)control
{
    if (self.MPView == nil) {
        return;
    }
    NSInteger num = control.selectedSegmentIndex;
    if (num == 0) {
        self.MPView.type = UNIT_TYPE_HOUR;
    }
    else if (num == 1)
    {
        self.MPView.type = UNIT_TYPE_MINUTE;
    }
    else
    {
        self.MPView.type = UNIT_TYPE_SECOND;
    }
}
#pragma mark - 创建时间和单位控制器
-(UILabel*)labTime
{
    _labTime = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    _labTime.center = CGPointMake(ScreenWidth * 0.5, 30);
    _labTime.backgroundColor = [UIColor clearColor];
    _labTime.textColor = NormalFontColor;
    _labTime.textAlignment = NSTextAlignmentCenter;
    _labTime.font = [UIFont systemFontOfSize:12.0];
    return _labTime;
}
-(UISegmentedControl*)control
{
    
    NSArray *array = [[NSArray alloc] initWithObjects:@"1",@"2", nil];
    _control = [[UISegmentedControl alloc] initWithItems:array];
    _control.frame = CGRectMake(ScreenWidth - 90, self.frame.size.height - 40, 70, 30);
    [_control setTitle:TS("h") forSegmentAtIndex:0];
    [_control setTitle:TS("m") forSegmentAtIndex:1];
    [_control addTarget:self action:@selector(segValueChanged:) forControlEvents:UIControlEventValueChanged];
    _control.selectedSegmentIndex = 1;
    [self addSubview:_control];
    return _control;
}
-(void)dealloc
{
    if (_MPView) {
        _MPView = nil;
    }
    if (pView) {
        pView = nil;
    }
    if (_labTime) {
        _labTime = nil;
    }
}
@end
