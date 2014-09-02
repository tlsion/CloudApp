//
//  CAGlobalData.m
//  CloudApp
//
//  Created by Pro on 8/13/14.
//  Copyright (c) 2014 王庭协. All rights reserved.
//

#import "CAGlobalData.h"

@implementation CAGlobalData
+ (CAGlobalData *)shared {
    
    static CAGlobalData *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[CAGlobalData alloc] init];
    });
    
    return instance;
}
@end
