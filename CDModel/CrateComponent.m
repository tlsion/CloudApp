//
//  CrateComponent.m
//  CloudApp
//
//  Created by Pro on 7/31/14.
//  Copyright (c) 2014 王庭协. All rights reserved.
//

#import "CrateComponent.h"

@implementation CrateComponent

//创建UILable方法
+(UILabel *) createLableWithFrame:(CGRect)frame
                         andTitle:(NSString *)title
                          andfont:(UIFont *)font
                    andTitleColor:(UIColor *)titleColor
               andBackgroundColor:(UIColor *)backgroundColor
                 andTextAlignment:(NSTextAlignment)textAlignment
{
    
    //创建UILable对象并设置位置大小
    UILabel * lable = [[UILabel alloc]initWithFrame:frame];
    //设置标题
    lable.text = title;
    //设置字体颜色
    lable.textColor = titleColor;
    //设置背景颜色
    lable.backgroundColor = backgroundColor;
    //设置字体大小
    lable.font = font;
    //设置字体格式
    lable.textAlignment = textAlignment;
    //设置阴影
    //    lable.shadowColor = [UIColor blackColor];
    //    lable.shadowOffset = CGSizeMake(0, -2);
    
    return lable;
}

//创建UIButton方法
+(UIButton *) createButtonWithFrame:(CGRect)frame
                           andTitle:(NSString *)title
                      andTitleColor:(UIColor *)titleColor
                 andBackgroundImage:(UIImage *)backgroundImage
                          andTarget:(id)target
                          andAction:(SEL)sel
                            andType:(UIButtonType)type
{
    //创建UIButton并设置类型
    UIButton * btn = [UIButton buttonWithType:type];
    //设置按键位置和大小
    btn.frame = frame;
    //设置按键名
    [btn setTitle:title forState:UIControlStateNormal];
    //设置按键名字体颜色
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    //背景图片
    [btn setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    //设置按键响应方法
    [btn addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}

//创建RightBarButtonItem方法
+(UIBarButtonItem *) createRightBarButtonItemWithTitle:(NSString *)title
                          andTarget:(id)target
                          andAction:(SEL)sel
{
    UIButton * rightButton=[UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame=CGRectMake(SCREEN_MAX_WIDTH-60, 0, 60, 44);
    [rightButton setTitle:title forState:UIControlStateNormal];
    rightButton.titleLabel.font=FONTBOLD(13);
    [rightButton setContentEdgeInsets:UIEdgeInsetsMake(0, 16, 0, -16)];
    [rightButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -55, 0, 0)];
    [rightButton setImage:[UIImage imageNamed:@"右上角按钮.png"] forState:UIControlStateNormal];
    [rightButton setTitleColor:WHITE forState:UIControlStateNormal];
    [rightButton addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * rightBarItem=[[UIBarButtonItem alloc]initWithCustomView:rightButton];
    
    return rightBarItem;
}
//创建LeftBarButtonItem方法
+(UIBarButtonItem *) createLeftBarButtonItemWithTitle:(NSString *)title
                                             andTarget:(id)target
                                             andAction:(SEL)sel
{
    UIButton * leftButton=[UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame=CGRectMake(0, 0, 60, 44);
    [leftButton setTitle:title forState:UIControlStateNormal];
    leftButton.titleLabel.font=FONTBOLD(13);
    [leftButton setContentEdgeInsets:UIEdgeInsetsMake(0, -20, 0, 20)];
    [leftButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -55, 0, 0)];
    [leftButton setImage:[UIImage imageNamed:@"右上角按钮.png"] forState:UIControlStateNormal];
    [leftButton setTitleColor:WHITE forState:UIControlStateNormal];
    [leftButton addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * leftBarItem=[[UIBarButtonItem alloc]initWithCustomView:leftButton];
    
    return leftBarItem;
}
//创建BackBarButtonItem方法
+(UIBarButtonItem *) createBackBarButtonItemWithTarget:(id)target andAction:(SEL)sel
{
    if ([target isKindOfClass:[UIViewController class]]) {
        UIViewController * viewController=( UIViewController * )target;
        viewController.navigationItem.hidesBackButton=YES;
    }
    UIButton * backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    backButton.frame=CGRectMake(SCREEN_MAX_WIDTH-60, 0, 60, 44);
    [backButton setTitle:@"返回" forState:UIControlStateNormal];
    backButton.titleLabel.font=FONTBOLD(13);
    [backButton setContentEdgeInsets:UIEdgeInsetsMake(0, -16, 0, 16)];
    [backButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -60, 0, 0)];
    [backButton setImage:[UIImage imageNamed:@"右上角按钮.png"] forState:UIControlStateNormal];
    [backButton setTitleColor:WHITE forState:UIControlStateNormal];
    [backButton addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * backBarItem=[[UIBarButtonItem alloc]initWithCustomView:backButton];
    
    return backBarItem;
}
@end
