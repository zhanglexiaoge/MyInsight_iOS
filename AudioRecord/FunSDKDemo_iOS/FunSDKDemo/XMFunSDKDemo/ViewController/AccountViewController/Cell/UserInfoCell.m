//
//  UserInfoCell.m
//  FunSDKDemo
//
//  Created by wujiangbo on 2018/11/1.
//  Copyright © 2018年 wujiangbo. All rights reserved.
//

#import "UserInfoCell.h"
#import <Masonry/Masonry.h>

@implementation UserInfoCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self makeUI];
    }
    
    return self;
}

#pragma mark -设置坐标
-(void)makeUI {
    
    [self addSubview:self.mainTitle];
    [self addSubview:self.descriptionTitle];
    
    [self.mainTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(10);
        make.width.equalTo(@100);
        make.height.equalTo(@30);
        make.centerY.equalTo(self);
    }];
    
    [self.descriptionTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-20);
        make.left.equalTo(self.mainTitle.mas_right).offset(10);
        make.centerY.equalTo(self);
    }];
    
}


#pragma mark - lazyload
-(UILabel *)mainTitle {
    if (!_mainTitle) {
        _mainTitle = [[UILabel alloc] init];
        _mainTitle.textColor = [UIColor blackColor];
        _mainTitle.font = [UIFont systemFontOfSize:15 weight:UIFontWeightLight];
    }
    return _mainTitle;
}

-(UILabel *)descriptionTitle {
    if (!_descriptionTitle) {
        _descriptionTitle = [[UILabel alloc] init];
        _descriptionTitle.textColor = [UIColor blackColor];
        _descriptionTitle.textAlignment = NSTextAlignmentRight;
        _descriptionTitle.font = [UIFont systemFontOfSize:15 weight:UIFontWeightLight];
    }
    return _descriptionTitle;
}

@end
