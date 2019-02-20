//
//  DeviceconfigTableViewCell.m
//  FunSDKDemo
//
//  Created by Levi on 2018/5/18.
//  Copyright © 2018年 Levi. All rights reserved.
//

#import "DeviceconfigTableViewCell.h"

@implementation DeviceconfigTableViewCell

- (UIImageView *)logoImageView {
    if (!_logoImageView) {
        _logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 8, 44, 44)];
        _logoImageView.image = [UIImage imageNamed:@"icon_funsdk.png"];
    }
    return _logoImageView;
}

- (UILabel *)Labeltext {
    if (!_Labeltext) {
        _Labeltext = [[UILabel alloc] initWithFrame:CGRectMake(64, 9, ScreenWidth - 64, 22)];
    }
    return _Labeltext;
}

- (UILabel *)detailLabel {
    if (!_detailLabel) {
        _detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(64, 34, ScreenWidth - 64, 15)];
        _detailLabel.font = [UIFont systemFontOfSize:12];
        _detailLabel.textColor = [UIColor grayColor];
        
    }
    return _detailLabel;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configSubView];
        
    }
    return self;
}

- (void)configSubView {
    [self.contentView addSubview:self.logoImageView];
    [self.contentView addSubview:self.Labeltext];
    [self.contentView addSubview:self.detailLabel];
}
@end
