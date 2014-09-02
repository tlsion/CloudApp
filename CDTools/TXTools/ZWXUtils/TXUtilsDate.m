//
//  ZWXUtilsDate.m
//  PaixieMall
//
//  Created by zhwx on 14-6-24.
//  Copyright (c) 2014年 拍鞋网. All rights reserved.
//

#import "TXUtilsDate.h"

@implementation TXUtilsDate

/**
 * 用 NSDate 获取 年、月、日、时、分、秒
 */
+(void) getYear:(int*)year
          month:(int*)month
            day:(int*)day
           hour:(int*)hour
         minute:(int*)minute
         second:(int*)second
       withDate:(NSDate*)date
{
    NSCalendar* gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];

    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    NSDateComponents* comps = [gregorian components:unitFlags fromDate:date];
    
    *year = [comps year];
    *month = [comps month];
    *day = [comps day];
    *hour = [comps hour];
    *minute = [comps minute];
    *second = [comps second];
    
}

/**
 *  用 NSDate 获取 星期几
 */
+(NSString*) getWeekWithDate:(NSDate*)date
{
    NSCalendar* gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSInteger unitFlags = NSCalendarUnitWeekday;
    NSDateComponents* comps = [gregorian components:unitFlags fromDate:date];
    
    int weekIndex = [comps weekday];
    
    NSString* weekStr = nil;
    
    switch (weekIndex) {
        case 1:
            weekStr = @"星期日";
            break;
        case 2:
            weekStr = @"星期一";
            break;
        case 3:
            weekStr = @"星期二";
            break;
        case 4:
            weekStr = @"星期三";
            break;
        case 5:
            weekStr = @"星期四";
            break;
        case 6:
            weekStr = @"星期五";
            break;
        case 7:
            weekStr = @"星期六";
            break;
            
        default:
            weekStr = nil;
            break;
    }
    return weekStr;
}


/**
 * nsdate to nsstring
 */
+(NSString*) stringWithFromat:(NSString *)format date:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = format;
    return [formatter stringFromDate:date];
}



@end
