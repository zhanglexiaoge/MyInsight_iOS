//
//  EncodeDataSourse.m
//  FunSDKDemo
//
//  Created by XM on 2018/10/25.
//  Copyright © 2018年 XM. All rights reserved.
//

#import "EncodeDataSourse.h"

@interface EncodeDataSourse ()
{
    NSArray *resolutionArray;
}
@end

@implementation EncodeDataSourse

#pragma mark - 根据画质int值获取画质名
- (NSString *)getQualityString:(NSInteger)quality {
    NSArray *array = [self getQualityArray];
    if (quality >0 && quality <7) {
        //如果获取到的数据在正常数据范围内
        return array[quality-1];
    }
    //数据异常时也要返回
    return array[0];
}
#pragma mark  根据画质名称值获取画质int值
- (NSInteger)getQualityInt:(NSString*)qualityString {
    NSArray *array = [self getQualityArray];
    if ([array containsObject:qualityString]) {
        return [array indexOfObject:qualityString]+1;
    }
    //数据异常时也要返回
    return 0;
}

#pragma mark - 获取开关字符串
-(NSString *)getEnableString:(BOOL)enable {
    NSArray *array = [self getEnableArray];
    return array[enable];
}
#pragma mark  获取开关BOOL值
-(BOOL)getEnableBool:(NSString *)enableStr {
    NSArray *array = [self getEnableArray];
    if ([array containsObject:enableStr]) {
        return [array indexOfObject:enableStr];
    }
    return NO;
}

#pragma mark - 根据索引获取当前分辨率名称
-(NSString*)getResolotionName:(NSInteger)nResIndex {
    if (resolutionArray == nil) {
        resolutionArray = [self getResolutionArray];
    }
    if (nResIndex >= 0 && nResIndex < N_RESOLUTION_COUNT) {
        return resolutionArray[nResIndex];
    }
    return resolutionArray[0];
}
#pragma mark  根据分辨率名称获取当前索引
- (NSInteger)getResolutionIndex:(NSString*)name {
    if (resolutionArray == nil) {
        resolutionArray = [self getResolutionArray];
    }
    return (int)[resolutionArray indexOfObject:name];
}

