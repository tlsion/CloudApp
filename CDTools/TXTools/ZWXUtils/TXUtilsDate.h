//
//  ZWXUtilsDate.h
//  PaixieMall
//
//  Created by zhwx on 14-6-24.
//  Copyright (c) 2014年 拍鞋网. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TXUtilsDate : NSObject

/**
 * 用 NSDate 获取 年、月、日、时、分、秒
 */
+(void) getYear:(int*)year
          month:(int*)month
            day:(int*)day
           hour:(int*)hour
         minute:(int*)minute
         second:(int*)second
       withDate:(NSDate*)date;

/**
 *  用 NSDate 获取 星期几
 */
+(NSString*) getWeekWithDate:(NSDate*)date;


/**
 * nsdate to nsstring
 */
+(NSString*) stringWithFromat:(NSString*)format date:(NSDate*)date;

@end
