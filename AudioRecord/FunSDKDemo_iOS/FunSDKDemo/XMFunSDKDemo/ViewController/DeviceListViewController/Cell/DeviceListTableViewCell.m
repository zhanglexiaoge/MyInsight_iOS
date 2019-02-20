//
//  DeviceListTableViewCell.m
//  FunSDKDemo
//
//  Created by Levi on 2018/5/18.
//  Copyright © 2018年 Levi. All rights reserved.
//

#import "DeviceListTableViewCell.h"

@implementation DeviceListTableViewCell

- (UIImageView *)devImageV {
    if (!_devImageV) {
        _devImageV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
        _devImageV.image = [UIImage imageNamed:@"xmjp_seye.png"];
        
    }
    return _devImageV;
}

- (UIImageView *)onlineState {
    if (!_onlineState) {
        _onlineState = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth -85, 10, 75, 29)];
    }
    return _onlineState;
}

- (UILabel *)devName {
    if (!_devName) { 
        _devName = [[UILabel alloc] initWithFrame:CGRectMake(60, 13, ScreenWidth - 60, 34)];
        _devName.font = [UIFont systemFontOfSize:18];
        _devName.text = TS("");
    }
    return _devName;
}

- (UILabel *)devType {
    if (!_devType) {
        _devType = [[UILabel alloc] initWithFrame:CGRectMake(60, 50, 100, 30)];
        _devType.text = TS("device_type");
    }
    return _devType;
}

- (UILabel *)devTypeLab {
    if (!_devTypeLab) {
        _devTypeLab = [[UILabel alloc] initWithFrame:CGRectMake(180, 50, ScreenWidth - 180, 30)];
        _devTypeLab.text = TS("雄迈摇头机");
    }
    return _devTypeLab;
}


- (UILabel *)devSN {
    if (!_devSN) {
        _devSN = [[UILabel alloc] initWithFrame:CGRectMake(60, 80, 120, 30)];
        _devSN.text = TS("serial_number");
    }
    return _devSN;
}

- (UILabel *)devSNLab {
    if (!_devSNLab) {
        _devSNLab = [[UILabel alloc] initWithFrame:CGRectMake(180, 80, ScreenWidth - 180, 30)];
        _devSNLab.text = TS("f893868a28d45392");
    }
    return _devSNLab;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self configSubView];
    }
    return self;
}

- (void)configSubView {
    [self.contentView addSubview:self.devImageV];
    [self.contentView addSubview:self.devName];
    [self.contentView addSubview:self.devType];
    [self.contentView addSubview:self.devTypeLab];
    [self.contentView addSubview:self.devSN];
    [self.contentView addSubview:self.devSNLab];
    [self.contentView addSubview:self.onlineState];
}
//设备在线状态
- (void)setDeviceState:(int)state {
    if (state >0) {
        _onlineState.image = [UIImage imageNamed:@"online.png"];
    }else{
         _onlineState.image = [UIImage imageNamed:@"offline.png"];
    }
}
//EFunDevState 0 未知 1 唤醒 2 睡眠 3 不能被唤醒的休眠 4正在准备休眠
- (void)setSleepType:(int)type {
    if (type == 4) {
        _onlineState.image = [UIImage imageNamed:@"Prepare_sleep.png"];
    }else if (type == 3){
        _onlineState.image = [UIImage imageNamed:@"sleepnotwakeup.png"];
    }else if (type == 2){
        _onlineState.image = [UIImage imageNamed:@"ic_sleep.png"];
    }
}
@end
