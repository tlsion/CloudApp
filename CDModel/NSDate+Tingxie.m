//
//  NSDate+Tingxie.m
//  CloudApp
//
//  Created by Pro on 8/11/14.
//  Copyright (c) 2014 王庭协. All rights reserved.
//

#import "NSDate+Tingxie.h"

@implementation NSDate (Tingxie)
+(NSString *)getCurrentTime{
    NSDate *  timeDate=[NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [formatter stringFromDate:timeDate];
}
+(NSString *)getCurrentDate{
    NSDate *  timeDate=[NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    return [formatter stringFromDate:timeDate];
}

+(NSString *)getTimeWithTimeInterval:(NSTimeInterval )timeInterval{
    NSDate *  timeDate=[NSDate dateWithTimeIntervalSince1970:timeInterval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [formatter stringFromDate:timeDate];
}
@end
