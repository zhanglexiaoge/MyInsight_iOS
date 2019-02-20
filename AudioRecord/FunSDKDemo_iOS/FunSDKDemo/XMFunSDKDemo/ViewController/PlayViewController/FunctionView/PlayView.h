//
//  PlayView.h
//  XMEye
//
//  Created by XM on 2018/7/21.
//  Copyright © 2018年 Megatron. All rights reserved.
//

/******
 *
 *播放窗口界面view
 *如果想要自定义这个类，那么必须要有 +(Class)layerClass 方法
 *
 */

#import <UIKit/UIKit.h>

@interface PlayView : UIView

@property (nonatomic,strong) UIActivityIndicatorView *activityView;  // 加载状态图标
#pragma mark  刷新界面图标
- (void)refreshView;
- (void)playViewBufferIng; //正在缓冲
- (void)playViewBufferEnd;//缓冲完成
- (void)playViewBufferStop;//预览失败
@end
