//
//  UserInputCell.h
//  XWorld
//
//  Created by dinglin on 2017/1/12.
//  Copyright © 2017年 xiongmaitech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserInputCell : UITableViewCell

@property (nonatomic) UILabel *customTitle;
@property (nonatomic) UITextField *inputTextField;
@property (nonatomic) UIImageView *iconImageView;

@property (nonatomic, copy) void (^toggleBtnClickedAction)(UIButton *);
@property (nonatomic) UIButton *toggleBtn;

@end
