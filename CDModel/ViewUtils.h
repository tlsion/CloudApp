//
//  ViewUtils.h
//  CloudApp
//
//  Created by Pro on 8/13/14.
//  Copyright (c) 2014 王庭协. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ViewUtils : NSObject
/**
 * @method loadViewWithViewClass:
 * @abstract 从与类名对应的XIB文件中加载View对象，View的owner为nil
 * @param viewClass View对象类名
 */
+ (id)loadViewWithViewClass:(Class)viewClass;
/**
 * @method loadViewFromNib:
 * @abstract 从XIB文件中加载View对象，View的owner为nil
 * @param nibName XIB文件名
 */
+ (id)loadViewFromNib:(NSString *)nibName;

@end
