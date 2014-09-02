//
//  CrateComponent.h
//  CloudApp
//
//  Created by Pro on 7/31/14.
//  Copyright (c) 2014 王庭协. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CrateComponent : NSObject
//创建UILable方法
+(UILabel *) createLableWithFrame:(CGRect)frame
                         andTitle:(NSString *)title
                          andfont:(UIFont *)font
                    andTitleColor:(UIColor *)titleColor
               andBackgroundColor:(UIColor *)backgroundColor
                 andTextAlignment:(NSTextAlignment)textAlignment;

//创建UIButton方法
+(UIButton *) createButtonWithFrame:(CGRect)frame
                           andTitle:(NSString *)title
                      andTitleColor:(UIColor *)titleColor
                 andBackgroundImage:(UIImage *)backgroundImage
                          andTarget:(id)target
                          andAction:(SEL)sel
                            andType:(UIButtonType)type;
//创建RightBarButtonItem方法
+(UIBarButtonItem *) createRightBarButtonItemWithTitle:(NSString *)title
                                             andTarget:(id)target
                                             andAction:(SEL)sel;

//创建RightBarButtonItem方法
+(UIBarButtonItem *) createLeftBarButtonItemWithTitle:(NSString *)title
                                             andTarget:(id)target
                                             andAction:(SEL)sel;

//创建BackBarButtonItem方法
+(UIBarButtonItem *) createBackBarButtonItemWithTarget:(id)target andAction:(SEL)sel;
@end
