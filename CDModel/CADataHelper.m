//
//  CACloudHelper.m
//  CloudApp
//
//  Created by Pro on 8/11/14.
//  Copyright (c) 2014 王庭协. All rights reserved.
//

#import "CADataHelper.h"
#import "NSDictionary+HandleNull.h"
#import "TXMD5.h"
#import "CommonHelper.h"
#import "NSDictionary+HandleNull.h"
#import "CATransferHelper.h"
#import "Reachability.h"
#import "pinyin.h"
#import "ChineseString.h"
static BOOL isShowWifi =NO;
@interface CADataHelper()

@end
@implementation CADataHelper
+(NSArray *)getItemsOfPath:(NSString *)path{
    
    NSArray * allPaths=[self subPath:path];
    
    NSMutableArray * pathFolders=[self getPlistFolders:Plist_Name_AllFolders];
    
    if (path.length==0 || !path) {
        return [CADataHelper getOCFileDtoWith:pathFolders];
    }
    
    for (int i=0; i<allPaths.count; i++) {
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"fileTitle == %@", allPaths[i]];
        NSArray * matches=[pathFolders filteredArrayUsingPredicate:predicate];
        if (matches.count>0) {
            pathFolders=[[matches lastObject] objectForKey:@"folders"];
            
        }else{
            return nil;
        }
    }
    return [CADataHelper getOCFileDtoWith:pathFolders];
}
+(NSArray *)getPlistItemsOfName:(NSString *)plistName{
    return [self getOCFileDtoWith:[self getPlistFolders:plistName]];
}
+(void)deletePlistItemsOfName:(NSString *)plistName{
    [self deleteLocalFile:[self getCachesPathOfFolderName:[NSString stringWithFormat:@"%@/%@",Caches_CloudPlist,plistName]]];
}

