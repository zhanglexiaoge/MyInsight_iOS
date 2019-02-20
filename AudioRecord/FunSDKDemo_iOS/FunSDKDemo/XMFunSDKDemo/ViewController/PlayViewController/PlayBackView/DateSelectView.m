//
//  DateSelectView.m
//  XMEye
//
//  Created by XM on 2017/3/20.
//  Copyright © 2017年 Megatron. All rights reserved.
//

#import "DateSelectView.h"
@implementation DateSelectView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor colorWithRed:236/255.0 green:236/255.0 blue:236/255.0 alpha:1];
    self.tag = 1002;
    
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];//设置为英文显示
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *languageStr = [userDefaults objectForKey:@"Language_String"];
    
    if (languageStr == nil || [languageStr isEqualToString:@"auto"]) {
        
        NSArray *languages = [NSLocale preferredLanguages];
        NSString *currentLanguage = [languages objectAtIndex:0];
        if ([currentLanguage isContainsString:@"zh-Hans"]) {
            locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        }else if ([currentLanguage isContainsString:@"zh-Hant"]) {
            locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_TW"];
        }else if ([currentLanguage isContainsString:@"ko-"]) {
            locale = [[NSLocale alloc] initWithLocaleIdentifier:@"ko_KR"];
        }
    }else if ([languageStr isEqualToString:@"english"]){
        locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    }else if ([languageStr isEqualToString:@"zh_cn"]) {
        locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    }else if ([languageStr isEqualToString:@"zh_tw"]){
        locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_TW"];
    }else if ([languageStr isEqualToString:@"ko_kr"]){
        locale = [[NSLocale alloc] initWithLocaleIdentifier:@"ko_KR"];
    }
    
    UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, 0, 320, 200)];
    datePicker.center = CGPointMake(ScreenWidth * 0.5, ScreenHeight * 0.5);
    datePicker.datePickerMode = UIDatePickerModeDate;
    datePicker.minimumDate = [[NSDate alloc] initWithTimeIntervalSince1970:0];
    datePicker.maximumDate = [[NSDate alloc] initWithTimeIntervalSinceNow:0];
    datePicker.tag = 1003;
    datePicker.locale = locale;
    
    [self addSubview:datePicker];
    
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    confirmButton.frame = CGRectMake(ScreenWidth * 0.5 - 100, ScreenHeight * 0.5 + 130, 80, 30);
    [confirmButton setTitle:TS("OK") forState:UIControlStateNormal];
    confirmButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [confirmButton addTarget:self action:@selector(confirmSelectedAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:confirmButton];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    cancelButton.frame = CGRectMake(ScreenWidth * 0.5 + 40, ScreenHeight * 0.5 + 130, 80, 30);
    [cancelButton setTitle:TS("Cancel") forState:UIControlStateNormal];
    cancelButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [cancelButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelButton];
    
    self.hidden = YES;
    self.date = [NSDate date];
    return self;
}
-(void)dateSelectVIewShow{
    UIDatePicker *datePicker = (UIDatePicker *)[self viewWithTag:1003];
    datePicker.date = self.date;
    self.hidden = NO;
}
-(void)confirmSelectedAction{
    UIDatePicker *datePicker = (UIDatePicker *)[self viewWithTag:1003];
    self.date = datePicker.date;
    if ([self.delegate respondsToSelector:@selector(dateSelectedAction:)]) {
        [self.delegate dateSelectedAction:YES];
    }
    self.hidden = YES;
}
-(void)cancelAction{
    if ([self.delegate respondsToSelector:@selector(dateSelectedAction:)]) {
        [self.delegate dateSelectedAction:YES];
    }
    self.hidden = YES;
}
@end