#pragma mark 根据传递的可用能力级、帧率、支持的分辨率来获取当前可用的分辨率
- (NSInteger)getResolutionMark:(NSInteger)size rate:(NSInteger)fps  range:(NSInteger)support {
    NSInteger nRetMark = 0;
    NSInteger nGetRes = 0;
    //在所有的分辨率中循环判断
    //判断当前循环的分辨率是否支持
    for (int i = 0; i < N_RESOLUTION_COUNT; ++i) {
        if (support & (0x1 << i)) {
            //获取分辨率大小
            nGetRes = [self getResolutionSize:i];
            //分辨率*帧率<可用能力级，说明这个分辨率是可用的
            if (nGetRes * fps <= size) {
                nRetMark |= (0x1 << i);
            }
        }
    }
    return nRetMark; //二进制数据，二进制中的某一位是1的话，说明支持对应位置的分辨率
}
#pragma mark 根据当前可用的分辨率二进制来获取分辨率名称字符串
- (NSMutableArray*)getResolutionArrayWithMark:(NSInteger)support {
    NSMutableArray *markArray = [[NSMutableArray alloc] initWithCapacity:0];
    //在所有的分辨率中循环判断
    for (int i = 0; i< N_RESOLUTION_COUNT ; i++) {
        //判断当前循环的分辨率是否支持
        if (support & (0x01<<i)) {
            //如果支持的话，获取对应的分辨率名称
            NSArray *resolutionNameArray = [self getResolutionArray];
            NSString *mask =[resolutionNameArray objectAtIndex:i];
            //添加进数组
            [markArray addObject:mask];
        }
    }
    return markArray;
}
#pragma mark 根据索引获取当前分辨率大小
-(NSInteger)getResolutionSize:(NSInteger)nResIndex {
    static int s_fps[] = {
        704*576,//D1
        704*288,//HD1
        352*576,//BCIF
        352*288,//CIF
        176*144,//QCIF
        640*480,//VGA
        320*240,//QVGA
        480*480,//SVCD
        160*128,//QQVGA
        240*192,//ND1     9
        928*576,//650TVL
        1280*720,//720P
        1280*960,//1_3M
        1600*1200,//UXGA
        1920*1080,//1080P
        1920*1200,//WUXGA
        1872*1408,//2_5M
        2048*1536,//3M
        3744*1408,//5M
        960*1080,//1080N
        2592*1520,//4M
        3072*2048,//6M
        3264*2448,//8M
        4000*3000,//12M
        4096*2160,//4K
        640*720,//720N
        1024*576,//WSVGA
        640*360,//NHD
        1024*1536,//3M_N
        1280*1440,//4M_N
        1872*1408,//5M_N
        2048*2106,//4K_N
    };
    if (nResIndex >= 0 && nResIndex < N_RESOLUTION_COUNT) {
        return s_fps[nResIndex];
    }
    return s_fps[0];
}
//NSTC下分辨率大小稍微有些不同，单独列出来供NSTC读取
-(NSInteger)getResolutionSizeNSTC:(NSInteger)nResIndex {
    static int s_fps[] = {
        704*480,//D1
        704*240,//HD1
        352*480,//BCIF
        352*240,//CIF
        176*120,//QCIF
        640*480,//VGA
        320*240,//QVGA
        480*480,//SVCD
        160*128,//QQVGA
        240*192,//ND1     9
        928*576,//650TVL
        1280*720,//720P
        1280*960,//1_3M
        1600*1200,//UXGA
        1920*1080,//1080P
        1920*1200,//WUXGA
        1872*1408,//2_5M
        2048*1536,//3M
        3744*1408,//5M
        960*1080,//1080N
        2592*1520,//4M
        3072*2048,//6M
        3264*2448,//8M
        4000*3000,//12M
        4096*2160,//4K
        640*720,//720N
        1024*576,//WSVGA
        640*360,//NHD
        1024*1536,//3M_N
        1280*1440,//4M_N
        1872*1408,//5M_N
        2048*2106,//4K_N
    };
    if (nResIndex >= 0 && nResIndex < N_RESOLUTION_COUNT) {
        return s_fps[nResIndex];
    }
    return s_fps[0];
}
- (NSArray*)getResolutionArray {
    NSArray *array = [NSArray arrayWithObjects:
                       @"D1",           /// < 704*576(PAL)    704*480(NTSC)
                       @"HD1",        ///< 352*576(PAL)    352*480(NTSC)
                       @"BCIF",        ///< 720*288(PAL)    720*240(NTSC)
                       @"CIF",          ///< 352*288(PAL)    352*240(NTSC)
                       @"QCIF",        ///< 176*144(PAL)    176*120(NTSC)
                       @"VGA",        ///< 640*480(PAL)    640*480(NTSC)
                       @"QVGA",        ///< 320*240(PAL)    320*240(NTSC)
                       @"SVCD",        ///< 480*480(PAL)    480*480(NTSC)
                       @"QQVGA",        ///< 160*128(PAL)    160*128(NTSC)
                       @"ND1",          ///< 240*192
                       @"650TVL",      ///< 926*576
                       @"720P",         ///< 1280*720
                       @"1_3M",        ///< 1280*960
                       @"UXGA ",       ///< 1600*1200
                       @"1080P",        ///< 1920*1080
                       @"WUXGA",        ///< 1920*1200
                       @"2_5M",        ///< 1872*1408
                       @"3M",             ///< 2048*1536
                       @"5M",             //   < 3744*1408
                       @"1080N",          ///< 960*1080
                       @"4M",                ///< 2592*1520
                       @"6M",           ///< 3072*2048
                       @"8M",                ///< 3264*2448
                       @"12M",                ///< 4000*3000
                       @"4K",              ///< 4096 * 2160/3840*2160
                       @"720N",          //  640*720
                       @"WSVGA",        ///< 1024*576
                       @"NHD",             // Wi-Fi IPC 640*360
                       @"3M_N",         // 1024*1536
                       @"4M_N",          // 1280*1440
                       @"5M_N",         // 1872*1408
                       @"4K_N",            // 2048*2106
                       @"V3_NR",
                       nil];
    return array;
}
- (NSArray *)getQualityArray {
    NSArray *array = @[TS("Bad"), TS("Poor"), TS("General"), TS("Good"), TS("Better"), TS("Best")];
    return array;
}
- (NSArray *)getEnableArray {
    NSArray *array = @[TS("close"), TS("open")];
    return array;
}
@end
