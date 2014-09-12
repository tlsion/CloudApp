//
//  UIUtils.h
//  PaixieMall
//
//  Created by Enways on 12-12-12.
//  Copyright (c) 2012年 拍鞋网. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIUtils : NSObject

+ (void)removeAllSubViews:(UIView *)view;
+ (BOOL)findFirstResponder:(UIView *)view;
+ (BOOL)findAndResignFirstResponder:(UIView *)view;
+ (UIColor*)getUIColorFromHtmlColor:(NSString *)htmlColor;
+ (CGSize)getContentSize:(NSString *)content textWidth:(int)width textSize:(float)size;
+ (void)showAlertView:(UIViewController *)controller cancelTitle:(NSString *)cancelTitle title:(NSString *)title otherTitle:(NSString *)otherTitle;
+ (void)initEmptyViewFrame:(UIView *)emptyView superView:(UIView *)view haveSegmentation:(BOOL)haveSegmentation;
+ (UIColor *) hexStringToColor: (NSString *) stringToConvert;
+ (CGSize)getLabelSizeWithText:(NSString *)text size:(float)size;
+ (void)initEmptyPadViewFrame:(UIView *)emptyView superView:(UIView *)view;

@end
