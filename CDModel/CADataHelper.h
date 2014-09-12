//
//  CACloudHelper.h
//  CloudApp
//
//  Created by Pro on 8/11/14.
//  Copyright (c) 2014 王庭协. All rights reserved.
//

#import <Foundation/Foundation.h>


#define User_ServiceUrl @"ServiceUrl"
#define User_IsLogined @"IsLogined"
#define User_UserName @"UserName"
#define User_UserPassword @"UserPassword"
#define User_Domain @"Domain"

#define RemoteWebdav @"/remote.php/webdav"


#define NSNOTIFICATION_NAME_TRANSFER_CHANGE @"Now_Transfer_change"
typedef NS_ENUM(NSInteger, CATransferType) {
    CATransferTypeStartUpload = 1,
    CATransferTypeDidUploaded,
    CATransferTypeStartDownload,
    CATransferTypeDidDownloaded
};
typedef NS_ENUM (NSInteger, CATransferStatus){
    CATransferStatusDefault = 0,
    CATransferStatusDoing = 1,
    CATransferStatusStop,
    CATransferStatusDid
};

#define Caches_CloudApp @"CloudApp"
#define Caches_CloudTemp @"Temp"
#define Caches_CloudPlist @"CloudPlist"

#define Do_Download_Request @"DoDownloadRequest"
#define Do_Upload_Request @"DoUploadRequest"

#define Plist_Name_AllFolders @"AllFolders.plist"
#define Plist_Name_Uploading @"UploadingFiles.plist"
#define Plist_Name_Uploaded @"UploadedFiles.plist"
#define Plist_Name_Downloading @"DownloadingFiles.plist"
#define Plist_Name_Downloaded @"DownloadedFiles.plist"



#define kOCOKServerSuccess 207
#define kOCErrorServerURLNotCorrect 200
#define kOCErrorServerUserNoFault 401

#import "OCCommunication.h"
#import "OCFileDto.h"
//@protocol CACloudHelperDelegate;
@interface CADataHelper : NSObject
//@property (nonatomic,weak) id<CACloudHelperDelegate>delegate;

//文件夹
+(NSArray *)getItemsOfPath:(NSString *)path;


//读取本地的路径
+(NSString *)filePath:(NSString *)fileName;

//获取文件URL
+(NSString *)urlWithOCFileDto:(OCFileDto *)fileDto;

//传输列表或文件的plist
+(NSArray *)getPlistItemsOfName:(NSString *)plistName;

//删除传输列表或文件的plist
+(void) deletePlistItemsOfName:(NSString *)plistName;

//删除传输列表或文件的plist的对象
+(void)deletePlaceFileDto:(OCFileDto *)foleDto andPlistName:(NSString *)plistName;
//更新目录
+ (void) updateFolderWithPath:(NSString *)path successRequest:(void (^)(NSHTTPURLResponse *,NSArray *))itemsOfPath failureRequest:(void (^)(NSHTTPURLResponse *))errorRequest;

//创建文件夹
+ (void) createFolderWithPath:(NSString *)path IsSuccess:(void(^)(BOOL)) result;

//上传
+ (void) uploadFile:(NSString *) remotePath uploadFileName:(NSString *)fileName fileData:(NSData *)fileData willStart:(void(^)())start progressUpload:(void(^)(NSUInteger, long long, long long))progressUpload successRequest:(void(^)()) successRequest failureRequest:(void(^)(NSError *)) failureRequest  failureBeforeRequest:(void(^)(NSError *)) failureBeforeRequest ;
//下载
+(void) downloadFile:(NSString *)remotePath downloadFileName:(NSString *)fileName willStart:(void(^)())start progressDownload:(void(^)(NSUInteger, long long, long long))progressDownload successRequest:(void(^)(NSString *)) successRequest failureRequest:(void(^)(NSError *)) failureRequest;
//删除
+ (void) deleteFileOrFolder:(NSString *)remotePath
             successRequest:(void (^)())successRequest
              failureRquest:(void (^)(NSError *))failureRequest;
//移动文件夹或者重命名
+ (void) moveFileOrFolder:(NSString *)sourcePath
                toDestiny:(NSString *)destinyPath
           successRequest:(void (^)())successRequest
           failureRequest:(void (^)())failureRequest
       errorBeforeRequest:(void (^)())errorBeforeRequest;

//判断文件是否存在
+(BOOL)placeHasSave:(OCFileDto *)fileDto;
//+ (NSOperation *) downloadFile:(NSString *)remotePath toDestiny:(NSString *)localPath withLIFOSystem:(BOOL)isLIFO onCommunication:(OCCommunication *)sharedOCCommunication progressDownload:(void(^)(NSUInteger, long long, long long))progressDownload successRequest:(void(^)(NSHTTPURLResponse *, NSString *)) successRequest failureRequest:(void(^)(NSHTTPURLResponse *, NSError *)) failureRequest shouldExecuteAsBackgroundTaskWithExpirationHandler:(void (^)(void))handler;
//+ (NSMutableArray*)getFoldersWith:(NSArray *)folderDicts;
////+ (NSArray*)folders;
//+(NSMutableArray *)getFoldersOfPath:(NSString *)path;
//@end
//@protocol CACloudHelperDelegate <NSObject>
//
//-(void)cloudHelper:(CACloudHelper *)helper didUpdateFolders:(NSArray *)floders;
@end
