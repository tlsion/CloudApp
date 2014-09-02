//
//  Unicode.h
//  Diandang
//
//  Created by 智美合 on 13-12-13.
//  Copyright (c) 2013年 王庭协. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Unicode : NSObject

//+ (NSString *)encodeToPercentEscapeString: (NSString *) input ;

+ (NSString *)decodeFromPercentEscapeString: (NSString *) input ;

+ (NSString*) replaceUnicode:(NSString*)aUnicodeString;

+(NSString *) utf8ToUnicode:(NSString *)string;

@end
