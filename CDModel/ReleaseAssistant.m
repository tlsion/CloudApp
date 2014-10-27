//
//  ReleaseAssistant.m
//  CloudApp
//
//  Created by tingxie on 14-10-27.
//  Copyright (c) 2014年 王庭协. All rights reserved.
//

#import "ReleaseAssistant.h"

@implementation ReleaseAssistant

+(void)setDeviceInterfaceForPortrait{
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        [[UIDevice currentDevice] performSelector:@selector(setOrientation:)
                                       withObject:(id)UIInterfaceOrientationPortrait];
    }
}

@end
