//
//  CATransferDataHelper.h
//  CloudApp
//
//  Created by Pro on 8/24/14.
//  Copyright (c) 2014 王庭协. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface CATransferHelper : NSObject
@property (nonatomic,strong) NSMutableArray * uploadingFiles;
@property (nonatomic,strong) NSMutableArray * downloadingFiles;
@property (nonatomic,strong) NSMutableArray * uploadOperations;
@property (nonatomic,strong) NSMutableArray * downloadOperations;
+(instancetype) sharedInstance;
-(void)getPlaceData;

-(void)addUploadOperationToTheNetworkQueue:(NSDictionary *)operationDict;
-(void)addDownloadOperationToTheNetworkQueue:(NSDictionary *)operationDict;
@end
