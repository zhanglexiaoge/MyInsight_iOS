//
//  XMDownloadResource.m
//  XWorld
//
//  Created by DingLin on 17/2/9.
//  Copyright © 2017年 xiongmaitech. All rights reserved.
//

#import "CLouldVideoResource.h"

@implementation CLouldVideoResource

-(instancetype)init {
    self = [super init];

    if (self) {
        _name = @"";
        _beginDate = @"";
        _endDate = @"";
        _beginTime = @"";
        _endTime = @"";
        _progress = 0.0f;
        _devId = @"";
        _size = 0;
        _indexFile = @"";
        _downloadState = DownloadStateNot;
    }
    return self;
}

//将对象编码(即:序列化)
-(void) encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_indexFile forKey:@"indexFile"];
    [aCoder encodeObject:_name forKey:@"name"];
    [aCoder encodeObject:_beginDate forKey:@"beginDate"];
    [aCoder encodeObject:_endDate forKey:@"endDate"];
    [aCoder encodeObject:_beginTime forKey:@"beginTime"];
    [aCoder encodeObject:_endTime forKey:@"endTime"];
    [aCoder encodeFloat:_progress forKey:@"progress"];

    [aCoder encodeObject:_JsonStr forKey:@"JsonStr"];
    [aCoder encodeObject:_devId forKey:@"devId"];
    [aCoder encodeInteger:_size forKey:@"size"];

}

//将对象解码(反序列化)
-(id) initWithCoder:(NSCoder *)aDecoder {
    if (self=[super init]) {
        _indexFile = [aDecoder decodeObjectForKey:@"indexFile"];
        _name = [aDecoder decodeObjectForKey:@"name"];
        _beginDate = [aDecoder decodeObjectForKey:@"beginDate"];
        _endDate = [aDecoder decodeObjectForKey:@"endDate"];
        _beginTime = [aDecoder decodeObjectForKey:@"beginTime"];
        _endTime = [aDecoder decodeObjectForKey:@"endTime"];
        _progress = [aDecoder decodeFloatForKey:@"progress"];

        _JsonStr = [aDecoder decodeObjectForKey:@"JsonStr"];
        _devId = [aDecoder decodeObjectForKey:@"devId"];
        _size = [aDecoder decodeIntegerForKey:@"size"];

    }
    return (self);
}

@end
