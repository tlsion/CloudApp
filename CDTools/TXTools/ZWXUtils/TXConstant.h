//
//  ZWXConstant.h
//  ZWXLib
//
//  Created by paixie on 14-6-23.
//  Copyright (c) 2014年 zhenwanxiang. All rights reserved.
//

#ifndef ZWXLib_ZWXConstant_h
#define ZWXLib_ZWXConstant_h

#define IS_IOS_7 [[[UIDevice currentDevice] systemVersion] floatValue] >= 7
#define IS_IPHONE5  ( fabsl( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )


#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) //全局并发队列
#define kMainQueue dispatch_get_main_queue() //主线程队列

//格式化 字符串
#define NSStringFromat(format,...) [NSString stringWithFormat:(format), ##__VA_ARGS__]

//编码
#define ENC_GB1832 CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000)

#endif
