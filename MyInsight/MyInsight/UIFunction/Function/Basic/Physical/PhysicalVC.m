//
//  PhysicalVC.m
//  MyInsight
//
//  Created by SongMenglong on 2018/4/23.
//  Copyright © 2018年 SongMenglong. All rights reserved.
//

#import "PhysicalVC.h"
#import <Masonry.h>
#import "PSDemoVC.h"

@interface PhysicalVC ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *dataArray;

@end

static const NSString *SnapActionStr = @"吸附行为";
static const NSString *PushActionStr = @"推动行为";
static const NSString *AttachmentActionStr = @"刚性附着行为";
static const NSString *SpringActionStr = @"弹性附着行为";
static const NSString *CollisionActionStr = @"碰撞检测";

@implementation PhysicalVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"物理仿真";
    
    self.dataArray = @[SnapActionStr, PushActionStr, AttachmentActionStr, SpringActionStr, CollisionActionStr];
    
    //[self creatTableFooterView];
    
    [self creatTableView];
}

- (void)creatTableView {
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
    }
    
    cell.textLabel.text = self.dataArray[indexPath.row];
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 获取到当前cell的字符串
    NSString *cellString = [self.dataArray objectAtIndex:indexPath.row];
    
    PSDemoVC *psDemoVC = [[PSDemoVC alloc] init];
    if ([cellString isEqual:SnapActionStr]) {
        psDemoVC.function = FunctionSnap;
    }
    if ([cellString isEqual:PushActionStr]) {
        psDemoVC.function = FunctionPush;
    }
    if ([cellString isEqual:AttachmentActionStr]) {
        psDemoVC.function = FunctionAttachment;
    }
    if ([cellString isEqual:SpringActionStr]) {
        psDemoVC.function = FunctionSpring;
    }
    if ([cellString isEqual:CollisionActionStr]) {
        psDemoVC.function = FunctionCollision;
    }
    psDemoVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:psDemoVC animated:YES];
}

- (void)creatTableFooterView {
    UILabel *label = [[UILabel alloc] init];
    label.text = @"一、简单介绍\n\
    \n\
    1.什么是UIDynamic\n\
    \n\
    UIDynamic是从iOS 7开始引入的一种新技术，隶属于UIKit框架\n\
    \n\
    可以认为是一种物理引擎，能模拟和仿真现实生活中的物理现象\n\
    \n\
    如：重力、弹性碰撞等现象\n\
    \n\
    \n\
    \n\
    2.物理引擎的价值\n\
    \n\
    广泛用于游戏开发，经典成功案例是“愤怒的小鸟”\n\
    \n\
    让开发人员可以在远离物理学公式的情况下，实现炫酷的物理仿真效果\n\
    \n\
    提高了游戏开发效率，产生更多优秀好玩的物理仿真游戏\n\
    \n\
    \n\
    \n\
    3.知名的2D物理引擎\n\
    \n\
    Box2d\n\
    \n\
    Chipmunk\n\
    \n\
    \n\
    \n\
    二、使用步骤\n\
    \n\
    要想使用UIDynamic来实现物理仿真效果，大致的步骤如下\n\
    \n\
    （1）创建一个物理仿真器（顺便设置仿真范围）\n\
    \n\
    （2）创建相应的物理仿真行为（顺便添加物理仿真元素）\n\
    \n\
    （3）将物理仿真行为添加到物理仿真器中开始仿真\n\
    \n\
    \n\
    \n\
    三、相关说明\n\
    \n\
    1.三个概念\n\
    \n\
    （1）谁要进行物理仿真？\n\
    \n\
    　　物理仿真元素（Dynamic Item）\n\
    \n\
    \n\
    \n\
    （2）执行怎样的物理仿真效果？怎样的动画效果？\n\
    \n\
    　　物理仿真行为（Dynamic Behavior）\n\
    \n\
    \n\
    \n\
    （3）让物理仿真元素执行具体的物理仿真行为\n\
    \n\
    　　物理仿真器（Dynamic Animator）\n\
    \n\
    \n\
    \n\
    2.物理仿真元素\n\
    \n\
    注意：\n\
    \n\
    不是任何对象都能做物理仿真元素\n\
    \n\
    不是任何对象都能进行物理仿真\n\
    \n\
    \n\
    \n\
    物理仿真元素要素：\n\
    \n\
    任何遵守了UIDynamicItem协议的对象\n\
    \n\
    UIView默认已经遵守了UIDynamicItem协议，因此任何UI控件都能做物理仿真\n\
    \n\
    UICollectionViewLayoutAttributes类默认也遵守UIDynamicItem协议\n\
    \n\
    \n\
    \n\
    3.物理仿真行为\n\
    \n\
    （1）UIDynamic提供了以下几种物理仿真行为\n\
    \n\
    UIGravityBehavior：重力行为\n\
    \n\
    UICollisionBehavior：碰撞行为\n\
    \n\
    UISnapBehavior：捕捉行为\n\
    \n\
    UIPushBehavior：推动行为\n\
    \n\
    UIAttachmentBehavior：附着行为\n\
    \n\
    UIDynamicItemBehavior：动力元素行为\n\
    \n\
    \n\
    \n\
    （2）物理仿真行为须知\n\
    \n\
    上述所有物理仿真行为都继承自UIDynamicBehavior\n\
    \n\
    所有的UIDynamicBehavior都可以独立进行\n\
    \n\
    组合使用多种行为时，可以实现一些比较复杂的效果\n\
    \n\
    \n\
    \n\
    \n\
    \n\
    4.物理仿真器\n\
    \n\
    （1）物理仿真器须知\n\
    \n\
    它可以让物理仿真元素执行物理仿真行为\n\
    \n\
    它是UIDynamicAnimator类型的对象\n\
    \n\
    \n\
    \n\
    （2）UIDynamicAnimator的初始化\n\
    \n\
    - (instancetype)initWithReferenceView:(UIView *)view;\n\
    \n\
    view参数：是一个参照视图，表示物理仿真的范围\n\
    \n\
    \n\
    \n\
    5.物理仿真器的说明\n\
    \n\
    （1）UIDynamicAnimator的常见方法\n\
    \n\
    　　- (void)addBehavior:(UIDynamicBehavior *)behavior;  　　//添加1个物理仿真行为\n\
    \n\
    　　- (void)removeBehavior:(UIDynamicBehavior *)behavior;　　//移除1个物理仿真行为\n\
    \n\
    　　- (void)removeAllBehaviors;  　　//移除之前添加过的所有物理仿真行为\n\
    \n\
    \n\
    \n\
    （2）UIDynamicAnimator的常见属性\n\
    \n\
    　　@property (nonatomic, readonly) UIView* referenceView;  //参照视图 \n\
    \n\
    　　@property (nonatomic, readonly, copy) NSArray* behaviors;//添加到物理仿真器中的所有物理仿真行为\n\
    \n\
    　　@property (nonatomic, readonly, getter = isRunning) BOOL running;//是否正在进行物理仿真\n\
    \n\
    　　@property (nonatomic, assign) id <UIDynamicAnimatorDelegate> delegate;//代理对象（能监听物理仿真器的仿真过程，比如开始和结束";
    
    //label.frame.size.width = [UIScreen mainScreen].bounds.size.width;
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view.mas_width).multipliedBy(1.0f);
    }];
    
    label.textColor = UIColor.blackColor;
    label.numberOfLines = 0;
    [label sizeToFit];
    
    self.tableView.tableFooterView = label;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
