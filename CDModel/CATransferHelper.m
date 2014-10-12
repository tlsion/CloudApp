//
//  CATransferDataHelper.m
//  CloudApp
//
//  Created by Pro on 8/24/14.
//  Copyright (c) 2014 王庭协. All rights reserved.
//

#import "CATransferHelper.h"

@implementation CATransferHelper
-(NSMutableArray *)downloadingFiles{
    if (!_downloadingFiles) {
        _downloadingFiles=[[NSMutableArray alloc]init];
    }
    return _downloadingFiles;
}
-(NSMutableArray *)uploadingFiles{
    if (!_uploadingFiles) {
        _uploadingFiles=[[NSMutableArray alloc]init];
    }
    return _uploadingFiles;
}
+(instancetype) sharedInstance
{
    static CATransferHelper* _object = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _object = [[CATransferHelper alloc] init];
    });
    return _object;
}
-(void)getPlaceData{
    _downloadingFiles=[NSMutableArray arrayWithArray:[CADataHelper getPlistItemsOfName:Plist_Name_Downloading]];
    _uploadingFiles=[NSMutableArray arrayWithArray:[CADataHelper getPlistItemsOfName:Plist_Name_Uploading]];
}
-(void)addUploadOperationToTheNetworkQueue:(NSDictionary *)operationDict{
    if (!_uploadOperations) {
        _uploadOperations=[[NSMutableArray alloc]init];
    }
    [_uploadOperations addObject:operationDict];
}
-(void)addDownloadOperationToTheNetworkQueue:(NSDictionary *)operationDict{
    if (!_downloadOperations) {
        _downloadOperations=[[NSMutableArray alloc]init];
    }
    [_downloadOperations addObject:operationDict];
}
@end