+ (void) createFolderWithPath:(NSString *)path IsSuccess:(void (^)(BOOL))result{
    [[AppDelegate sharedOCCommunication] createFolder:[self getServiceUrl:path] onCommunication:[AppDelegate sharedOCCommunication] successRequest:^(NSHTTPURLResponse * response, NSString * redirected) {
        [[self appDelegateWindow] makeToastActivity];
        result(YES);
    } failureRequest:^(NSHTTPURLResponse * response, NSError * error) {
        if (response.statusCode==405) {
            [[self appDelegateWindow] makeToast:@"文件夹已存在"];
        }
        [[self appDelegateWindow] hideToastActivity];
        result(NO);
    } errorBeforeRequest:^(NSError * error) {
        [[self appDelegateWindow] makeToast:@"文件夹新建失败"];
        [[self appDelegateWindow] hideToastActivity];
        result(NO);
        
    }];
}
+(void)deletePlaceFileDto:(OCFileDto *)foleDto andPlistName:(NSString *)plistName{
    NSMutableArray * itemDictArr=[self getPlistFolders:plistName];
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"fileTitle == %@",foleDto.fileName];
    NSArray * matches = [itemDictArr filteredArrayUsingPredicate:predicate];
    if (matches.count > 0) {
        NSMutableDictionary * itemDict=[matches lastObject];
        [itemDictArr removeObject:itemDict];
        [itemDictArr writeToFile:[CADataHelper plistPath:plistName] atomically:YES];
    }
    [self deleteLocalFile:[self getCachesPathOfFolderName:[NSString stringWithFormat:@"%@/%@",Caches_CloudApp,foleDto.fileName]]];
}
+ (void) updateFolderWithPath:(NSString *)path successRequest:(void (^)(NSHTTPURLResponse *,NSArray *))itemsOfPath failureRequest:(void (^)(NSHTTPURLResponse *))errorRequest{
    [[self appDelegateWindow] makeToastActivity];
    if (!path) path=@"";
    
    [[AppDelegate sharedOCCommunication] readFolder:[self getServiceUrl:path] onCommunication:[AppDelegate sharedOCCommunication] successRequest:^(NSHTTPURLResponse *response, NSArray *items, NSString *redirected) {
        NSMutableArray *knownFolders = [self getFoldersOfPath:path];
        if (!knownFolders) {
            knownFolders=[[NSMutableArray alloc]init];
        }
        NSArray *knownIds = [knownFolders valueForKey:@"etag"];
        
        NSMutableArray *newFolders = [NSMutableArray arrayWithArray:items];
        if (newFolders.count>0) {//去掉一个空的
            [newFolders removeObjectAtIndex:0];
        }
        
        
        NSArray *newIds = [newFolders valueForKey:@"etag"];
        
        //更新
        NSDictionary *fileTitleDict = [NSDictionary dictionaryWithObjects:[newFolders valueForKey:@"fileTitle"] forKeys:newIds];
        NSDictionary *fileNameDict=[NSDictionary dictionaryWithObjects:[newFolders valueForKey:@"fileName"] forKeys:newIds];
        //NSLog(@"Titles: %@", titleDict);
        [knownFolders enumerateObjectsUsingBlock:^(NSMutableDictionary *folder, NSUInteger idx, BOOL *stop) {
            NSString *newFileTitle = [fileTitleDict objectForKey:folder[@"etag"]];
            NSString *newFileName = [fileNameDict objectForKey:folder[@"etag"]];
            if (newFileTitle) {
                [folder setValue:newFileTitle forKey:@"fileTitle"];
            }
            if (newFileName) {
                [folder setValue:newFileName forKey:@"fileName"];
            }
            
        }];
        
//        NSLog(@"更新ok：%@",knownFolders);
        
        //添加
        NSMutableArray *newOnServer = [NSMutableArray arrayWithArray:newIds];
        [newOnServer removeObjectsInArray:knownIds];
//        
//        NSMutableArray * willAddFolders=[NSMutableArray array];
        
//        NSLog(@"New on server: %@", newOnServer);
//        NSPredicate * predicate1 = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@", newOnServer];
//        NSArray * matches = [newIds filteredArrayUsingPredicate:predicate];
        
        [newOnServer enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSPredicate * predicate = [NSPredicate predicateWithFormat:@"etag == %@", obj];
            NSArray * matches = [newFolders filteredArrayUsingPredicate:predicate];
            if (matches.count > 0) {
                OCFileDto * folder= [matches lastObject];
                
                NSMutableDictionary * folderDic=[NSMutableDictionary dictionary];
                [folderDic setValue:folder.fileName forKeyPath:@"fileName"];
                [folderDic setValue:folder.filePath forKeyPath:@"filePath"];
                [folderDic setValue:folder.fileTitle forKeyPath:@"fileTitle"];
                [folderDic setValue:[NSNumber numberWithBool:folder.isDirectory] forKeyPath:@"isDirectory"];
                if (folder.isDirectory) {//如果是文件夹，创建一个文件夹数组
                    [folderDic setObject:[NSMutableArray array] forKey:@"folders"];
                }
                [folderDic setValue:[NSNumber numberWithInteger:folder.fileType] forKeyPath:@"fileType"];
                [folderDic setValue:[NSNumber numberWithLongLong:folder.size] forKeyPath:@"size"];
                [folderDic setValue:[NSNumber numberWithLong:folder.date] forKeyPath:@"date"];
                [folderDic setValue:[NSNumber numberWithLongLong:folder.etag] forKeyPath:@"etag"];
                [knownFolders  addObject:folderDic];
//                [self addFolderFromDictionary:[matches lastObject]];
            }
        }];
        
        
        //删除
        NSMutableArray *deletedOnServer = [NSMutableArray arrayWithArray:knownIds];
        [deletedOnServer removeObjectsInArray:newIds];
        
//        [deletedOnServer filterUsingPredicate:[NSPredicate predicateWithFormat:@"self >= 0"]];
//        NSLog(@"Deleted on server: %@", deletedOnServer);
        [deletedOnServer enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSPredicate * predicate = [NSPredicate predicateWithFormat:@"etag == %@", obj];
            NSArray * matches = [knownFolders filteredArrayUsingPredicate:predicate];
            if (matches.count > 0) {
                NSDictionary * folder= [matches lastObject];
                
                [knownFolders removeObject:folder];
            }
        }];
        
//        while (deletedOnServer.count > 0) {
//            NSString * etagToRemove=[NSString stringWithFormat:@"%@",[deletedOnServer lastObject]] ;
//            for (NSDictionary *folderToRemove in knownFolders) {
//                NSString * folderToRemoveOfEtag=[NSString stringWithFormat:@"%@",folderToRemove [@"etag"]];
//                if ([folderToRemoveOfEtag  isEqualToString:etagToRemove]) {
//                    [knownFolders removeObject:etagToRemove];
//                }
//            }
//            [deletedOnServer removeLastObject];
//        }
        
        
        //中英文排序
        knownFolders=[self getChinesArray:knownFolders];
        //文件和文件夹排序
        knownFolders=[self sortItems:knownFolders];
        
        [self writeToFoldersOfPath:path andFolders:knownFolders];
        
        
        itemsOfPath(response,knownFolders);
//        [[self appDelegateWindow] hideToastActivity];
//        NSMutableArray *knownFoldersa = [[[NSMutableArray alloc]initWithContentsOfFile:[CADataHelper plistPath]]mutableCopy];
        
        [[self appDelegateWindow] hideToastActivity];
    } failureRequest:^(NSHTTPURLResponse *response, NSError *error) {
        errorRequest(response);
        [[self appDelegateWindow] hideToastActivity];
    }];

    
