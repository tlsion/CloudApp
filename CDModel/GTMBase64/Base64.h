//
//  BCBase64.h
//  cycling
//
//  Created by 智美合 on 14-4-24.
//  Copyright (c) 2014年 王庭协. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GTMBase64.h"
@interface Base64 : NSObject

+ (NSString*)encodeBase64String:(NSString*)input;

+ (NSString*)decodeBase64String:(NSString*)input;

+ (NSString*)encodeBase64Data:(NSData*)data;

+ (NSString*)decodeBase64Data:(NSData*)data;

@end
