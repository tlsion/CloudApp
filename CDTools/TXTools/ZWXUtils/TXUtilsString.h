//
//  ZWXUtilsString.h
//  ZWXUtilsLib
//
//  Created by zhwx on 14-5-8.
//  Copyright (c) 2014年 zhwx. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TXUtilsString : NSObject

/**
 *判断字符串是否为空
 */
+(BOOL) isEmpty:(NSString*)string;
/**
 * 是否为IP
 */
+(BOOL) isIPAdress :(NSString *)ip;

/**
 * 是否为邮箱
 */
+(BOOL)isValidateEmail:(NSString *)email;

/**
 * 是否为手机号码
 */
+(BOOL) isValidateMobile:(NSString *)mobile;

/**
 * 是否为车牌
 */
+(BOOL) isValidateCarNo:(NSString*)carNo;

/**
 * MD5
 */
+ (NSString *) md5:(NSString *)str;


/**
 * sha1
 */
+(NSString*) sha1:(NSString*)str;


/**
 * Encode Chinese to ISO8859-1 in URL
 */
+ (NSString *) utf8StringWithChinese:(NSString *)chinese;

/**
 * Encode Chinese to GB2312 in URL
 */
+ (NSString *) gb2312StringWithChinese:(NSString *)chinese;

/**
 * URL encode
 */
+(NSString*) urlEncodeWithString:(NSString *)string;

@end
