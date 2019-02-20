//
//  TalkView.h
//  XMEye
//
//  Created by Wangchaoqun on 15/7/4.
//  Copyright (c) 2015年 Megatron. All rights reserved.
//
/******
 *
 *对讲界面
 *
 *
 */

#import <UIKit/UIKit.h>

@protocol TalKViewDelegate <NSObject>
@optional
/*! @berif 打开通话视图 */
- (void)openTalkView;
/*! @berif 关闭通话视图 */
- (void)closeTalkView;
/*! @berif 开始通话    */
- (void)openTalk;
/*! @berif 关闭通话    */
- (void)closeTalk;
@end

@interface TalkView : UIView

//开始对讲
@property (nonatomic,retain) UIButton *talkButton;

//关闭对讲
@property (nonatomic,retain) UIButton *cannelButton;

@property (nonatomic,retain) id<TalKViewDelegate> delegate;

/*! @berif 显示视图 */
- (void)showTheView;
- (void)cannelTheView;//隐藏视图
@end
