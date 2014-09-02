//
//  ViewUtils.m
//  CloudApp
//
//  Created by Pro on 8/13/14.
//  Copyright (c) 2014 王庭协. All rights reserved.
//

#import "ViewUtils.h"

@implementation ViewUtils

+ (id)loadViewWithViewClass:(Class)viewClass{
    return [[[NSBundle mainBundle] loadNibNamed:[viewClass description] owner:self options:nil]objectAtIndex:0];
}

+ (id)loadViewFromNib:(NSString *)nibName{
    
    return [[[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil]objectAtIndex:0];
}
@end
