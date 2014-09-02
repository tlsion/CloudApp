//
//  CAGlobalData.h
//  CloudApp
//
//  Created by Pro on 8/13/14.
//  Copyright (c) 2014 王庭协. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MainTabBarViewController.h"
@interface CAGlobalData : NSObject
@property (nonatomic, strong) MainTabBarViewController * az_mainTab;
+ (CAGlobalData *)shared;
@end
