//
//  AddDeviceInputCell.m
//  FunSDKDemo
//
//  Created by wujiangbo on 2018/11/12.
//  Copyright © 2018年 wujiangbo. All rights reserved.
//

#import "AddDeviceInputCell.h"
#import <Masonry/Masonry.h>

@implementation AddDeviceInputCell

#pragma mark - lazyload
-(UILabel *)customTitle {
    if (!_customTitle) {
        _customTitle = [[UILabel alloc] init];
        _customTitle.textColor = [UIColor blackColor];
        _customTitle.font = [UIFont systemFontOfSize:13 weight:UIFontWeightLight];
    }
    return _customTitle;
}

-(UITextField *)inputTextField {
    if (!_inputTextField) {
        _inputTextField = [[UITextField alloc] init];
        _inputTextField.textColor = [UIColor blackColor];
    }
    return _inputTextField;
}

#pragma mark - 设置坐标
-(void)makeUI {
    
    [self.contentView addSubview:self.customTitle];
    [self.contentView addSubview:self.inputTextField];
    
    [self.customTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.width.equalTo(@90);
        make.height.equalTo(@30);
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.inputTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.left.equalTo(self.customTitle.mas_right).offset(6);
        make.centerY.equalTo(self.contentView);
    }];
    
}

#pragma mark - 初始化
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self makeUI];
    }
    
    return self;
}


@end
