//
//  VRFunctionView.m
//  XMEye
//
//  Created by riceFun on 16/12/1.
//  Copyright © 2016年 Megatron. All rights reserved.
//

#import "VRFunctionView.h"
#define buttonHeight 36

@implementation VRFunctionView

-(instancetype)initWithFrame:(CGRect)frame VRType:(int)is180VR
{
    self = [super initWithFrame:frame];
    self.is180VR = is180VR;
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        self.hidden = YES;
        self.alpha = 0.5;
        self.VRType = 1;
        self.functionBtnArray = [[NSMutableArray alloc] initWithCapacity:0];
    
        [self addSubview:self.closeMode];
        [self addSubview:self.war];
        [self addSubview:self.ceiling];
        [self addSubview:self.Ball];
        [self addSubview:self.Rectangle];
        [self addSubview:self.BallBowl];
        [self addSubview:self.BallHat];
        [self addSubview:self.Cylinder];
        [self addSubview:self.Split];
        [self addSubview:self.dichotomia];
        [self addSubview:self.threeR];
        
        [self.functionBtnArray addObject:self.Ball];
        [self.functionBtnArray addObject:self.Rectangle];
        [self.functionBtnArray addObject:self.BallBowl];
        [self.functionBtnArray addObject:self.BallHat];
        [self.functionBtnArray addObject:self.Cylinder];
        [self.functionBtnArray addObject:self.Split];
        [self.functionBtnArray addObject:self.dichotomia];
        [self.functionBtnArray addObject:self.threeR];
        
        
        [[NSNotificationCenter defaultCenter]
         addObserver:self selector:@selector(getNotificationAction:) name:@"AcceptDelegate" object:nil];
    }
    //设置每个控件的位置，传入的值是360VR下的模式模式，YES是天花板模式
    [self layoutVRFunctionView:YES];
    return self;
}

- (void)getNotificationAction:(NSNotification *)notification{
    NSDictionary *infoDic = [notification object];
    int shapeTag = [[infoDic objectForKey:@"parameter1"] intValue];
    for (UIButton *btn in self.functionBtnArray) {
        [btn setSelected:NO];
    }
    
    [(UIButton *)self.functionBtnArray[shapeTag] setSelected:YES];
}

