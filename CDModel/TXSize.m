//
//  TXSize.m
//  CloudApp
//
//  Created by Pro on 8/11/14.
//  Copyright (c) 2014 王庭协. All rights reserved.
//

#import "TXSize.h"
#define SizeUnit 1024

@implementation TXSize
+(NSString *)getFileSize:(long long)size{
    long long sizeB=size/SizeUnit;
    if (sizeB>SizeUnit) {
        long long sizeKB=sizeB/SizeUnit;
        if (sizeKB>SizeUnit) {
            long long sizeG=sizeKB/SizeUnit;
            if (sizeG>SizeUnit) {
                long long sizeT=sizeG/SizeUnit;
                return [NSString stringWithFormat:@"%lld t",sizeT];
            }
            else{
                return [NSString stringWithFormat:@"%lld g",sizeG];
            }
        }
        else{
            return [NSString stringWithFormat:@"%lld kb",sizeKB];
        }
    }
    else{
         return [NSString stringWithFormat:@"%lld b", sizeB];
    }
}
@end
