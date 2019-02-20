//
//  AlarmConfigTableViewCell.m
//  XMEye
//
//  Created by Levi on 2018/5/10.
//  Copyright © 2018年 Megatron. All rights reserved.
//

#import "AlarmConfigTableViewCell.h"

@implementation AlarmConfigTableViewCell

-(UISwitch *)mySwitch{
    if (!_mySwitch) {
        _mySwitch = [[UISwitch alloc] initWithFrame:CGRectMake(ScreenWidth - 70, 7, 50, 30)];
    }
    return _mySwitch;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configSubView];
    }
    return self;
}

-(void)configSubView{
    [self.contentView addSubview:self.mySwitch];
}

@end