//    [[AppDelegate sharedOCCommunication] readFolder:path onCommunication:[AppDelegate sharedOCCommunication] successRequest:^(NSHTTPURLResponse *response, NSArray *items, NSString *redirected) {
//        [[self appDelegateWindow] hideToastActivity];
//        //Success
//        NSLog(@"succes");
//        NSMutableArray * mItems=[NSMutableArray arrayWithArray:items];
//        if (mItems.count>0) {
//            [mItems removeObjectAtIndex:0];
//        }
////        itemsOfPath = mItems;
//        
//        itemsOfPath(mItems);
//        
//    } failureRequest:^(NSHTTPURLResponse *response, NSError *error) {
//        [[self appDelegateWindow] hideToastActivity];
//        //Request failure
////        NSLog(@"Error: %@", error;
//        errorRequest();
//    }];
    
}
+ (void) uploadFile:(NSString *) remotePath uploadFileName:(NSString *)fileName fileData:(NSData *)fileData willStart:(void(^)())start progressUpload:(void(^)(NSUInteger, long long, long long))progressUpload successRequest:(void(^)()) successRequest failureRequest:(void(^)(NSError *)) failureRequest  failureBeforeRequest:(void(^)(NSError *)) failureBeforeRequest {
    fileName=[fileName stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    UIImage *uploadImage = [UIImage imageNamed:@"欢迎画面.png"];
//    
//    //Convert UIImage to JPEG
//    NSData *imgData = UIImageJPEGRepresentation(uploadImage, 1); // 1 is compression quality
    
    //Identify the home directory and file name
//    NSString  *imagePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Test.png"];
    NSString *folderPath = [self getCachesPathOfFolderName:Caches_CloudApp]; // Get documents folder
    
    NSString * randomStr=[NSString stringWithFormat:@"/%@",fileName];
    NSString *localPath = [folderPath stringByAppendingString:randomStr];
    
    
    // Write the file.
    [fileData writeToFile:localPath atomically:YES];
    
//    _pathOfLocalUploadedFile = imagePath;
    
    
    
    //Upload block
    __weak NSOperation * uploadOperation=nil;
    uploadOperation=[[AppDelegate sharedOCCommunication] uploadFile:localPath toDestiny:[self getServiceUrl:remotePath] onCommunication:[AppDelegate sharedOCCommunication] progressUpload:^(NSUInteger bytesWrite, long long totalBytesWrite, long long totalExpectedBytesWrite) {
        progressUpload(bytesWrite,totalBytesWrite,totalBytesWrite);
        //Progress
//        NSLog(@"Uploading: bytesWrite:%ld,totalBytesWrite:%lld bytes,totalExpectedBytesWrite:%lld",bytesWrite,totalBytesWrite,totalExpectedBytesWrite);
//        OCFileDto
//        NSInteger
//        NSString * tempPlist=[NSString stringWithFormat:@"%@%@",[self getCachesPathOfFolderName:Caches_CloudTemp],randomStr];
//        dispatch_async(kBgQueue, ^{
//            NSMutableDictionary * folderDic=[NSMutableDictionary dictionary];
//            [folderDic setValue:fileName forKeyPath:@"fileName"];
//            [folderDic setValue:remotePath forKeyPath:@"filePath"];
//            [folderDic setValue:[fileName stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKeyPath:@"fileTitle"];
//            [folderDic setValue:[NSNumber numberWithBool:NO] forKeyPath:@"isDirectory"];
//            [folderDic setValue:[NSNumber numberWithInteger:[CommonHelper fileNameToFileType:fileName]] forKeyPath:@"fileType"];
//            [folderDic setValue:[NSNumber numberWithLongLong:totalExpectedBytesWrite] forKeyPath:@"size"];
//            [folderDic setValue:[NSNumber numberWithLong:[[NSDate date] timeIntervalSince1970]] forKeyPath:@"date"];
//            [folderDic setValue:[NSNumber numberWithInteger:bytesWrite] forKey:@"bytes"];
//            [folderDic setValue:[NSNumber numberWithLongLong:totalBytesWrite] forKey:@"totalBytes"];
//            
//            [self doFileRequestWithWay:Do_Upload_Request fileInfo:folderDic];
//        });
        dispatch_async(kBgQueue, ^{
            
            OCFileDto * fd=[[OCFileDto alloc]init];
            fd.fileName=fileName;
            fd.filePath=remotePath;
            fd.fileTitle=fileName;
            fd.isDirectory=NO;
            fd.fileType=[CommonHelper fileNameToFileType:fileName];
            fd.size=totalExpectedBytesWrite;
            fd.bytes=bytesWrite;
            fd.totalBytes=totalBytesWrite;
            fd.isTransfer=YES;
            fd.tranferStatus=CATransferStatusDoing;
            
            CATransferHelper * transferHelper=[CATransferHelper sharedInstance];
            NSMutableArray * doingFolders=[transferHelper uploadingFiles];
            NSPredicate * predicate = [NSPredicate predicateWithFormat:@"fileTitle == %@",fileName];
            
            NSArray * matches = [doingFolders filteredArrayUsingPredicate:predicate];
            if (matches.count > 0) {
                OCFileDto * doingFD=matches[0];
                doingFD.bytes=fd.bytes;
                doingFD.totalBytes=fd.totalBytes;
            }
            else{
                [doingFolders addObject:fd];
                
                [self doFileRequestWithWay:Do_Upload_Request fileInfo:[self fileDictWithFileDto:fd]];
                
                dispatch_async(kMainQueue, ^{
                    start();
                    [[NSNotificationCenter defaultCenter] postNotificationName:NSNOTIFICATION_NAME_TRANSFER_CHANGE object:nil userInfo:@{@"status": [NSNumber numberWithInteger:CATransferTypeStartUpload]}];
                    
                    
                    [self currentNetIsWiFi];
                });
                
            }
        });
//        [[NSNotificationCenter defaultCenter] postNotificationName:NSNOTIFICATION_NAME_UPLOADING object:[NSNumber numberWithLongLong:totalBytesWrite]];
        
    } successRequest:^(NSHTTPURLResponse *response, NSString *redirectedServer) {
        //Success
        NSLog(@"上传成功");
        
        
        
        dispatch_async(kBgQueue, ^{
            [self didFileRequestWithWay:Do_Upload_Request fileName:fileName];
            dispatch_async(kMainQueue, ^{
                successRequest(localPath);[[NSNotificationCenter defaultCenter] postNotificationName:NSNOTIFICATION_NAME_TRANSFER_CHANGE object:nil userInfo:@{@"status": [NSNumber numberWithInteger:CATransferTypeDidUploaded]}];
            });
        });
        
        //Refresh the file list
//        [self readFolder:nil];
        
    } failureRequest:^(NSHTTPURLResponse *response, NSString *redirectedServer, NSError *error) {
        //Request failure
        
//        [[self appDelegateWindow] makeToast:@"服务器出错"];
        failureRequest(error);
        
    } failureBeforeRequest:^(NSError *error) {
        //Failure before the request
        
//        [[self appDelegateWindow] makeToast:@"服务器出错"];
        failureRequest(error);
        
    } shouldExecuteAsBackgroundTaskWithExpirationHandler:^{
        //Specifies that the operation should continue execution after the app has entered the background, and the expiration handler for that background task.
        [uploadOperation cancel];
    }];
    
    
}
+(void) downloadFile:(NSString *)remotePath downloadFileName:(NSString *)fileName willStart:(void(^)())start progressDownload:(void(^)(NSUInteger, long long, long long))progressDownload successRequest:(void(^)(NSString *)) successRequest failureRequest:(void(^)(NSError *)) failureRequest{
    fileName=[fileName stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *folderPath = [self getCachesPathOfFolderName:Caches_CloudApp]; // Get documents folder
    
    NSString * randomStr=[NSString stringWithFormat:@"/%@",fileName];
    NSString *localPath = [folderPath stringByAppendingString:randomStr];
    
    
    __weak NSOperation * downloadOperation=nil;
    
    downloadOperation=[[AppDelegate sharedOCCommunication] downloadFile:[self getServiceUrl:remotePath] toDestiny:localPath withLIFOSystem:YES onCommunication:[AppDelegate sharedOCCommunication] progressDownload:^(NSUInteger bytesRead, long long totalBytesRead, long long totalExpectedBytesRead) {
        //Progress
        progressDownload(bytesRead,totalBytesRead,totalExpectedBytesRead);
        
        
                
                
//        NSLog(@"下载内：【%ld】，【%lld】，【%lld】",bytesRead,totalBytesRead,totalExpectedBytesRead);
//        NSMutableArrayf * downloadingFolders=[self getPlistFolders:Plist_Name_Downloading];
//        if (!downloadingFolders) {
//            NSMutableArray * folders=[NSMutableArray array];
//            
//            [folders writeToFile:[self plistPath:Plist_Name_Downloading] atomically:YES];
//        }
//        else{
//            
//            NSPredicate * predicate = [NSPredicate predicateWithFormat:@"fileTitle == %@",fileName];
//            NSArray * matches = [downloadingFolders filteredArrayUsingPredicate:predicate];
//            if (matches.count > 0) {
        
        //            NSMutableDictionary * folderDic=[NSMutableDictionary dictionary];
        //            [folderDic setValue:fileName forKeyPath:@"fileName"];
        //            [folderDic setValue:remotePath forKeyPath:@"filePath"];
        //            [folderDic setValue:[fileName stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKeyPath:@"fileTitle"];
        //            [folderDic setValue:[NSNumber numberWithBool:NO] forKeyPath:@"isDirectory"];
        //            [folderDic setValue:[NSNumber numberWithInteger:[CommonHelper fileNameToFileType:fileName]] forKeyPath:@"fileType"];
        //            [folderDic setValue:[NSNumber numberWithLongLong:totalExpectedBytesRead] forKeyPath:@"size"];
        //            [folderDic setValue:[NSNumber numberWithLong:[[NSDate date] timeIntervalSince1970]] forKeyPath:@"date"];
        //            [folderDic setValue:[NSNumber numberWithInteger:bytesRead] forKey:@"bytesWrite"];
        //            [folderDic setValue:[NSNumber numberWithLongLong:totalBytesRead] forKey:@"totalBytesWrite"];
        dispatch_async(kBgQueue, ^{
            
            OCFileDto * fd=[[OCFileDto alloc]init];
            fd.fileName=fileName;
            fd.filePath=remotePath;
            fd.fileTitle=fileName;
            fd.isDirectory=NO;
            fd.fileType=[CommonHelper fileNameToFileType:fileName];
            fd.size=totalExpectedBytesRead;
            fd.bytes=bytesRead;
            fd.totalBytes=totalBytesRead;
            fd.isTransfer=YES;
            fd.tranferStatus=CATransferStatusDoing;
            
            CATransferHelper * transferHelper=[CATransferHelper sharedInstance];
            NSMutableArray * doingFolders=[transferHelper downloadingFiles];
                NSPredicate * predicate = [NSPredicate predicateWithFormat:@"fileTitle == %@",fileName];
                
                NSArray * matches = [doingFolders filteredArrayUsingPredicate:predicate];
                if (matches.count > 0) {
                    OCFileDto * doingFD=matches[0];
                    doingFD.bytes=fd.bytes;
                    doingFD.totalBytes=fd.totalBytes;
                }
                else{
                    [doingFolders addObject:fd];
                   
                    [self doFileRequestWithWay:Do_Download_Request fileInfo:[self fileDictWithFileDto:fd]];
                    
                    dispatch_async(kMainQueue, ^{
                        start();
                        [[NSNotificationCenter defaultCenter] postNotificationName:NSNOTIFICATION_NAME_TRANSFER_CHANGE object:nil userInfo:@{@"status": [NSNumber numberWithInteger:CATransferTypeStartDownload]}];
                        
                        [self currentNetIsWiFi];
                    });
                    
                }
        });
        
    } successRequest:^(NSHTTPURLResponse *response, NSString *redirectedServer) {
        //Success
        NSLog(@"下载成功 : %@", localPath);
        
        
        dispatch_async(kBgQueue, ^{
            [self didFileRequestWithWay:Do_Download_Request fileName:fileName];
            dispatch_async(kMainQueue, ^{
                successRequest(localPath);[[NSNotificationCenter defaultCenter] postNotificationName:NSNOTIFICATION_NAME_TRANSFER_CHANGE object:nil userInfo:@{@"status": [NSNumber numberWithInteger:CATransferTypeDidDownloaded]}];
                
            });
        });
        
//        _downloadedImageView.image = image;
//        _progressLabel.text = @"Success";
//        _deleteLocalFile.enabled = YES;
        
    } failureRequest:^(NSHTTPURLResponse *response, NSError *error) {
        failureRequest(error);
        //Request failure
        NSLog(@"error while download a file: %@", error);
//        [[self appDelegateWindow] makeToast:@"服务器出错"];
//        _progressLabel.text = @"Error in download";
//        _downloadButton.enabled = YES;
        
    } shouldExecuteAsBackgroundTaskWithExpirationHandler:^{
        //Specifies that the operation should continue execution after the app has entered the background, and the expiration handler for that background task.
        
        [downloadOperation cancel];
    }];
}
+ (void) deleteFileOrFolder:(NSString *)remotePath
             successRequest:(void (^)())successRequest
              failureRquest:(void (^)(NSError *))failureRequest{
    [[self appDelegateWindow] makeToastActivity];
    
    [[AppDelegate sharedOCCommunication] deleteFileOrFolder:[self getServiceUrl:remotePath] onCommunication:[AppDelegate sharedOCCommunication] successRequest:^(NSHTTPURLResponse *response, NSString *redirectedServer) {
        //Success
        successRequest();
        [[self appDelegateWindow] hideToastActivity];
    } failureRquest:^(NSHTTPURLResponse *response, NSError *error) {
        
        [[self appDelegateWindow] hideToastActivity];
        //Failure
        NSLog(@"error while delete a file: %@", error);
        failureRequest(error);
    }];
}
+ (void) moveFileOrFolder:(NSString *)sourcePath
                toDestiny:(NSString *)destinyPath
           successRequest:(void (^)())successRequest
           failureRequest:(void (^)())failureRequest
       errorBeforeRequest:(void (^)())errorBeforeRequest{
    NSLog(@"原来：%@",sourcePath);
    NSLog(@"新：%@",destinyPath);
    [[self appDelegateWindow] makeToastActivity];
    [[AppDelegate sharedOCCommunication] moveFileOrFolder:[self getServiceUrl:sourcePath] toDestiny:[self getServiceUrl:destinyPath] onCommunication:[AppDelegate sharedOCCommunication] successRequest:^(NSHTTPURLResponse * response, NSString * redirected) {
        [[self appDelegateWindow] hideToastActivity];
        successRequest();
    } failureRequest:^(NSHTTPURLResponse * response, NSError * error) {
        [[self appDelegateWindow] hideToastActivity];
        failureRequest();
    } errorBeforeRequest:^(NSError * error) {
        [[self appDelegateWindow] hideToastActivity];
        errorBeforeRequest();
    }];
}
#pragma mark -- until

+(NSMutableArray *)getPlistFolders:(NSString *)plistName{
    return [[[NSMutableArray alloc]initWithContentsOfFile:[CADataHelper plistPath:plistName]]mutableCopy];
}

+ (NSMutableArray*)getOCFileDtoWith:(NSArray *)folderDicts{
//    NSArray * folders=[[[NSMutableArray alloc]initWithContentsOfFile:[CADataHelper plistPath]]mutableCopy];
    
    NSMutableArray * newFolders=[NSMutableArray array];
    for (NSDictionary * dic in folderDicts) {
        OCFileDto * folder=[[OCFileDto alloc]init];
        folder.fileTitle=[dic objectForKeyNotNull:@"fileTitle" fallback:@""];
        folder.fileName=[dic objectForKeyNotNull:@"fileName" fallback:@""];
        folder.filePath=[dic objectForKeyNotNull:@"filePath" fallback:@""];
        folder.isDirectory=[[dic objectForKeyNotNull:@"isDirectory" fallback:[NSNumber numberWithBool:NO]] boolValue];
        folder.fileType=[[dic objectForKeyNotNull:@"fileType" fallback:@"0"]integerValue];
        folder.size=[[dic objectForKeyNotNull:@"size" fallback:@"0"] integerValue];
        folder.date=[[dic objectForKeyNotNull:@"date" fallback:@"0"]integerValue];
        folder.etag=[[dic objectForKeyNotNull:@"etag" fallback:@"0"]integerValue];
        folder.bytes=[[dic objectForKeyNotNull:@"bytes" fallback:@"0"]integerValue];
        folder.totalBytes=[[dic objectForKeyNotNull:@"totalBytes" fallback:@"0"]integerValue];
        folder.tranferStatus=[[dic objectForKeyNotNull:@"tranferStatus" fallback:@"0"]integerValue];
        [newFolders addObject:folder];
    }
    return newFolders;
}
+(OCFileDto *)fileDtoWithFileDict:(NSDictionary *)fileDict{
    OCFileDto * folder=[[OCFileDto alloc]init];
    folder.fileTitle=[fileDict objectForKeyNotNull:@"fileTitle" fallback:@""];
    folder.fileName=[fileDict objectForKeyNotNull:@"fileName" fallback:@""];
    folder.filePath=[fileDict objectForKeyNotNull:@"filePath" fallback:@""];
    folder.isDirectory=[[fileDict objectForKeyNotNull:@"isDirectory" fallback:[NSNumber numberWithBool:NO]] boolValue];
    folder.fileType=[[fileDict objectForKeyNotNull:@"fileType" fallback:@"0"]integerValue];
    folder.size=[[fileDict objectForKeyNotNull:@"size" fallback:@"0"] integerValue];
    folder.date=[[fileDict objectForKeyNotNull:@"date" fallback:@"0"]integerValue];
    folder.etag=[[fileDict objectForKeyNotNull:@"etag" fallback:@"0"]integerValue];
    folder.bytes=[[fileDict objectForKeyNotNull:@"bytes" fallback:@"0"]integerValue];
    folder.totalBytes=[[fileDict objectForKeyNotNull:@"totalBytes" fallback:@"0"]integerValue];
    folder.tranferStatus=[[fileDict objectForKeyNotNull:@"tranferStatus" fallback:@"0"]integerValue];
    return folder;
}
+(NSMutableDictionary *)fileDictWithFileDto:(OCFileDto *)fileDto{
    
    NSMutableDictionary * folderDic=[NSMutableDictionary dictionary];
    [folderDic setValue:fileDto.fileName forKeyPath:@"fileName"];
    [folderDic setValue:fileDto.filePath forKeyPath:@"filePath"];
    [folderDic setValue:fileDto.fileTitle forKeyPath:@"fileTitle"];
    [folderDic setValue:[NSNumber numberWithBool:fileDto.isDirectory] forKeyPath:@"isDirectory"];
    [folderDic setValue:[NSNumber numberWithInteger:fileDto.fileType] forKeyPath:@"fileType"];
    [folderDic setValue:[NSNumber numberWithLongLong:fileDto.size] forKeyPath:@"size"];
    [folderDic setValue:[NSNumber numberWithLong:fileDto.date] forKeyPath:@"date"];
    [folderDic setValue:[NSNumber numberWithLongLong:fileDto.etag] forKeyPath:@"etag"];
    
    [folderDic setValue:[NSNumber numberWithLongLong:fileDto.bytes] forKeyPath:@"bytes"];
    [folderDic setValue:[NSNumber numberWithLongLong:fileDto.totalBytes] forKeyPath:@"totalBytes"];
    [folderDic setValue:[NSNumber numberWithInteger:fileDto.tranferStatus] forKeyPath:@"tranferStatus"];
    return folderDic;
}
//- (int)addFolderFromDictionary:(NSDictionary*)dict {
//    Folder *newFolder = [NSEntityDescription insertNewObjectForEntityForName:@"Folder" inManagedObjectContext:self.context];
//    newFolder.myId = [dict objectForKey:@"id"];
//    newFolder.name = [dict objectForKeyNotNull:@"name" fallback:@"Folder"];
//    newFolder.unreadCountValue = 0;
//    [self saveContext];
//    return newFolder.myIdValue;
//}

+(NSMutableArray *)getFoldersOfPath:(NSString *)path{
    
    NSArray * allPaths=[self subPath:path];
    
    NSMutableArray * pathFolders=[self getPlistFolders:Plist_Name_AllFolders];
    
    if (path.length==0 || !path) {
        return pathFolders;
    }
    
    for (int i=0; i<allPaths.count; i++) {
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"fileTitle == %@", allPaths[i]];
        NSArray * matches=[pathFolders filteredArrayUsingPredicate:predicate];
        if (matches.count>0) {
            pathFolders=[[matches lastObject] objectForKey:@"folders"];
            
        }else{
            return nil;
        }
    }
    return pathFolders;
}
+(BOOL)writeToFoldersOfPath:(NSString *)path andFolders:(NSMutableArray *)saveFolders{
    if (path.length==0 || !path) {
        return [saveFolders writeToFile:[CADataHelper plistPath:Plist_Name_AllFolders] atomically:YES];
    }
    NSArray * allPaths=[self subPath:path];
    
    NSMutableArray * pathFolders=[self getPlistFolders:Plist_Name_AllFolders];
//    if ([path rangeOfString:@"接口"] .length>0) {
//        NSLog(@"bbb:%@",[[[[pathFolders lastObject]objectForKey:@"folders"] objectAtIndex:4] objectForKey:@"folders"]);
//    }
    NSMutableArray * items=[NSMutableArray arrayWithArray:pathFolders];
    //pathFolder是根目录的文件，必须取到子目录下的对象
    for (int i=0; i<allPaths.count; i++) {
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"fileTitle == %@", allPaths[i]];
        NSArray * matches=[items filteredArrayUsingPredicate:predicate];
        if (matches.count>0) {
            
            NSMutableDictionary * currentFolderDict=[matches lastObject];
            if (i==allPaths.count-1) {
                [currentFolderDict setObject:saveFolders forKey:@"folders"];
            }
            else{
                items=currentFolderDict[@"folders"];
                continue;
            }
        }else{
            return NO;
        }
    }
    return [pathFolders writeToFile:[CADataHelper plistPath:Plist_Name_AllFolders] atomically:YES];
}
#pragma mark -- 传输列表
+(void)doFileRequestWithWay:(NSString *)doWay fileInfo:(NSMutableDictionary *)itemDict {
//    NSString * fileName=[fileInfo objectForKey:@"fileName"];
    [itemDict setValue:[NSNumber numberWithLongLong:0] forKeyPath:@"bytes"];
    [itemDict setValue:[NSNumber numberWithLongLong:0] forKeyPath:@"totalBytes"];
    [itemDict setObject:[NSNumber numberWithInteger:CATransferStatusStop] forKey:@"tranferStatus"];
    
    NSString * doingStr=nil;
    if ([doWay isEqualToString:Do_Download_Request]) {
        doingStr=Plist_Name_Downloading;
    }else{
        doingStr=Plist_Name_Uploading;
    }
    NSMutableArray * doingFolders=[self getPlistFolders:doingStr];
    if (!doingFolders) {
        NSMutableArray * folders=[NSMutableArray array];
        [folders addObject:itemDict];
        [folders writeToFile:[self plistPath:doingStr] atomically:YES];
    }
    else{
        [doingFolders addObject:itemDict];
        [doingFolders writeToFile:[self plistPath:doingStr] atomically:YES];
//        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"fileTitle == %@",fileName];
//        
//        NSArray * matches = [doingFolders filteredArrayUsingPredicate:predicate];
//        if (matches.count > 0) {
//            NSMutableDictionary * doingFile=matches[0];
//            [doingFile setObject:fileInfo[@"bytes"] forKey:@"bytes"];
//            [doingFile setObject:fileInfo[@"totalBytes"] forKey:@"totalBytes"];
//            
//            [doingFolders writeToFile:[self plistPath:doingStr] atomically:YES];
//        }
//        else{
//            [doingFolders addObject:fileInfo];
//            [doingFolders writeToFile:[self plistPath:doingStr] atomically:YES];
//        }
    }
}
+(void)didFileRequestWithWay:(NSString *)doWay fileName:(NSString *)fileName{
    NSString * doingStr=nil;
    NSMutableArray * plistFolders=nil;
    NSString * didStr=nil;
    NSMutableArray * tempFolders=nil;
    CATransferHelper * transferHelper=[CATransferHelper sharedInstance];
    if ([doWay isEqualToString:Do_Download_Request]) {
        tempFolders=transferHelper.downloadingFiles;
        doingStr=Plist_Name_Downloading;
        didStr=Plist_Name_Downloaded;
    }else{
        tempFolders=transferHelper.uploadingFiles;
        doingStr=Plist_Name_Uploading;
        didStr=Plist_Name_Uploaded;
    }
    
    plistFolders=[self getPlistFolders:doingStr];
    
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"fileTitle == %@",fileName];
    NSArray * matches = [tempFolders filteredArrayUsingPredicate:predicate];
    if (matches.count > 0) {
        
        OCFileDto * fileDto=[matches lastObject];
        NSMutableDictionary * itemDict=[self fileDictWithFileDto:fileDto];
        
        [itemDict setObject:[NSNumber numberWithInteger:CATransferStatusDid] forKey:@"tranferStatus"];
        
        NSMutableArray * itemDictArr=[self getPlistFolders:didStr];
        if (!itemDictArr) {
            itemDictArr=[NSMutableArray array];
        }
        [itemDictArr addObject:itemDict];
        [itemDictArr writeToFile:[CADataHelper plistPath:didStr] atomically:YES];
        
        
        [tempFolders removeObject:fileDto];
//        plistFolders removeObject:
//        [tempFolders writeToFile:[self plistPath:doingStr] atomically:YES];
    }
    
    NSArray * plistMatches=[plistFolders filteredArrayUsingPredicate:predicate];
    
    if (plistMatches.count>0) {
        NSDictionary * itemDict=[plistMatches lastObject];
        [plistFolders removeObject:itemDict];
        [tempFolders writeToFile:[self plistPath:doingStr] atomically:YES];

    }

}
#pragma end mark
+(NSArray * )subPath:(NSString *)path{
    if ([path hasPrefix:@"/"]) {
        path=[path substringFromIndex:1];
    }
    if ([path hasSuffix:@"/"]) {
        path=[path substringToIndex:path.length-1];
    }
    return [path componentsSeparatedByString:@"/"];
}

