//
//  ObjectCoder.m
//  XMEye
//
//  Created by XM on 2018/4/6.
//  Copyright © 2018年 Megatron. All rights reserved.
//

#import "ObjectCoder.h"
#import <objc/runtime.h>

@interface ObjectCoder ()
{
    NSMutableArray *coderArray;
}
@end
@implementation ObjectCoder

// NSCopying
- (id)copyWithZone:(NSZone *)zone {
    [self getAllProperties];
    if (coderArray == nil || coderArray.count == 0) {
        return self;
    }
    ObjectCoder *copy = [[[self class] alloc] init];
    for (int i =0; i<coderArray.count; i++) {
        id value = [self valueForKey:[coderArray objectAtIndex:i]];
        if ([value isKindOfClass:[NSArray class]]) {
            value = [[NSMutableArray alloc] initWithArray:(NSMutableArray*)value copyItems:YES];
        }
        [copy setValue:value forKey:[coderArray objectAtIndex:i]];
    }
    return copy;
}
- (id)mutableCopyWithZone:(nullable NSZone *)zone {
    [self getAllProperties];
    if (coderArray == nil || coderArray.count == 0) {
        return self;
    }
    ObjectCoder *copy = [[[self class] alloc] init];
    for (int i =0; i<coderArray.count; i++) {
        id value = [self valueForKey:[coderArray objectAtIndex:i]];
        [copy setValue:value forKey:[coderArray objectAtIndex:i]];
    }
    return copy;
}
//对变量编码
- (void)encodeWithCoder:(NSCoder *)coder {
    [self getAllProperties];
    if (coderArray == nil || coderArray.count == 0) {
        return;
    }
    for (int i =0; i<coderArray.count; i++) {
        id value = [self valueForKey:[coderArray objectAtIndex:i]];
        [coder encodeObject:value forKey:[coderArray objectAtIndex:i]];
    }
}
//对变量解码
- (id)initWithCoder:(NSCoder *)coder {
    self = [super init];
    [self getAllProperties];
    if (coderArray == nil || coderArray.count == 0) {
        return self;
    }
    for (int i =0; i<coderArray.count; i++) {
        id value = [coder decodeObjectForKey:[coderArray objectAtIndex:i]];
        if (value != nil) {
            [self setValue:value forKey:[coderArray objectAtIndex:i]];
        }
    }
    
    return self;
}

//获取所有的属性名称字符串
- (NSArray *)getAllProperties {
    if (coderArray == nil) {
        u_int count;
        objc_property_t *properties  =class_copyPropertyList([self class], &count);
        coderArray = [NSMutableArray arrayWithCapacity:count];
        for (int i = 0; i<count; i++){
            const char* propertyName =property_getName(properties[i]);
            [coderArray addObject: [NSString stringWithUTF8String: propertyName]];
        }
        free(properties);
    }
    return coderArray;
}
@end
