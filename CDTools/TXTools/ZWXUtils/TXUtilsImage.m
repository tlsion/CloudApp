//
//  ZWXUtilsImage.m
//  ZWXUtilsLib
//
//  Created by zhwx on 14-5-8.
//  Copyright (c) 2014年 zhwx. All rights reserved.
//

#import "TXUtilsImage.h"

@implementation TXUtilsImage

/**
 * 通过uicolor 转 uiimage
 */
+ (UIImage*) getImageWithColor: (UIColor*) color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage*theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}


@end
