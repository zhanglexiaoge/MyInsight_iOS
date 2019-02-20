//
//  UserInfoView.m
//  FunSDKDemo
//
//  Created by wujiangbo on 2018/11/1.
//  Copyright © 2018年 wujiangbo. All rights reserved.
//

#import "UserInfoView.h"
#import <Masonry/Masonry.h>
#import "UserInfoCell.h"

@interface UserInfoView()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation UserInfoView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:self.tbUserInfo];
        
        //布局
        [self configSubView];
    }
    
    return self;
}

#pragma mark - 控件布局
-(void)configSubView
{
    [self.tbUserInfo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self);
        make.height.equalTo(self);
        make.top.equalTo(@64);
        make.left.equalTo(self);
    }];
}

#pragma mark - tableViewDataSource/Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 4;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UserInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserInfoCell"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    switch (indexPath.row) {
        case 0:
        {
            cell.mainTitle.text = TS("username");
            cell.descriptionTitle.text = [[LoginShowControl getInstance] getLoginUserName];
        }
            break;
        case 1:
        {
            cell.mainTitle.text = TS("password");
            cell.descriptionTitle.text = [[LoginShowControl getInstance] getLoginPassword];
        }
            break;
        case 2:
        {
            cell.mainTitle.text = TS("bind_phoneNumber");
            if (self.infoDic) {
                cell.descriptionTitle.text = [self.infoDic objectForKey:@"phone"];
            }
            //判断当前是否有显示绑定手机，没有则显示跳转箭头
            if ([cell.descriptionTitle.text isEqualToString:@""]) {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            else{
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }
            break;
        case 3:
        {
            cell.mainTitle.text = TS("bind_email_address");
            if (self.infoDic) {
                cell.descriptionTitle.text = [self.infoDic objectForKey:@"mail"];
            }
            //判断当前是否有显示绑定邮箱，没有则显示跳转箭头
            if ([cell.descriptionTitle.text isEqualToString:@""]) {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            else{
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }
            break;
            default:
            break;
            
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *title = @"";
    if (indexPath.row == 2) {        //点击绑定手机
        if (self.infoDic) {
           title  = [self.infoDic objectForKey:@"phone"];
            if ([title isEqualToString:@""]) {
                if (self.clickBindAccount) {
                    self.clickBindAccount(TS("bind_phoneNumber"));
                }
            }
        }
    }
    else if (indexPath.row == 3)    //点击绑定邮箱
    {
        if (self.infoDic) {
            title  = [self.infoDic objectForKey:@"mail"];
            if ([title isEqualToString:@""]) {
                if (self.clickBindAccount) {
                    self.clickBindAccount(TS("bind_email_address"));
                }
            }
        }
    }
}

#pragma mark -lazyLoad
-(UITableView *)tbUserInfo
{
    if (!_tbUserInfo) {
        _tbUserInfo = [[UITableView alloc] init];
        _tbUserInfo.delegate = self;
        _tbUserInfo.dataSource = self;
        _tbUserInfo.scrollEnabled = NO;
        [_tbUserInfo registerClass:[UserInfoCell class] forCellReuseIdentifier:@"UserInfoCell"];
        _tbUserInfo.tableFooterView = [[UIView alloc] init];
    }
    
    return _tbUserInfo;
}

@end
