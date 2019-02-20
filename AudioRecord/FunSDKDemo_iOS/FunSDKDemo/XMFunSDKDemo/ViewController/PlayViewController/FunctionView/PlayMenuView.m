//
//  PlayMenuView.m
//  XMEye
//
//  Created by Levi on 2016/6/22.
//  Copyright © 2016年 Megatron. All rights reserved.
//

#import "PlayMenuView.h"

@implementation PlayMenuView

-(UIButton *)PTZBtn{
    if (!_PTZBtn) {
        _PTZBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        _PTZBtn.center = CGPointMake((self.frame.size.width - 200)/5 +25,70);
        [_PTZBtn setBackgroundImage:[UIImage imageNamed:@"ptz_unselect.png"] forState:UIControlStateNormal];
        [_PTZBtn addTarget:self action:@selector(PTZBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _PTZBtn;
}

-(UIButton *)streamBtn{
    if (!_streamBtn) {
        _streamBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        _streamBtn.center = CGPointMake((self.frame.size.width - 200)/5 *2 +25+ 50, 70);
        [_streamBtn addTarget:self action:@selector(streamBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self setDPIBtnImage:1];
    }
    return _streamBtn;
}

-(UIButton *)playBackBtn{
    if (!_playBackBtn) {
        _playBackBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        _playBackBtn.center = CGPointMake((self.frame.size.width - 200)/5 *3 +25 + 100, 70);
        [_playBackBtn addTarget:self action:@selector(playBackBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_playBackBtn setBackgroundImage:[UIImage imageNamed:@"record_temp_normal.png"] forState:UIControlStateNormal];
    }
    return _playBackBtn;
}


-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.localLanguage =[LanguageManager currentLanguage];
        [self configSubView];
    }
    return self;
}

-(void)configSubView{
    [self addSubview:self.PTZBtn];
    [self addSubview:self.streamBtn];
    [self addSubview:self.playBackBtn];
}

-(void)PTZBtnClick:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(showPTZControl)]) {
        [self.delegate showPTZControl];
    }
}


-(void)streamBtnClick:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(changeStreamType)]) {
        [self.delegate changeStreamType];
    }
}

-(void)playBackBtnClick:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(presentPlayBackViewController)]) {
        [self.delegate presentPlayBackViewController];
    }
}



-(void)setDPIBtnImage:(int)stream{
    if ([self.localLanguage isEqualToString:@"zh_CN"]) {
        if (stream == 1) {//辅码流
            [self.streamBtn setBackgroundImage:[UIImage imageNamed:TS("btn_SD")] forState:UIControlStateNormal];
        }else{
            [self.streamBtn setBackgroundImage:[UIImage imageNamed:TS("btn_HD")] forState:UIControlStateNormal];
        }
        
    }else if ([self.localLanguage isEqualToString:@"zh_TW"]){
        if (stream == 1) {//辅码流
            [self.streamBtn setBackgroundImage:[UIImage imageNamed:TS("btn_SD_F")] forState:UIControlStateNormal];
            
        }else{
            [self.streamBtn setBackgroundImage:[UIImage imageNamed:TS("btn_HD_F")] forState:UIControlStateNormal];
        }
    }else if([self.localLanguage isEqualToString:@"en"] || [self.localLanguage isEqualToString:@"ko_KR"] ){
        if (stream == 1) {//辅码流
            [self.streamBtn setBackgroundImage:[UIImage imageNamed:TS("btn_SD_E")] forState:UIControlStateNormal];
            
        }else{
            [self.streamBtn setBackgroundImage:[UIImage imageNamed:TS("btn_HD_E")] forState:UIControlStateNormal];
        }
    }else{
        if ([LanguageManager checkSystemCurrentLanguageIsSimplifiedChinese]) {
            if (stream == 1) {//辅码流
                [self.streamBtn setBackgroundImage:[UIImage imageNamed:TS("btn_SD")] forState:UIControlStateNormal];
                
            }else{
                [self.streamBtn setBackgroundImage:[UIImage imageNamed:TS("btn_HD")] forState:UIControlStateNormal];
            }
        }else if([LanguageManager checkSystemCurrentLanguageIsSimplifiedChinese]){
            if (stream == 1) {//辅码流
                [self.streamBtn setBackgroundImage:[UIImage imageNamed:TS("btn_SD_F")] forState:UIControlStateNormal];
                
            }else{
                [self.streamBtn setBackgroundImage:[UIImage imageNamed:TS("btn_HD_F")] forState:UIControlStateNormal];
            }
        }else{
            if (stream == 1) {//辅码流
                [self.streamBtn setBackgroundImage:[UIImage imageNamed:TS("btn_SD_E")] forState:UIControlStateNormal];
                
            }else{
                [self.streamBtn setBackgroundImage:[UIImage imageNamed:TS("btn_HD_E")] forState:UIControlStateNormal];
            }
        }
    }
}

-(void)setStreamType:(int)streamType{
    _streamType = streamType;
    [self setDPIBtnImage:_streamType];
}

@end