+(NSString *)serviceUrl{
    return [NSString stringWithFormat:@"%@%@",[[NSUserDefaults standardUserDefaults] objectForKey:User_ServiceUrl],RemoteWebdav];
}
+(NSString *)plistPath:(NSString *)plistName{
    NSString * plistPath=[NSString stringWithFormat:@"%@/%@",[self getCachesPathOfFolderName:Caches_CloudPlist],plistName];
    
    return plistPath;

}
+(NSString *)filePath:(NSString *)fileName{
    NSString * plistPath=[NSString stringWithFormat:@"%@/%@",[self getCachesPathOfFolderName:Caches_CloudApp],fileName];
    return plistPath;
    
}
+ (NSString *)getCachesPathOfFolderName:(NSString *)name
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    //获取完整路径
    NSString *pathDirectory = [NSString stringWithFormat:@"%@/%@/%@/%@",[paths objectAtIndex:0],[[NSUserDefaults standardUserDefaults] objectForKey:User_Domain],[[NSUserDefaults standardUserDefaults] objectForKey:User_UserName],name];
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:pathDirectory isDirectory:&isDir];
    if ( !(isDir == YES && existed == YES) )
    {
        [fileManager createDirectoryAtPath:pathDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    //    NSString *result = [pathDirectory stringByAppendingPathComponent];
    
//    NSLog(@"placePath:%@",pathDirectory);
    return pathDirectory;
    
}
+ (void)deleteLocalFile:(NSString *)path{
    
    //Delete the file
    NSError *theError = nil;
    [[NSFileManager defaultManager] removeItemAtPath:path error:&theError];
    
}
+(NSString *)getServiceUrl:(NSString *)remotePath{
    NSString * serverUrl=[NSString stringWithFormat:@"%@/%@",[self serviceUrl],remotePath];
    serverUrl = [serverUrl stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"serverUrl:%@",serverUrl);
    return serverUrl;
}
//获取文件的服务器url
+(NSString *)urlWithOCFileDto:(OCFileDto *)fileDto{
    NSString * urlStr=[NSString stringWithFormat:@"http://%@%@%@",[[NSUserDefaults standardUserDefaults] objectForKey:User_Domain],fileDto.filePath,fileDto.fileName];
//    NSLog(@"url：%@",urlStr);
    return urlStr;
}

//判断文件是否存在
+(BOOL)placeHasSave:(OCFileDto *)fileDto{
    NSString *path = [self getCachesPathOfFolderName:Caches_CloudApp];
    NSString *filePath = [path stringByAppendingFormat:@"%@",fileDto.fileTitle];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL result = [fileManager fileExistsAtPath:filePath];
    return result;
}
+(NSMutableArray *)sortItems:(NSArray *)oldItems{
    NSMutableArray * files=[[NSMutableArray alloc]init];
    NSMutableArray * folders=[[NSMutableArray alloc]init];
    NSMutableArray * newItems=[[NSMutableArray alloc]init];
    
    for (NSDictionary * itemDic in oldItems) {
        if ([[itemDic objectForKey:@"isDirectory"] boolValue]) {
            [folders addObject:itemDic];
        }
        else{
            [files addObject:itemDic];
        }
    }
    [newItems addObjectsFromArray:folders];
    [newItems addObjectsFromArray:files];
    return newItems;
}

+ (NSMutableArray*)getChinesArray:(NSMutableArray*)arrToSort
{
    //创建一个临时的变动数组
    NSMutableArray *chineseStringsArray = [NSMutableArray array];
    for(int i =0; i < arrToSort.count; i++)
    {
        
        //创建一个临时的数据模型对象
        ChineseString *chineseString=[[ChineseString alloc]init];
        chineseString.fileDic=arrToSort[i];
        //给模型赋值
        
        NSString * fileName=[chineseString.fileDic objectForKey:@"fileName"];
        chineseString.string=[NSString stringWithString:fileName];
        
        if(chineseString.string==nil)
        {
            chineseString.string=@"";
        }
        if(![chineseString.string isEqualToString:@""])
        {
            //join(链接) the pinYin (letter字母) 链接到首字母
            NSString *pinYinResult = [NSString string];
            
            //按照数据模型中row的个数循环
            
            for(int j =0;j < chineseString.string.length; j++)
            {
                NSString *singlePinyinLetter = [[NSString stringWithFormat:@"%c",
                                                 pinyinFirstLetter([chineseString.string characterAtIndex:j])]uppercaseString];
                pinYinResult = [pinYinResult stringByAppendingString:singlePinyinLetter];
            }
            chineseString.pinYin = pinYinResult;
            
        } else {
            chineseString.pinYin =@"";
        }
        [chineseStringsArray addObject:chineseString];
    }
    
    //sort(排序) the ChineseStringArr by pinYin(首字母)
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"pinYin"ascending:YES]];
    
    [chineseStringsArray sortUsingDescriptors:sortDescriptors];
    
    NSMutableArray *arrayForArrays = [NSMutableArray array];
    
    for(int index =0; index < [chineseStringsArray count]; index++)
    {
        ChineseString *chineseStr = (ChineseString *)[chineseStringsArray objectAtIndex:index];
        NSPredicate * predicate = [NSPredicate predicateWithFormat:@"fileName == %@", chineseStr.string];
        NSArray * matches = [arrToSort filteredArrayUsingPredicate:predicate];
        if (matches.count > 0) {
            NSDictionary  *fileDic= [matches lastObject];
            
            [arrayForArrays addObject:fileDic];
        }
        
    }
