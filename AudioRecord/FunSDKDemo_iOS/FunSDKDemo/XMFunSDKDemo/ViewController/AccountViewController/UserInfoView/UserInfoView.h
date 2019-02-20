//
//  UserInfoView.h
//  FunSDKDemo
//
//  Created by wujiangbo on 2018/11/1.
//  Copyright © 2018年 wujiangbo. All rights reserved.
//

/**
 
 用户信息显示界面视图
 */

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserInfoView : UIView

@property (nonatomic, copy) void(^clickBindAccount)(NSString *titleStr);     //获取验证码

@property (nonatomic, strong) UITableView *tbUserInfo;      //视图列表
@property (nonatomic, strong) NSMutableDictionary *infoDic; //用户信息数据

@end

NS_ASSUME_NONNULL_END
