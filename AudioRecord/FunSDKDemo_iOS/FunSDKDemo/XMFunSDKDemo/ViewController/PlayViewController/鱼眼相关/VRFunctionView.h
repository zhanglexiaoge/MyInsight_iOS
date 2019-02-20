//
//  VRFunctionView.h
//  XMEye
//
//  Created by riceFun on 16/12/1.
//  Copyright © 2016年 Megatron. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VRSoft.h"
@protocol VRFunctionViewDelegate <NSObject>
@optional
-(void)changeVRFunctionMode:(_XMVRShape)type WithWarOrCeiling:(int)model;
@end
@interface VRFunctionView : UIView

@property (nonatomic, strong) UIView *menuView;//显示整个鱼眼显示选项的View

@property (nonatomic, strong) UIButton *war;//装在墙壁上;
@property (nonatomic, strong) UIButton *ceiling;//装在天花板上

@property (nonatomic, strong) UIButton *Ball;//球 Shape_Ball
@property (nonatomic, strong) UIButton *Rectangle;//矩形 Shape_Cylinder

@property (nonatomic, strong) UIButton *BallBowl; //碗状和Ball_Hat相反 Shape_Ball_Bowl
@property (nonatomic, strong) UIButton *BallHat;// 球/半球,帽子型 Shape_Ball_Hat
@property (nonatomic, strong) UIButton *Cylinder;//圆柱 Shape_Cylinder
@property (nonatomic, strong) UIButton *Split; //四分按钮
@property (nonatomic, strong) UIButton *dichotomia;//二分按钮
@property (nonatomic, strong) UIButton *threeR; //3画面

@property (nonatomic, strong) UIView *modeView;
@property (nonatomic, strong) UIButton *closeMode;//最左边打开(关闭)menuView

@property (nonatomic, strong) NSMutableArray *functionBtnArray;

@property (nonatomic) BOOL is180VR;//是否是水平全景VR
@property (nonatomic, assign) id <VRFunctionViewDelegate> delegate;

@property (nonatomic,assign) int VRType;


-(instancetype)initWithFrame:(CGRect)frame VRType:(int)is180VR;//初始化，传入VR模式
-(void)layoutVRFunctionView:(BOOL)isCeiling;//刷新模式和界面
-(void)delegateChangeVRMode:(_XMVRShape)type;
-(void)refreshShapeBtnSelectState;
@end
