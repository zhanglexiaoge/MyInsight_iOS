//
//  AlarmMessageInfo.m
//  FunSDKDemo
//
//  Created by wujiangbo on 2018/12/1.
//  Copyright © 2018 wujiangbo. All rights reserved.
//

#import "AlarmMessageInfo.h"

@implementation AlarmMessageInfo
{
    NSDictionary *_json;
}
static AlarmMessageInfo* sharedJson = nil;

+ (AlarmMessageInfo *)shareInstance
{
    @synchronized(self)
    {
        if (sharedJson == nil) {
            sharedJson = [[AlarmMessageInfo alloc]init];
        }
        return sharedJson;
    }
}

- (void)parseJsonData:(NSData*)data
{
    NSError *error;
    if (data == nil) {
        return ;
    }
    _json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
}

- (NSString*)getChannel
{
    if (_json == nil) {
        return nil;
    }
    
    NSDictionary *dictonary = [_json objectForKey:@"AlarmInfo"];
    return [dictonary objectForKey:@"Channel"];
}

- (NSString*)getEvent
{
    if (_json == nil) {
        return nil;
    }
    
    NSDictionary *dictonary = [_json objectForKey:@"AlarmInfo"];
    const char * a =[[dictonary objectForKey:@"Event"] UTF8String];
    return [NSString stringWithUTF8String:a];
}

- (NSString*)getExtInfo
{
    if (_json == nil) return nil;
    
    NSDictionary *dictonary = [_json objectForKey:@"AlarmInfo"];
    NSString *extInfo = [dictonary objectForKey:@"ExtInfo"];
    
    if (extInfo.length > 0) {
        NSArray *infos = [extInfo componentsSeparatedByString:@","];
        if (infos.count >=3) {
            return infos[2];
        }
    }
    return extInfo;
}

- (NSString*)getStartTime
{
    if (_json == nil) {
        return nil;
    }
    
    NSDictionary *dictonary = [_json objectForKey:@"AlarmInfo"];
    return [dictonary objectForKey:@"StartTime"];
}

- (NSString*)getStatus
{
    if (_json == nil) {
        return nil;
    }
    
    NSDictionary *dictonary = [_json objectForKey:@"AlarmInfo"];
    const char * a =[[dictonary objectForKey:@"Status"] UTF8String];
    return TS(a);
}

- (NSString*)getPicSize{
    if (_json == nil) {
        return 0;
    }
    return [_json objectForKey:@"picSize"];
}

- (NSString*)getuId
{
    if (_json == nil) {
        return nil;
    }
    return [_json objectForKey:@"ID"];
}

- (NSString*)getSessionID
{
    if (_json == nil) {
        return nil;
    }
    return [_json objectForKey:@"SessionID"];
}

- (NSString*)getName
{
    if (_json == nil) {
        return nil;
    }
    return [_json objectForKey:@"Name"];
}


@end
