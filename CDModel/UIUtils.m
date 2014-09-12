//
//  UIUtils.m
//  PaixieMall
//
//  Created by Enways on 12-12-12.
//  Copyright (c) 2012年 拍鞋网. All rights reserved.
//

#import "UIUtils.h"
//#import "AnimationImageView.h"

#define SEGMENTATION_HEIGHT  40
#define HEIGHT_OF_NAVIGATION_BAR_AND_TABBAR  90

@implementation UIUtils

+ (void)removeAllSubViews:(UIView *)view {
    while (view.subviews.count) {
        UIView* child = view.subviews.lastObject;
        [child removeFromSuperview];
    }
}

+ (BOOL)findFirstResponder:(UIView *)view {
    if ([view isFirstResponder] == YES) {
        //[view resignFirstResponder];
        return YES;     
    }
    
    for (UIView *subView in view.subviews) {
        if ([self findAndResignFirstResponder:subView])
            return YES;
    }
    
    return NO;    
}

+ (BOOL)findAndResignFirstResponder:(UIView *)view {
    if ([view isFirstResponder] == YES) {
        [view resignFirstResponder];
        return YES;     
    }
    
    for (UIView *subView in view.subviews) {
        if ([self findAndResignFirstResponder:subView])
            return YES;
    }
    
    return NO;
}

+ (UIColor*)getUIColorFromHtmlColor:(NSString *)htmlColor {

    NSString *cleanString = [htmlColor stringByReplacingOccurrencesOfString:@"#" withString:@""];
    if([cleanString length] == 3) {
        cleanString = [NSString stringWithFormat:@"%@%@%@%@%@%@", 
                       [cleanString substringWithRange:NSMakeRange(0, 1)],[cleanString substringWithRange:NSMakeRange(0, 1)],
                       [cleanString substringWithRange:NSMakeRange(1, 1)],[cleanString substringWithRange:NSMakeRange(1, 1)],
                       [cleanString substringWithRange:NSMakeRange(2, 1)],[cleanString substringWithRange:NSMakeRange(2, 1)]];
    }
    if([cleanString length] == 6) {
        cleanString = [cleanString stringByAppendingString:@"ff"];
    }
    
    unsigned int baseValue;
    [[NSScanner scannerWithString:cleanString] scanHexInt:&baseValue];
    
    float red = ((baseValue >> 24) & 0xFF)/255.0f;
    float green = ((baseValue >> 16) & 0xFF)/255.0f;
    float blue = ((baseValue >> 8) & 0xFF)/255.0f;
    float alpha = ((baseValue >> 0) & 0xFF)/255.0f;
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

+ (CGSize)getContentSize:(NSString *)content textWidth:(int)width textSize:(float)size {
    CGSize theSize = [content sizeWithFont:[UIFont systemFontOfSize:size] constrainedToSize:CGSizeMake(width, 9999.0f) lineBreakMode:NSLineBreakByWordWrapping];

    return theSize;
}


+ (void)showAlertView:(UIViewController *)controller cancelTitle:(NSString *)cancelTitle title:(NSString *)title otherTitle:(NSString *)otherTitle {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:nil delegate:self cancelButtonTitle:cancelTitle otherButtonTitles:otherTitle, nil];
    
    alertView.delegate = controller;
    [alertView show];
}

+ (void)initEmptyViewFrame:(UIView *)emptyView superView:(UIView *)view haveSegmentation:(BOOL)haveSegmentation {
    CGRect frame = emptyView.frame;
    
    frame.origin.x = (view.frame.size.width-frame.size.width)/2;
    frame.origin.y = (haveSegmentation) ? (view.frame.size.height-HEIGHT_OF_NAVIGATION_BAR_AND_TABBAR+SEGMENTATION_HEIGHT-frame.size.height)/2 : (view.frame.size.height-HEIGHT_OF_NAVIGATION_BAR_AND_TABBAR-frame.size.height)/2;
    
    emptyView.frame = frame;
}

+ (void)initEmptyPadViewFrame:(UIView *)emptyView superView:(UIView *)view {
    CGRect frame = emptyView.frame;
    
    frame.origin.x = (view.frame.size.width-frame.size.width)/2;
    frame.origin.y = (view.frame.size.height-frame.size.height)/2;
    
    emptyView.frame = frame;
}

//16进制颜色(html颜色值)字符串转为UIColor
+ (UIColor *) hexStringToColor: (NSString *) stringToConvert {
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    
    if ([cString length] < 6) return [UIColor blackColor];
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    if ([cString length] != 6) return [UIColor blackColor];
    
    // Separate into r, g, b substrings
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}


+ (CGSize)getLabelSizeWithText:(NSString *)text size:(float)size {
    return [text sizeWithFont:[UIFont systemFontOfSize:size] constrainedToSize:CGSizeMake(MAXFLOAT, 0.0) lineBreakMode:NSLineBreakByWordWrapping];
}

@end