-(void)delegateChangeVRMode:(_XMVRShape)type{
    
}
-(void)setSelectVR:(int)type
{
    for (UIButton *btn in self.subviews) {
        if (btn.tag >= Shape_End) {//壁挂和天花板 两个按钮
        }else{
            if ([btn isKindOfClass:[UIButton class]]) {
                if (btn.tag == type) {
                    btn.selected = YES;
                }else{
                    btn.selected = NO;
                }
            }
        }
    }
}
//刷新VR模式切换界面，360VR默认是天花板
-(void)layoutVRFunctionView:(BOOL)isCeiling
{
    //现刷新界面坐标 frame
    [self refreshFrame];
    //如果是180VR，不判断壁挂和天花板，直接刷新界面
    if (self.is180VR == YES) {
        [self.Ball setBackgroundImage:[UIImage imageNamed:@"VR_180_nor.png"] forState:UIControlStateNormal];
        [self.Ball setBackgroundImage:[UIImage imageNamed:@"VR_180_sel.png"] forState:UIControlStateSelected];
        [self layoutShape];
    }
    //360VR需要判断壁挂和天花板，默认天花板
    else{
        [self setCommon360VR];
        if (isCeiling) {
            //360VR 天花板
            [self layoutLong];
        }else{
            //360VR 壁装
            [self layoutShort];
        }
    }
}
-(void)refreshFrame{
    //关闭按钮坐标,随着界面坐标
    self.closeMode.frame = CGRectMake(0, 0,buttonHeight,buttonHeight);
    self.closeMode.center = CGPointMake(buttonHeight*1.5/2, self.frame.size.height/2);
}
//刷新180VR
-(void)layoutShape
{
    self.war.hidden = YES;
    self.ceiling.hidden = YES;
    //下面两个通用的
    self.Ball.frame = CGRectMake(buttonHeight*1.5 + buttonHeight * 0, 0, buttonHeight, buttonHeight);
    self.Rectangle.frame = CGRectMake(buttonHeight*1.5 + buttonHeight * 1, 0, buttonHeight, buttonHeight);
    self.Cylinder.frame = CGRectMake(buttonHeight*1.5 + buttonHeight * 2, 0, buttonHeight, buttonHeight);
    self.Split.frame = CGRectMake(buttonHeight*1.5 + buttonHeight * 3, 0, buttonHeight, buttonHeight);
    self.threeR.frame = CGRectMake(buttonHeight*1.5 + buttonHeight * 4, 0, buttonHeight, buttonHeight);
    [self.functionBtnArray removeAllObjects];
    
    self.Ball.hidden = NO;
    self.BallBowl.hidden = YES;
    self.BallHat.hidden = YES;
    self.Rectangle.hidden = NO;
    self.Cylinder.hidden = NO;
    self.Split.hidden = NO;
    self.dichotomia.hidden = YES;
    self.threeR.hidden = NO;
    [self.functionBtnArray addObject:self.Ball];
    [self.functionBtnArray addObject:self.Rectangle];
    [self.functionBtnArray addObject:self.Cylinder];
    [self.functionBtnArray addObject:self.Split];
    [self.functionBtnArray addObject:self.threeR];
    
}
//设置360通用的VR界面
-(void)setCommon360VR
{
    [self.Ball setBackgroundImage:[UIImage imageNamed:@"VR_Ball_nor"] forState:UIControlStateNormal];
    [self.Ball setBackgroundImage:[UIImage imageNamed:@"VR_Ball_sel"] forState:UIControlStateSelected];
    //壁挂和天花板
    self.war.hidden = NO;
    self.ceiling.hidden = NO;
    self.war.frame = CGRectMake(buttonHeight*1.5 + buttonHeight * 0, 0, buttonHeight, buttonHeight);
    self.ceiling.frame = CGRectMake(buttonHeight*1.5 + buttonHeight * 1, 0, buttonHeight, buttonHeight);
    //球和矩形模式
    self.Ball.hidden = NO;
    self.Rectangle.hidden = NO;
    self.Ball.frame = CGRectMake(buttonHeight*1.5 + buttonHeight * 0, buttonHeight, buttonHeight, buttonHeight);
    self.Rectangle.frame = CGRectMake(buttonHeight*1.5 + buttonHeight * 1, buttonHeight, buttonHeight, buttonHeight);
    
    //碗、帽子、圆柱、四分、二分
    self.BallBowl.frame = CGRectMake(buttonHeight*1.5 + buttonHeight * 2, buttonHeight, buttonHeight, buttonHeight);
    self.BallHat.frame = CGRectMake(buttonHeight*1.5 + buttonHeight * 3, buttonHeight, buttonHeight, buttonHeight);
    self.Cylinder.frame = CGRectMake(buttonHeight*1.5 + buttonHeight * 4, buttonHeight, buttonHeight, buttonHeight);
    self.Split.frame = CGRectMake(buttonHeight*1.5 + buttonHeight * 5, buttonHeight, buttonHeight, buttonHeight);
    self.dichotomia.frame = CGRectMake(buttonHeight*1.5 + buttonHeight * 6, buttonHeight, buttonHeight, buttonHeight);
}
-(void)layoutShort
{
    self.BallBowl.hidden = YES;
    self.BallHat.hidden = YES;
    self.Cylinder.hidden = YES;
    self.Split.hidden = YES;
    self.dichotomia.hidden = YES;
    self.threeR.hidden = YES;
}
-(void)layoutLong
{
    self.BallBowl.hidden = NO;
    self.BallHat.hidden = NO;
    self.Cylinder.hidden = NO;
    self.Split.hidden = NO;
    self.dichotomia.hidden = NO;
    self.threeR.hidden = YES;
    
}
#pragma mark 按钮响应的方法  以下两个方法用于显示不同的鱼眼显示方式
- (void)chooseCeilingFunction{
    //天花板模式
    [self layoutLong];
    //切换模式之后，默认改为球状
    self.VRType = 1;
    [self delegateChangeVRMode:Shape_Ball WithWarOrCeiling:self.VRType];
    self.ceiling.selected = YES;
    self.war.selected = NO;
}

