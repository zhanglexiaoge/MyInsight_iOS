//
//  FunMsgListener.m
//  XWorld
//
//  Created by liuguifang on 16/5/23.
//  Copyright © 2016年 xiongmaitech. All rights reserved.
//

#import "FunMsgListener.h"

@implementation FunMsgListener

-(instancetype)init{
    
    self.msgHandle = FUN_RegWnd((__bridge LP_WND_OBJ)self);
    return self;
    
}

-(void)dealloc{
    
    FUN_UnRegWnd(self.msgHandle);
    self.msgHandle = -1;
    
}

@end
