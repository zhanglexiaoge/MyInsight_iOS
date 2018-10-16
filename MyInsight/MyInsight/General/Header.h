//
//  Header.h
//  MyInsight
//
//  Created by SongMenglong on 2018/1/26.
//  Copyright © 2018年 SongMenglong. All rights reserved.
//

#ifndef Header_h
#define Header_h


// 字体
#define AdaptedFontSize(R)     [UIFont systemFontOfSize:(R)]

#endif /* Header_h */

/*
 Instruments的Leaks检测内存泄漏
 http://blog.csdn.net/kevintang158/article/details/79027274
 
 关于Instruments工具中TimeProfiler和Leaks的归纳总结
 http://blog.csdn.net/huanglinxiao/article/details/79524331
 */

// 蓝牙 服务 特征
#define Data_Service @"FFFF"
#define Data_Character_Write @"FFFE"
#define Data_Character_Read @"FFFD" // Notice


//iOS10 权限崩溃问题
//https://www.jianshu.com/p/83db0b4f0bfe

// 判断设备是否是iPad
#define IS_IPAD ([[UIDevice currentDevice] respondsToSelector:@selector(userInterfaceIdiom)] && [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)



