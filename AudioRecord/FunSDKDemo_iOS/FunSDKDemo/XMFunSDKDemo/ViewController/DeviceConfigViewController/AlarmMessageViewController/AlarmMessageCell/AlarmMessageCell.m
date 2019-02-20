//
//  AlarmMessageCell.m
//  FunSDKDemo
//
//  Created by wujiangbo on 2018/12/1.
//  Copyright © 2018 wujiangbo. All rights reserved.
//

#import "AlarmMessageCell.h"
#import <Masonry/Masonry.h>

@implementation AlarmMessageCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.pushImageView];
        [self addSubview:self.detailLabel];
        
        //布局
        [self configSubView];
    }
    return self;
}

-(void)configSubView{
    [self.pushImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@10);
        make.width.equalTo(@100);
        make.height.equalTo(@64);
        make.centerY.equalTo(self);
    }];
    
    [self.detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.pushImageView.mas_right).offset(10);
        make.right.equalTo(self).offset(-10);
        make.centerY.equalTo(self);
        make.height.equalTo(@64);
    }];
}

#pragma mark - button event 点击下载原图
- (void)tapHandle:(UITapGestureRecognizer *)tap {
    if (self.delegate && [self.delegate respondsToSelector:@selector(beginDownlaodAlarmPic:)]) {
        [self.delegate beginDownlaodAlarmPic:self.index];
    }
}

#pragma mark - lazyload
- (UIImageView*)pushImageView
{
    if (_pushImageView == nil) {
        _pushImageView = [[UIImageView alloc] init];
        _pushImageView.backgroundColor = [UIColor whiteColor];
        _pushImageView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapHandle:)];
        [_pushImageView addGestureRecognizer:gesture];
    }
    return _pushImageView;
}

-(UILabel *)detailLabel{
    if (_detailLabel == nil) {
        _detailLabel = [[UILabel alloc] init];
        _detailLabel.backgroundColor = [UIColor clearColor];
        _detailLabel.text = @"";
        _detailLabel.numberOfLines = 0;
    }
        return _detailLabel;
}

@end
