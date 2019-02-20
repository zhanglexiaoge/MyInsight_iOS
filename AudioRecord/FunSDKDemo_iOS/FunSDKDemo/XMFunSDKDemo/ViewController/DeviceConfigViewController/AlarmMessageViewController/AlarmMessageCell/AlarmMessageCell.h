//
//  AlarmMessageCell.h
//  FunSDKDemo
//
//  Created by wujiangbo on 2018/12/1.
//  Copyright © 2018 wujiangbo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol AlarmMessageCellDelegate <NSObject>

//点击开始下载报警原图
-(void)beginDownlaodAlarmPic:(int)index;

@end

@interface AlarmMessageCell : UITableViewCell

@property (nonatomic,strong) UILabel            *detailLabel;               //报警信息
@property (nonatomic,strong) UIImageView        *pushImageView;             //报警缩略图
@property (nonatomic,weak) id <AlarmMessageCellDelegate> delegate;
@property (nonatomic,assign) int index;

@end

NS_ASSUME_NONNULL_END