//
//    BOOL checkValueAtIndex=NO; //flag to check
//    
//    NSMutableArray *TempArrForGrouping =nil;
//    
//    NSMutableArray *heads = [NSMutableArray array];
    
//    for(int index =0; index < [chineseStringsArray count]; index++)
//    {
//        ChineseString *chineseStr = (ChineseString *)[chineseStringsArray objectAtIndex:index];
//        
//        NSMutableString *strchar= [NSMutableString stringWithString:chineseStr.pinYin];
//        //sr containing here the first character of each string  (这里包含的每个字符串的第一个字符)
//        NSString *sr= [strchar substringToIndex:1];
//        //here I'm checking whether the character already in the selection header keys or not  (检查字符是否已经选择头键)
//        
//        if(![heads containsObject:[sr uppercaseString]])
//        {
//            [heads addObject:[sr uppercaseString]];
//            
//            TempArrForGrouping = [[NSMutableArray alloc]initWithObjects:nil];
//            
//            checkValueAtIndex = NO;
//        }
//        
//        if([heads containsObject:[sr uppercaseString]])
//        {
//            [TempArrForGrouping addObject:chineseStr.fileDic];
//            
//            if(checkValueAtIndex == NO)
//            {
//                [arrayForArrays addObjectsFromArray:TempArrForGrouping];
//                checkValueAtIndex = YES;
//            }
//        }
//        
//    }
    
//    sortHeaders = [NSMutableArray arrayWithArray:heads];
    return arrayForArrays;
}


//判断网络是否是wifi
+ (void)currentNetIsWiFi {
    Reachability *reachability = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    BOOL isWifi=[reachability currentReachabilityStatus] == ReachableViaWiFi;
    NSLog(@"wifi:%d",isShowWifi);
//    AppDelegate * app=APP;
//    [app showNoWifi];
    if (!isWifi && !isShowWifi){
        AppDelegate * app=APP;
        [app showNoWifi];
        isShowWifi=YES;
    }
}
+(UIWindow *)appDelegateWindow{
    AppDelegate * app=APP;
    return app.window;
}
@end
