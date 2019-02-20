//
//  PlayFunctionView.m
//  XMEye
//
//  Created by XM on 2016/6/26.
//  Copyright © 2016年 Megatron. All rights reserved.
//

#import "PlayFunctionView.h"

@implementation PlayFunctionView

- (UIImageView *)imageV{
    if (!_imageV) {
        _imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 60)];
        _imageV.backgroundColor = [UIColor colorWithRed:246/255.0 green:246/255.0 blue:246/255.0 alpha:1];
    }
    return _imageV;
}

- (UILabel *)timeLab{
    if (!_timeLab) {
        _timeLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        _timeLab.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        _timeLab.textAlignment = NSTextAlignmentCenter;
        _timeLab.font = [UIFont systemFontOfSize:19];
        _timeLab.textColor = [UIColor whiteColor];
    }
    return _timeLab;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.functionArray = [[NSMutableArray alloc] initWithCapacity:0];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recodeTime:) name:@"recodeTime" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearRecodeTime) name:@"recodeEnd" object:nil];
    }
    return self;
}

#pragma mark - 录像计时器
- (void)recodeTime:(NSNotification *)notification{
    for (UIButton * btn in self.functionArray) {
        if ([btn isKindOfClass:[UIButton class]]) {
            if (btn.tag == 4) {
                [btn addSubview:self.timeLab];
                self.timeLab.text = notification.object;
            }
        }
    }
}

- (void)clearRecodeTime{
    self.timeLab.text = @"";
}

- (void)setPlayMode:(PLAY_MODE)playMode{
    for (UIButton *btn in self.subviews){
        [btn removeFromSuperview];
    }
    [self.functionArray removeAllObjects];
    [self configSubViewWithPlayMode:playMode];
}

- (void)configSubViewWithPlayMode:(PLAY_MODE)playMode{
    [self addSubview:self.imageV];
    self.imageV.alpha = 1.0;

    if (playMode == PLAYBACK_MODE) {
        [self.functionArray addObject:[self getButtonBykey:@"暂停"]];
        [self.functionArray addObject:[self getButtonBykey:@"音频"]];
        [self.functionArray addObject:[self getButtonBykey:@"速度"]];
        [self.functionArray addObject:[self getButtonBykey:@"抓图"]];
        [self.functionArray addObject:[self getButtonBykey:@"录像"]];
 
    }
    else{
        [self.functionArray addObject:[self getButtonBykey:@"暂停"]];
        [self.functionArray addObject:[self getButtonBykey:@"音频"]];
        [self.functionArray addObject:[self getButtonBykey:@"对讲"]];
        [self.functionArray addObject:[self getButtonBykey:@"抓图"]];
        [self.functionArray addObject:[self getButtonBykey:@"录像"]];
    }
    //数据添加完毕之后，进行刷新
    [self refreshFrame];
}
- (void)refreshFrame{
    for (int i = 0; i < self.functionArray.count; i++) {
        CGFloat height = self.frame.size.height;
        UIButton *btn = [self.functionArray objectAtIndex:i];
        btn.frame = CGRectMake(0, 0, self.frame.size.height, height - 10);
        if (height <= 40) {     //防止按钮过小
            btn.frame = CGRectMake(0, 0, height, height);
        }
        btn.center = CGPointMake((i+1) * self.frame.size.width/(self.functionArray.count + 1),self.frame.size.height/2);
        [btn  addTarget:self action:@selector(functionBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
}
#pragma mark - 点击按钮的代理
- (void)functionBtnClick:(UIButton *)sender{
    if (self.Devicedelegate && [self.Devicedelegate respondsToSelector:@selector(basePlayFunctionViewBtnClickWithBtn:)]) {
        [self.Devicedelegate basePlayFunctionViewBtnClickWithBtn:(int)sender.tag];
    }
}

- (UIButton *)getButtonBykey:(NSString *)key{
    if (_btnDic == nil) {
        NSString *playToolImagePath = [[NSBundle mainBundle] pathForResource:@"PlayToolImage.plist" ofType:nil];
        NSDictionary *imageDic = [[NSDictionary alloc] initWithContentsOfFile:playToolImagePath];
        if (imageDic == nil) {
            return [UIButton buttonWithType:UIButtonTypeCustom];
        }
        _btnDic = [[imageDic objectForKey:@"ButtonObject"] mutableCopy];
        if (_btnDic == nil) {
            return [UIButton buttonWithType:UIButtonTypeCustom];
        }
    }
    NSDictionary *dic = [_btnDic objectForKey:key];
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
    [btn setBackgroundImage:[UIImage imageNamed:[dic objectForKey:@"NormalState"]] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:[dic objectForKey:@"SelectedState"]] forState:UIControlStateSelected];
    [btn setTitle:[dic objectForKey:@"title"] forState:UIControlStateNormal];
    [btn setTitle:[dic objectForKey:@"selectTitle"] forState:UIControlStateSelected];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    btn.tag = [[dic objectForKey:@"EventTypeNumber"] integerValue];
    [self addSubview:btn];
    return btn;
}
- (void)refreshFunctionView:(int)tag result:(BOOL)result {
    for (UIButton *btn in self.functionArray) {
        if ([btn isKindOfClass:[UIButton class]]) {
            if (btn.tag == tag) {
                btn.selected = result;
            }
        }
    }
}

#pragma mark 显示速度控制悬浮框,几秒后隐藏
- (BOOL)showPlayFunctionView{
    BOOL result = NO;
    result = self.hidden;
    [self show];
    return result;
}

- (void)show{
    //设置自己的hidden属性为NO，并且开启一个延时方法，5秒后隐藏
    self.hidden = NO;
    if (self.Devicedelegate && [self.Devicedelegate respondsToSelector:@selector(dismissPTZControlView)]) {
        [self.Devicedelegate showStreamBtn];
    }
    if (!self.screenVertical) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(dismis) object:nil];
        [self performSelector:@selector(dismis) withObject:nil afterDelay:5.0];
    }else{
       [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(dismis) object:nil];
    }
}

- (void)dismis{
    self.hidden = YES;
    if (self.Devicedelegate && [self.Devicedelegate respondsToSelector:@selector(dismissPTZControlView)]) {
        [self.Devicedelegate dismissPTZControlView];
    }
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
