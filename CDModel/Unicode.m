//
//  Unicode.m
//  Diandang
//
//  Created by 智美合 on 13-12-13.
//  Copyright (c) 2013年 王庭协. All rights reserved.
//

#import "Unicode.h"

@implementation Unicode

+(NSString *) utf8ToUnicode:(NSString *)string

{
    
    NSUInteger length = [string length];
    
    NSMutableString *s = [NSMutableString stringWithCapacity:0];
    
    for (int i = 0;i < length; i++)
        
    {
        
        unichar _char = [string characterAtIndex:i];
        
        //判断是否为英文和数字
        
//        if (_char <= '9' && _char >= '0')
//            
//        {
//            
//            [s appendFormat:@"%@",[string substringWithRange:NSMakeRange(i, 1)]];
//            
//        }
//        
//        else if(_char >= 'a' && _char <= 'z')
//            
//        {
//            
//            [s appendFormat:@"%@",[string substringWithRange:NSMakeRange(i, 1)]];
//            
//            
//            
//        }
//        
//        else if(_char >= 'A' && _char <= 'Z')
//            
//        {
//            
//            [s appendFormat:@"%@",[string substringWithRange:NSMakeRange(i, 1)]];
//            
//            
//            
//        }
        
        if(_char >= 0 && _char <= 255)
            
        {
            [s appendFormat:@"%@",[string substringWithRange:NSMakeRange(i, 1)]];

        }
        
        else
            
        {
            NSString *str=[string substringWithRange:NSMakeRange(i, 1)];
            
           NSString *strutf8 = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            [s appendFormat:@"%@",strutf8];
          //  [s appendFormat:@"\\u%x",[string characterAtIndex:i]];

            
        }
        
    }
    
    return s;
    
}

+ (NSString*) replaceUnicode:(NSString*)aUnicodeString

{
    
    NSString *tempStr1 = [aUnicodeString stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];
    
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    
    NSString *tempStr3 = [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString* returnStr = [NSPropertyListSerialization propertyListFromData:tempData
                           
                                                           mutabilityOption:NSPropertyListImmutable
                           
                                                                     format:NULL
                           
                                                           errorDescription:NULL];
    
    
    
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n" withString:@"\n"]; 
    
}

+ (NSString *)encodeToPercentEscapeString: (NSString *) input

{
    
    // Encode all the reserved characters, per RFC 3986
    
    // (<http://www.ietf.org/rfc/rfc3986.txt>)
    
    NSString *outputStr = (NSString *)
CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                            
                                            (CFStringRef)input,
                                            
                                            NULL,
                                            
                                            (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                            
                                            kCFStringEncodingUTF8));
    
    return outputStr;
    
}


+ (NSString *)decodeFromPercentEscapeString: (NSString *) input

{
    
    NSMutableString *outputStr = [NSMutableString stringWithString:input];
    
    [outputStr replaceOccurrencesOfString:@"+"
     
                               withString:@" "
     
                                  options:NSLiteralSearch
     
                                    range:NSMakeRange(0, [outputStr length])];  
    
    
    
    return [outputStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];  
    
}
@end
