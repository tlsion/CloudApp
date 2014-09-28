
//  BCHTTPService.m
//  cycling
//
//  Created by Pro on 3/11/14.
//  Copyright (c) 2014 王庭协. All rights reserved.
//

#import "MVHTTPService.h"
#import "UIView+Action.h"
@implementation MVHTTPService

-(void)requestGetMethod:(NSString *)method param:(NSDictionary *)param{
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
    NSString * urlStr=nil;
    
    if (paramStr.length>0) {
        urlStr=[NSString stringWithFormat:@"%@/%@?%@",SERVICE_URL,method,paramStr];
    }
    else{
        urlStr=[NSString stringWithFormat:@"%@/%@",SERVICE_URL,method];
    }
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
-(void)requestPostMethod:(NSString *)method param:(NSDictionary *)param{
    
    NSLog(@"post:%@",param);
    if ([NSJSONSerialization isValidJSONObject:param])
    {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:param options:NSJSONWritingPrettyPrinted error:& error];
        NSData *tempJsonData = [NSData dataWithData:jsonData];
        
        NSString * urlStr=[NSString stringWithFormat:@"%@/%@",SERVICE_URL,method];
        NSLog(@"posturl:%@",urlStr);
        NSURL *url = [NSURL URLWithString:urlStr];
        
        NSMutableURLRequest * urlRequest=[NSMutableURLRequest requestWithURL:url];
        [urlRequest setTimeoutInterval:10];
        [urlRequest addValue:@"application/json; encoding=utf-8" forHTTPHeaderField:@"Content-Type"];
        [urlRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [urlRequest setHTTPMethod:@"POST"];
        [urlRequest setHTTPBody:tempJsonData];
        
        NSURLConnection * connection=[NSURLConnection connectionWithRequest:urlRequest delegate:self];
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible=YES;
        
        [connection start];
    }
}
+(id)requestGetMethod:(NSString *)method andParam:(NSDictionary *)param andServiceSuccessBlock:(HTTPServiceSuccessBlock)serviceSuccessBlock andServiceFailBlock:(HTTPServiceFailBlock)serviceFailBlock{
    MVHTTPService * service=[[MVHTTPService alloc]init];
    [service requestGetMethod:method param:param];
    service.serviceSuccessBlock=serviceSuccessBlock;
    service.serviceFailBlock=serviceFailBlock;
    return service;
}
+(id)requestPostMethod:(NSString *)method andParam:(NSDictionary *)param andServiceSuccessBlock:(HTTPServiceSuccessBlock)serviceSuccessBlock andServiceFailBlock:(HTTPServiceFailBlock)serviceFailBlock{
    MVHTTPService * service=[[MVHTTPService alloc]init];
    [service requestPostMethod:method param:param];
    service.serviceSuccessBlock=serviceSuccessBlock;
    service.serviceFailBlock=serviceFailBlock;
    return service;
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
    NSString * resultStr=[[NSString alloc] initWithData:allData encoding:NSUTF8StringEncoding];
    NSLog(@"AllDataStr=%@",resultStr);
    NSError *error;
    self.allDataDic=[NSJSONSerialization JSONObjectWithData:allData options:kNilOptions error:&error];
//    self.msg=[NSString stringWithFormat:@"%@",[self.allDataDic objectForKey:@"msg"]];
//    self.status=(NSInteger)[self.allDataDic objectForKey:@"status"];
//    id objectData=[self.allDataDic objectForKey:@"dataList"];
//    if ([objectData isKindOfClass:[NSArray class]]) {
//        self.allLists=objectData;
//    }
//    else  if ([objectData isKindOfClass:[NSDictionary class]]) {
//        self.dataDic=objectData;
//    }
//    self.status=[[self.allDataDic objectForKey:@"status"] integerValue];
//    NSLog(@"Datadic=%@",self.dataDic);

    
    if (self.serviceSuccessBlock) {
        self.serviceSuccessBlock(self);
    }
    [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
}
    
-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    NSString * errorStr=[NSString stringWithFormat:@"%@",error];
    NSLog(@"%@",errorStr);
    if ([errorStr rangeOfString:@"请求超时"].length>0) {
        AppDelegate * app=APP;
        [app.window makeToast:@"请求超时!"];
    }
    
    if (self.serviceFailBlock) {
        self.serviceFailBlock();
    }
    [UIApplication sharedApplication].networkActivityIndicatorVisible=NO;
}
//-(NSString *)getHttpUrlParamStr:(NSDictionary *)urlParam{
//    NSArray * paramKeys=[urlParam allKeys];
//    
//    NSMutableString * paramStr=[[NSMutableString alloc]init];
//                              
//    for (int i=0; i<paramKeys.count; i++) {
//        NSString * paramKey=[paramKeys objectAtIndex:i];
//        NSString * paramValue=[urlParam objectForKey:paramKey];
//        
//        if (i==0) {
//            [paramStr appendFormat:@"%@=%@",paramKey,paramValue];
//        }
//        else{
//            [paramStr appendFormat:@"&%@=%@",paramKey,paramValue];
//        }
//    }
//    
//    return paramStr;
//}
//-(NSString *)stringToUTF_8:(NSString *)aString{
//    NSString * utf_8Str=(NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)aString, NULL, NULL,  kCFStringEncodingUTF8 ));
//    if (utf_8Str) return utf_8Str;
//    else return @"";
//}
//+(NSString *)stringToUTF_8:(NSString *)aString{
//    NSString * utf_8Str=(NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)aString, NULL, NULL,  kCFStringEncodingUTF8 ));
//    if (utf_8Str) return utf_8Str;
//    else return @"";
//}
@end
