//
//  UserInputCell.m
//  XWorld
//
//  Created by dinglin on 2017/1/12.
//  Copyright © 2017年 xiongmaitech. All rights reserved.
//

#import "UserInputCell.h"
#import <Masonry/Masonry.h>

@implementation UserInputCell

#pragma mark - lazyload
-(UILabel *)customTitle {
    if (!_customTitle) {
        _customTitle = [[UILabel alloc] init];
        _customTitle.textColor = [UIColor blackColor];
        _customTitle.font = [UIFont systemFontOfSize:12 weight:UIFontWeightLight];
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

-(UIButton *)toggleBtn {
    if (!_toggleBtn) {
        _toggleBtn = [[UIButton alloc] init];
        [_toggleBtn setImage:[UIImage imageNamed:@"icon_hide_nor.png"] forState:UIControlStateNormal];
        [_toggleBtn setImage:[UIImage imageNamed:@"icon_hide_sel.png"] forState:UIControlStateSelected];

    }
    return _toggleBtn;
}

#pragma mark -设置坐标
-(void)makeUI {
    
    [self.contentView addSubview:self.customTitle];
    [self.contentView addSubview:self.inputTextField];
    [self.contentView addSubview:self.toggleBtn];
    
    [self.toggleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-10);
        make.width.equalTo(@30);
        make.height.equalTo(@30);
        make.centerY.equalTo(self.contentView);
    }];
    
    [self.customTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.width.equalTo(@70);
        make.centerY.equalTo(self.contentView);
        make.height.equalTo(@30);
    }];
    
    [self.inputTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.toggleBtn.mas_left).offset(-5);
        make.left.equalTo(self.customTitle.mas_right).offset(6);
        make.centerY.equalTo(self.contentView);
    }];
    
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self makeUI];
    }
    
    return self;
}


@end
