//
//  BCHTTPService.m
//  cycling
//
//  Created by Pro on 3/11/14.
//  Copyright (c) 2014 王庭协. All rights reserved.
//

#import "HTTPService.h"

#define PLACE_URL @"http://192.168.1.132:8080/AppBicycle"
@implementation HTTPService
static HTTPService * _service;

+(id)sharedServiceWithDelegate:(id<HTTPServiceDelegate>)delegate{
    if (!_service) {
        _service=[[HTTPService alloc]init];
        _service.httpDelegate=delegate;
    }
    return _service;
}
+(void)requestGetMethod:(NSString *)method param:(NSDictionary *)param{
//    NSString * Str = [Unicode utf8ToUnicode:param];
   //NSString * utf_8=[method stringByAddingPercentEscapesUsingEncoding:]
    
    NSArray * paramKeys=[param allKeys];

    NSMutableString * paramStr=[[NSMutableString alloc]init];
    //遍历参数
    for (int i=0; i<paramKeys.count; i++) {
        NSString * paramKey=[paramKeys objectAtIndex:i];
        NSString * paramValue=[param objectForKey:paramKey];
        
        if (i==0) {
            [paramStr appendFormat:@"%@=%@",paramKey,paramValue];
        }
        else{
            [paramStr appendFormat:@"&%@=%@",paramKey,paramValue];
        }
    }
    
    NSString * urlStr=[NSString stringWithFormat:@"%@/%@?%@",PLACE_URL,method,paramStr];
    NSLog(@"get=%@",urlStr);
    //url转UTF_8
    NSString *unicodeUrlStr =(NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)urlStr, NULL, NULL,  kCFStringEncodingUTF8 ));
    
    //NSString * u=@"ttp://192.168.1.132:8080/AppBicycle/ImplMyselfLineget.do?ids=";
    
    NSURL * url=[NSURL URLWithString:unicodeUrlStr];
    NSURLRequest * urlRequest=[NSURLRequest requestWithURL:url];
    
    NSURLConnection * connection=[NSURLConnection connectionWithRequest:urlRequest delegate:self];
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
    
    [connection start];
    
}
+(void)requestPostMethod:(NSString *)method param:(NSDictionary *)param{
//    NSMutableDictionary *user = [[NSMutableDictionary alloc] initWithObjectsAndKeys:@"500123", @"lineLong",nil];
//    [user setObject:@"24,53479549584,118.32479328759" forKey:@"locationId"];
//    [user setObject:@"环岛路" forKey:@"lineName"];
//    [user setObject:@"甲等" forKey:@"levelId"];
    
    NSLog(@"post:%@",param);
    if ([NSJSONSerialization isValidJSONObject:param])
    {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:& error];
        NSData *tempJsonData = [NSData dataWithData:jsonData];
        
        NSString * urlStr=[NSString stringWithFormat:@"%@/%@",PLACE_URL,method];
        
        NSURL *url = [NSURL URLWithString:urlStr];
        
        NSMutableURLRequest * urlRequest=[NSMutableURLRequest requestWithURL:url];
        
        [urlRequest addValue:@"application/json; encoding=utf-8" forHTTPHeaderField:@"Content-Type"];
        [urlRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [urlRequest setHTTPMethod:@"POST"];
        [urlRequest setHTTPBody:tempJsonData];
        
        NSURLConnection * connection=[NSURLConnection connectionWithRequest:urlRequest delegate:self];
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
        
        [connection start];
    }
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    allData=[[NSMutableData alloc]init];
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [allData appendData:data];
}
-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString * dataStr=[[NSString alloc] initWithData:allData encoding:NSUTF8StringEncoding];
    NSLog(@"dataStr=%@",dataStr);
    
    if (_httpDelegate && [_httpDelegate respondsToSelector:@selector(httpServiceSuccess:)]) {
        [_httpDelegate httpServiceSuccess:self];
    }
    [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
}
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    if (_httpDelegate && [_httpDelegate respondsToSelector:@selector(httpServiceFail)]) {
        [_httpDelegate httpServiceFail];
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
}
-(NSString *)getHttpUrlParamStr:(NSDictionary *)urlParam{
    NSArray * paramKeys=[urlParam allKeys];
    
    NSMutableString * paramStr=[[NSMutableString alloc]init];
                              
    for (int i=0; i<paramKeys.count; i++) {
        NSString * paramKey=[paramKeys objectAtIndex:i];
        NSString * paramValue=[urlParam objectForKey:paramKey];
        
        if (i==0) {
            [paramStr appendFormat:@"%@=%@",paramKey,paramValue];
        }
        else{
            [paramStr appendFormat:@"&%@=%@",paramKey,paramValue];
        }
    }
    
    return paramStr;
}
@end
