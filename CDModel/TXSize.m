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
    long sizeB=size/SizeUnit;
    if (sizeB>SizeUnit) {
        long sizeKB=sizeB/SizeUnit;
        if (sizeKB>SizeUnit) {
            long sizeG=sizeKB/SizeUnit;
            if (sizeG>SizeUnit) {
                long sizeT=sizeG/SizeUnit;
                return [NSString stringWithFormat:@"%ld t",sizeT];
            }
            else{
                return [NSString stringWithFormat:@"%ld g",sizeG];
            }
        }
        else{
            return [NSString stringWithFormat:@"%ld kb",sizeKB];
        }
    }
    else{
         return [NSString stringWithFormat:@"%ld b", sizeB];
    }
}
@end
