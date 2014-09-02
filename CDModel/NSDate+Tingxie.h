//
//  NSDate+Tingxie.h
//  CloudApp
//
//  Created by Pro on 8/11/14.
//  Copyright (c) 2014 王庭协. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Tingxie)
/*
 获取当前时间
 */
+(NSString *)getCurrentTime;
/*
 获取当前日期
 */
+(NSString *)getCurrentDate;

+(NSString *)getTimeWithTimeInterval:(NSTimeInterval )timeInterval;
@end
