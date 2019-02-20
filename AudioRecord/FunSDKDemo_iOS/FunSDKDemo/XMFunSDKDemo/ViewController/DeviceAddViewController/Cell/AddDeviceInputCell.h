//
//  AddDeviceInputCell.h
//  FunSDKDemo
//
//  Created by wujiangbo on 2018/11/12.
//  Copyright © 2018年 wujiangbo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AddDeviceInputCell : UITableViewCell

@property (nonatomic,strong) UILabel *customTitle;
@property (nonatomic,strong) UITextField *inputTextField;       
@property (nonatomic,strong) UIButton *codeBtn;                  //二维码按钮

@end

NS_ASSUME_NONNULL_END
