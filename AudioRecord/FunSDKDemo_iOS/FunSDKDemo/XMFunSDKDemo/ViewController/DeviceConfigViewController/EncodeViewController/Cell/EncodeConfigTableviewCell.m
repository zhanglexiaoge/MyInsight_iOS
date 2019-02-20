//
//  EncodeConfigTableviewCell.m
//  FunSDKDemo
//
//  Created by XM on 2018/11/5.
//  Copyright © 2018年 XM. All rights reserved.
//

#import "EncodeConfigTableviewCell.h"

@implementation EncodeConfigTableviewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configSubView];
    }
    return self;
}

- (void)configSubView {
    [self.contentView addSubview:self.Labeltext];
}
- (UILabel *)Labeltext {
    if (!_Labeltext) {
        _Labeltext = [[UILabel alloc] initWithFrame:CGRectMake(0,0, ScreenWidth-60, 44)];
        _Labeltext.textAlignment = NSTextAlignmentRight;
    }
    return _Labeltext;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
