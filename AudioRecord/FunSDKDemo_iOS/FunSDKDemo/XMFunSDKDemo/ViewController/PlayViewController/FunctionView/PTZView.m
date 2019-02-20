//
//  PTZView.m
//  XMEye
//
//  Created by Levi on 2017/6/23.
//  Copyright © 2017年 Megatron. All rights reserved.
//

#import "PTZView.h"
#import "FunSDK/netsdk.h"

@implementation PTZView

-(UIImageView *)PTZControlIV{
    if (!_PTZControlIV) {
        _PTZControlIV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 120, 120)];
        _PTZControlIV.center = CGPointMake(self.frame.size.width * 0.5 - 60 - 30, self.frame.size.height * 0.5);
        _PTZControlIV.image = [UIImage imageNamed:@"btn_control_normal.png"];
        _PTZControlIV.userInteractionEnabled = YES;
    }
    return _PTZControlIV;
}

-(UIButton *)PTZUpBtn{
    if (!_PTZUpBtn) {
        _PTZUpBtn = [[UIButton alloc] initWithFrame:CGRectMake(40, 0, 40, 40)];
        _PTZUpBtn.backgroundColor = [UIColor clearColor];
        _PTZUpBtn.tag = TILT_UP;
        [_PTZUpBtn addTarget:self action:@selector(TouchDownAction:) forControlEvents:UIControlEventTouchDown];
        [_PTZUpBtn addTarget:self action:@selector(TouchUpInsideAction:) forControlEvents:UIControlEventTouchCancel];
        [_PTZUpBtn addTarget:self action:@selector(TouchUpInsideAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _PTZUpBtn;
}

-(UIButton *)PTZDownBtn{
    if (!_PTZDownBtn) {
        _PTZDownBtn = [[UIButton alloc] initWithFrame:CGRectMake(40, 80, 40, 40)];
        _PTZDownBtn.backgroundColor = [UIColor clearColor];
        _PTZDownBtn.tag = TILT_DOWN;
        [_PTZDownBtn addTarget:self action:@selector(TouchDownAction:) forControlEvents:UIControlEventTouchDown];
        [_PTZDownBtn addTarget:self action:@selector(TouchUpInsideAction:) forControlEvents:UIControlEventTouchCancel];
        [_PTZDownBtn addTarget:self action:@selector(TouchUpInsideAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _PTZDownBtn;
}

-(UIButton *)PTZLeftBtn{
    if (!_PTZLeftBtn) {
        _PTZLeftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 40, 40, 40)];
        _PTZLeftBtn.backgroundColor = [UIColor clearColor];
        _PTZLeftBtn.tag = PAN_LEFT;
        [_PTZLeftBtn addTarget:self action:@selector(TouchDownAction:) forControlEvents:UIControlEventTouchDown];
        [_PTZLeftBtn addTarget:self action:@selector(TouchUpInsideAction:) forControlEvents:UIControlEventTouchCancel];
        [_PTZLeftBtn addTarget:self action:@selector(TouchUpInsideAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _PTZLeftBtn;
}

-(UIButton *)PTZRightBtn{
    if (!_PTZRightBtn) {
        _PTZRightBtn = [[UIButton alloc] initWithFrame:CGRectMake(80, 40, 40, 40)];
        _PTZRightBtn.backgroundColor = [UIColor clearColor];
        _PTZRightBtn.tag = PAN_RIGHT;
        [_PTZRightBtn addTarget:self action:@selector(TouchDownAction:) forControlEvents:UIControlEventTouchDown];
        [_PTZRightBtn addTarget:self action:@selector(TouchUpInsideAction:) forControlEvents:UIControlEventTouchCancel];
        [_PTZRightBtn addTarget:self action:@selector(TouchUpInsideAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _PTZRightBtn;
}

-(UIButton *)closeBtn{
    if (!_closeBtn) {
        _closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 50,10 , 40, 40)];
        [_closeBtn setBackgroundImage:[UIImage imageNamed:@"icon_close"] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(removeTheView:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self configSubView];
    }
    return self;
}

-(void)configSubView{
    [self addSubview:self.closeBtn];
    [self addSubview:self.PTZControlIV];
    [self.PTZControlIV addSubview:self.PTZUpBtn];
    [self.PTZControlIV addSubview:self.PTZDownBtn];
    [self.PTZControlIV addSubview:self.PTZLeftBtn];
    [self.PTZControlIV addSubview:self.PTZRightBtn];
    for (int i = 0; i<6; i++) {
        [self createBtnWithTag:i];
    }
    [self createLab];
}

-(void)createBtnWithTag:(int)tag{
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    if (tag <= 2) {
        btn.center = CGPointMake(self.frame.size.width * 0.5 + 15 +40*tag,self.frame.size.height * 0.5 - 30);
        [btn setBackgroundImage:[UIImage imageNamed:@"btn_plus_normal.png"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"btn_plus_highlighted.png"] forState:UIControlStateHighlighted];
    }else{
        btn.center = CGPointMake(self.frame.size.width * 0.5 + 15 +40*(tag -3),self.frame.size.height * 0.5 + 30);
        [btn setBackgroundImage:[UIImage imageNamed:@"btn_minus_normal.png"] forState:UIControlStateNormal];
        [btn setBackgroundImage:[UIImage imageNamed:@"btn_minus_highlighted.png"] forState:UIControlStateHighlighted];
    }
    
    if (tag == 0) {
        btn.tag = ZOOM_IN_1;
    }else if (tag == 1){
        btn.tag = FOCUS_NEAR;
    }else if (tag == 2){
        btn.tag = IRIS_OPEN;
    }else if (tag == 3){
        btn.tag = ZOOM_OUT_1;
    }else if (tag == 4){
        btn.tag = FOCUS_FAR;
    }else{
        btn.tag = IRIS_CLOSE;
    }
    
    [btn addTarget:self action:@selector(changeSpeed:) forControlEvents:UIControlEventTouchDown];
    [btn addTarget:self action:@selector(stopchangeSubSpeed:) forControlEvents:UIControlEventTouchCancel];
    [btn addTarget:self action:@selector(stopchangeSubSpeed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
}

-(void)createLab{
    UILabel *labZoom = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 25)];
    labZoom.center =  CGPointMake(self.frame.size.width * 0.5 + 15, self.frame.size.height * 0.5);
    labZoom.text = TS("Zoom");
    labZoom.textColor = NormalFontColor;
    labZoom.font = [UIFont systemFontOfSize:14];
    labZoom.textAlignment = NSTextAlignmentCenter;
    labZoom.backgroundColor = [UIColor clearColor];
    
    UILabel *labFocus = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 25)];
    labFocus.center =  CGPointMake(self.frame.size.width * 0.5 + 55, self.frame.size.height * 0.5);
    labFocus.text = TS("Focus");
    labFocus.textColor = NormalFontColor;
    labFocus.font = [UIFont systemFontOfSize:14];
    labFocus.textAlignment = NSTextAlignmentCenter;
    labFocus.backgroundColor = [UIColor clearColor];
    
    UILabel *labIris = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 25)];
    labIris.center =  CGPointMake(self.frame.size.width * 0.5 + 95, self.frame.size.height * 0.5);
    labIris.text = TS("Iris");
    labIris.textColor = NormalFontColor;
    labIris.font = [UIFont systemFontOfSize:14];
    labIris.textAlignment = NSTextAlignmentCenter;
    labIris.backgroundColor = [UIColor clearColor];
    
    [self addSubview:labZoom];
    [self addSubview:labFocus];
    [self addSubview:labIris];
}

#pragma mark - 点击云台控制的按钮
-(void)TouchDownAction:(UIButton *)sender{
    switch (sender.tag) {
        case 0:
            _PTZControlIV.image = [UIImage imageNamed:@"btn_control_up.png"];
            break;
        case 1:
            _PTZControlIV.image = [UIImage imageNamed:@"btn_control_down.png"];
            break;
        case 2:
            _PTZControlIV.image = [UIImage imageNamed:@"btn_control_left.png"];
            break;
        case 3:
            _PTZControlIV.image = [UIImage imageNamed:@"btn_control_right.png"];
            break;
        default:
            break;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        _PTZControlIV.image = [UIImage imageNamed:@"btn_control_normal.png"];
    });
    if (self.PTZdelegate && [self.PTZdelegate respondsToSelector:@selector(controlPTZBtnTouchDownAction:)]) {
        [self.PTZdelegate controlPTZBtnTouchDownAction:(int)sender.tag];
    }
}

#pragma mark - 抬起云台控制的按钮
-(void)TouchUpInsideAction:(UIButton *)sender{
    if (self.PTZdelegate && [self.PTZdelegate respondsToSelector:@selector(controlPTZBtnTouchUpInsideAction:)]) {
        [self.PTZdelegate controlPTZBtnTouchUpInsideAction:(int)sender.tag];
    }
}

#pragma mark - 点击控制的按钮(变倍，变焦，光圈)
-(void)changeSpeed:(UIButton *)sender{
    if (self.speedDelegate && [self.speedDelegate respondsToSelector:@selector(controladdSpeedTouchDownAction:)]) {
        [self.speedDelegate controladdSpeedTouchDownAction:(int)sender.tag];
    }
}

#pragma mark - 抬起控制的按钮(变倍，变焦，光圈)
-(void)stopchangeSubSpeed:(UIButton *)sender{
    if (self.speedDelegate && [self.speedDelegate respondsToSelector:@selector(controladdSpeedTouchUpInsideAction:)]) {
        [self.speedDelegate controladdSpeedTouchUpInsideAction:(int)sender.tag];
    }
}
-(void)removeTheView:(UIButton *)sender{
    [self removeFromSuperview];
}

@end
