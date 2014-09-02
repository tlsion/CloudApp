//
//  BCHTTPService.h
//  cycling
//
//  Created by Pro on 3/11/14.
//  Copyright (c) 2014 王庭协. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HTTPServiceDelegate;

@interface HTTPService : NSObject<NSURLConnectionDataDelegate>{
    NSMutableData * allData;
}
@property (nonatomic,strong) id<HTTPServiceDelegate> httpDelegate;



+(id)sharedServiceWithDelegate:(id<HTTPServiceDelegate>) delegate;

+(void)requestGetMethod:(NSString *)method param:(NSDictionary *)param;
+(void)requestPostMethod:(NSString *)method param:(NSDictionary *)param;

@end

@protocol HTTPServiceDelegate <NSObject>

-(void)httpServiceSuccess:(HTTPService *)httpService;
@optional
-(void)httpServiceFail;

@end