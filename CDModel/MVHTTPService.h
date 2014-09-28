//
//  BCHTTPService.h
//  cycling
//
//  Created by Pro on 3/11/14.
//  Copyright (c) 2014 王庭协. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^HTTPServiceSuccessBlock)(id service);
typedef void (^HTTPServiceFailBlock)();

@interface MVHTTPService : NSObject<NSURLConnectionDataDelegate>{
    NSMutableData * allData;
}
@property (nonatomic,strong) NSDictionary * allDataDic;
@property (nonatomic,strong) NSArray * allLists;
@property (nonatomic,strong) NSDictionary * dataDic;
@property (nonatomic,assign) NSInteger status;
@property (nonatomic,strong) NSString * msg;
//@property (nonatomic,assign) NSInteger type;


@property (nonatomic,copy) HTTPServiceSuccessBlock serviceSuccessBlock;
@property (nonatomic,copy) HTTPServiceFailBlock serviceFailBlock;

//+(id)sharedServiceWithDelegate:(id<HBHTTPServiceDelegate>) delegate;

-(void)requestGetMethod:(NSString *)method param:(NSDictionary *)param;
-(void)requestPostMethod:(NSString *)method param:(NSDictionary *)param;

+(id)requestGetMethod:(NSString *)method andParam:(NSDictionary *)param andServiceSuccessBlock:(HTTPServiceSuccessBlock) serviceSuccessBlock andServiceFailBlock:(HTTPServiceFailBlock) serviceFailBlock;
+(id)requestPostMethod:(NSString *)method andParam:(NSDictionary *)param andServiceSuccessBlock:(HTTPServiceSuccessBlock) serviceSuccessBlock andServiceFailBlock:(HTTPServiceFailBlock) serviceFailBlock;;


@end

//@protocol HBHTTPServiceDelegate <NSObject>

//-(void)httpServiceSuccess:(HBHTTPService *)httpService;
//@optional
//-(void)httpServiceFail;