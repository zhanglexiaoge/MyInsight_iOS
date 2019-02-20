                                    //
//  main.m
//  XMFamily
//
//  Created by VladDracula on 14-8-4.
//  Copyright (c) 2014年 ___FULLUSERNAME___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iostream>
#import "AppDelegate.h" 
int main(int argc, char * argv[])
{
    @autoreleasepool {
//        struct sigaction sa;
//        sa.sa_handler = SIG_IGN;
//        sigaction( SIGPIPE, &sa, 0 );
        signal(SIGPIPE, SIG_IGN);
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
