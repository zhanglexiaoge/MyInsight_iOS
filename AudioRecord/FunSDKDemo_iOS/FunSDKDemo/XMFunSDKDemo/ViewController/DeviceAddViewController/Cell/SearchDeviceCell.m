//
//  SearchDeviceCell.m
//  FunSDKDemo
//
//  Created by wujiangbo on 2018/11/15.
//  Copyright © 2018年 wujiangbo. All rights reserved.
//

#import "SearchDeviceCell.h"
#import <Masonry/Masonry.h>

@implementation SearchDeviceCell


#pragma mark - lazyload
-(UILabel *)nameLab {
    if (!_nameLab) {
        _nameLab = [[UILabel alloc] init];
        _nameLab.textColor = [UIColor blackColor];
        _nameLab.font = [UIFont boldSystemFontOfSize:15];
    }
    return _nameLab;
}

-(UILabel *)serialNumLab {
    if (!_serialNumLab) {
        _serialNumLab = [[UILabel alloc] init];
        _serialNumLab.textColor = [UIColor blackColor];
        _serialNumLab.font = [UIFont systemFontOfSize:13 weight:UIFontWeightLight];
    }
    return _serialNumLab;
}

-(UILabel *)ipLab {
    if (!_ipLab) {
        _ipLab = [[UILabel alloc] init];
        _ipLab.textColor = [UIColor blackColor];
        _ipLab.font = [UIFont systemFontOfSize:13 weight:UIFontWeightLight];
    }
    return _ipLab;
}

#pragma mark - 设置坐标
-(void)makeUI {
    
    [self.contentView addSubview:self.nameLab];
    [self.contentView addSubview:self.serialNumLab];
    [self.contentView addSubview:self.ipLab];
    
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.width.equalTo(@300);
        make.height.equalTo(@20);
        make.top.equalTo(self.contentView).offset(5);
    }];
    
    [self.serialNumLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.width.equalTo(@300);
        make.height.equalTo(@20);
        make.top.equalTo(self.nameLab.mas_bottom).offset(5);
    }];
    
    [self.ipLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(10);
        make.width.equalTo(@300);
        make.height.equalTo(@20);
        make.top.equalTo(self.serialNumLab.mas_bottom).offset(5);
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