- (void)chooseWarFunction{
    //壁挂模式
    [self layoutShort];
    //切换模式之后，默认改为球状
    self.VRType = 2;
    [self delegateChangeVRMode:Shape_Ball WithWarOrCeiling:self.VRType];
    self.ceiling.selected = NO;
    self.war.selected = YES;
}

- (void)removeSelf{
    self.hidden = YES;
    [self removeFromSuperview];
}
-(void)VRModeChange:(id)sender
{
    UIButton *VRBtn = (UIButton*)sender;
    [self delegateChangeVRMode:(_XMVRShape)VRBtn.tag WithWarOrCeiling:self.VRType];
}
-(void)delegateChangeVRMode:(_XMVRShape)type WithWarOrCeiling:(int)model
{
    [self setSelectVR:type];
    //调用代理改变VR模式
    if ([self.delegate respondsToSelector:@selector(changeVRFunctionMode: WithWarOrCeiling:)]) {
        [self.delegate changeVRFunctionMode:type WithWarOrCeiling:model];
    }
}
#pragma mark - lazyLoad 各个控件的加载
-(UIView *)menuView
{
    if (!_menuView) {
        _menuView = [[UIView alloc]init];
        _menuView.backgroundColor = [UIColor redColor];
        _menuView.alpha = 0.6;
        _menuView.hidden = YES;
    }
    return _menuView;
}
-(UIView *)modeView
{
    if (!_modeView) {
        _modeView = [[UIView alloc]init];
        _modeView.backgroundColor = [UIColor blueColor];
        _modeView.alpha = 0.6;
        _modeView.layer.cornerRadius = 15;
    }
    return _modeView;
}
#pragma mark - modeView的按钮
-(UIButton *)closeMode
{
    if (!_closeMode) {
        _closeMode = [[UIButton alloc]init];
        [_closeMode setBackgroundImage:[UIImage imageNamed:@"VR-close_nor"] forState:UIControlStateNormal];
        [_closeMode setBackgroundImage:[UIImage imageNamed:@"VR-close_nor"] forState:UIControlStateSelected];
        [_closeMode addTarget:self action:@selector(removeSelf) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeMode;
}
#pragma mark - menuView的按钮
-(UIButton *)ceiling
{
    if (!_ceiling) {
        _ceiling = [[UIButton alloc]init];
        [_ceiling setBackgroundImage:[UIImage imageNamed:@"VR-Ceiling_nor"] forState:UIControlStateNormal];
        [_ceiling setBackgroundImage:[UIImage imageNamed:@"VR-Ceiling_sel"] forState:UIControlStateSelected];
        [_ceiling addTarget:self action:@selector(chooseCeilingFunction) forControlEvents:UIControlEventTouchUpInside];
        _ceiling.tag = 101;
    }
    return _ceiling;
}
-(UIButton *)war
{
    if (!_war) {
        _war = [[UIButton alloc]init];
        [_war setBackgroundImage:[UIImage imageNamed:@"VR_Wall_nor"] forState:UIControlStateNormal];
        [_war setBackgroundImage:[UIImage imageNamed:@"VR_Wall_sel"] forState:UIControlStateSelected];
        [_war addTarget:self action:@selector(chooseWarFunction) forControlEvents:UIControlEventTouchUpInside];
        _war.tag = 100;
    }
    return _war;
}
-(UIButton *)Cylinder
{
    if (!_Cylinder) {
        _Cylinder = [[UIButton alloc]init];
        [_Cylinder setBackgroundImage:[UIImage imageNamed:@"VR-cylinder_nor"] forState:UIControlStateNormal];
        [_Cylinder setBackgroundImage:[UIImage imageNamed:@"VR-cylinder_sel"] forState:UIControlStateSelected];
        _Cylinder.tag = Shape_Cylinder;
        [_Cylinder addTarget:self action:@selector(VRModeChange:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _Cylinder;
}
-(UIButton *)Ball
{
    if (!_Ball) {
        _Ball = [[UIButton alloc]init];
        [_Ball setBackgroundImage:[UIImage imageNamed:@"VR_Ball_nor"] forState:UIControlStateNormal];
        [_Ball setBackgroundImage:[UIImage imageNamed:@"VR_Ball_sel"] forState:UIControlStateSelected];
        _Ball.tag = Shape_Ball;
        [_Ball addTarget:self action:@selector(VRModeChange:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _Ball;
}
-(UIButton *)BallBowl
{
    if (!_BallBowl) {
        _BallBowl = [[UIButton alloc]init];
        [_BallBowl setBackgroundImage:[UIImage imageNamed:@"VR-ball bowl_nor"] forState:UIControlStateNormal];
        [_BallBowl setBackgroundImage:[UIImage imageNamed:@"VR-ball bowl_sel"] forState:UIControlStateSelected];
        _BallBowl.tag = Shape_Ball_Bowl;
        [_BallBowl addTarget:self action:@selector(VRModeChange:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _BallBowl;
}
-(UIButton *)BallHat {
    if (!_BallHat) {
        _BallHat = [[UIButton alloc]init];
        [_BallHat setBackgroundImage:[UIImage imageNamed:@"VR_ball hat_nor"] forState:UIControlStateNormal];
        [_BallHat setBackgroundImage:[UIImage imageNamed:@"VR_ball hat_sel"] forState:UIControlStateSelected];
        _BallHat.tag = Shape_Ball_Hat;
        [_BallHat addTarget:self action:@selector(VRModeChange:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _BallHat;
}
-(UIButton *)Rectangle
{
    if (!_Rectangle) {
        _Rectangle = [[UIButton alloc]init];
        [_Rectangle setBackgroundImage:[UIImage imageNamed:@"VR-rectangle_nor"] forState:UIControlStateNormal];
        [_Rectangle setBackgroundImage:[UIImage imageNamed:@"VR-rectangle_sel"] forState:UIControlStateSelected];
        _Rectangle.tag = Shape_Rectangle;
        [_Rectangle addTarget:self action:@selector(VRModeChange:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _Rectangle;
}
-(UIButton *)Split
{
    if (!_Split) {
        _Split = [[UIButton alloc]init];
        [_Split setBackgroundImage:[UIImage imageNamed:@"VR-four_nor"] forState:UIControlStateNormal];
        [_Split setBackgroundImage:[UIImage imageNamed:@"VR-four_sel"] forState:UIControlStateSelected];
        _Split.tag = Shape_Grid_4R;
        [_Split addTarget:self action:@selector(VRModeChange:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _Split;
}
-(UIButton *)dichotomia
{
    if (!_dichotomia) {
        _dichotomia = [[UIButton alloc]init];
        [_dichotomia setBackgroundImage:[UIImage imageNamed:@"VR-tow_nor.png"] forState:UIControlStateNormal];
        [_dichotomia setBackgroundImage:[UIImage imageNamed:@"VR-tow_sel.png"] forState:UIControlStateSelected];
        _dichotomia.tag = Shape_Rectangle_2R;
        [_dichotomia addTarget:self action:@selector(VRModeChange:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _dichotomia;
}
-(UIButton *)threeR
{
    if (!_threeR) {
        _threeR = [[UIButton alloc]init];
        [_threeR setBackgroundImage:[UIImage imageNamed:@"180_3R_nor.png"] forState:UIControlStateNormal];
        [_threeR setBackgroundImage:[UIImage imageNamed:@"180_3R_sel.png"] forState:UIControlStateSelected];
        _threeR.tag = Shape_Grid_3R;
        [_threeR addTarget:self action:@selector(VRModeChange:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _threeR;
}

-(void)refreshShapeBtnSelectState{
    for (UIButton *btn in self.subviews) {
        if ([btn isKindOfClass:[UIButton class]] && btn.tag !=100 &&btn.tag !=101) {
            btn.selected = NO;
        }
    }
    if (self.Ball) {
        self.Ball.selected = YES;
    }
}

@end
