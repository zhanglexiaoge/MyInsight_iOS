//
//  CoreFoundationVC.m
//  MyInsight
//
//  Created by SongMengLong on 2018/9/21.
//  Copyright © 2018年 SongMenglong. All rights reserved.
//

#import "CoreFoundationVC.h"
#import <CoreFoundation/CoreFoundation.h>

@interface CoreFoundationVC ()

@end

@implementation CoreFoundationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"core Foundation";
    
    [self test1];
    
}

- (void)test1 {
    CFStringRef str = CFSTR("HELLO");
    CFArrayRef array = CFArrayCreate(NULL, (const void**)&str, 1, &kCFTypeArrayCallBacks);
    CFShow(str);
    CFShow(array);
    CFShowStr(str);
    const char *cstring = "hello c";
    CFStringRef string = CFStringCreateWithCString(NULL, cstring, kCFStringEncodingUTF8);
    CFShow(string);
    CFRelease(string);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
