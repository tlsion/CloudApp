//
//  CACloudHelper.m
//  CloudApp
//
//  Created by Pro on 8/13/14.
//  Copyright (c) 2014 王庭协. All rights reserved.
//

#import "CACloudHelper.h"
#import "OCFileDto.h"
#import "NSDictionary+HandleNull.h"
@implementation CACloudHelper
//+ (CACloudHelper*)sharedHelper {
//    static dispatch_once_t once_token;
//    static CACloudHelper * sharedHelper;
//    dispatch_once(&once_token, ^{
//        sharedHelper = [[CACloudHelper alloc] init];
//        sharedHelper.userDefaults=[NSUserDefaults standardUserDefaults];
//    });
//    return sharedHelper;
//}
//
//-(void)setUserName:(NSString *)userName andUserPassword:(NSString *)password{
//    
//    _userName=userName;
//    _password=password;
//    [[self userDefaults] setObject:userName forKey:@"userName"];
//    [[self userDefaults] setObject:password forKey:@"password"];
//    [[self userDefaults] setBool:YES forKey:@"isLogin"];
//    [[self userDefaults] synchronize];
//}
//-(void)login{
//    [[AppDelegate sharedOCCommunication] setCredentialsWithUser:[[self userDefaults] objectForKey:@"userName"] andPassword:[[self userDefaults] objectForKey:@"password"]];
//}
//- (NSArray*)folders{
//    NSArray * folders=[[self userDefaults] objectForKey:All_Folders_Key];
//    NSMutableArray * newFolders=[NSMutableArray array];
//    for (NSDictionary * dic in folders) {
//        OCFileDto * folder=[[OCFileDto alloc]init];
//        folder.fileTitle=[dic objectForKey:@"fileTitle"];
//        folder.fileName=[dic objectForKey:@"fileName"];
//        folder.filePath=[dic objectForKey:@"filePath"];
//        folder.isDirectory=[[dic objectForKey:@"isDirectory"] boolValue];
//        folder.size=[[dic objectForKey:@"size"] longValue];
//        folder.date=[[dic objectForKey:@"date"] longValue];
//        folder.etag=[[dic objectForKey:@"etag"] longValue];
//        [newFolders addObject:folder];
//    }
//    return newFolders;
//}
//- (void)updateFolders {
//    NSLog(@"request:%@",[_userDefaults objectForKey:@"serviceUrl"]);
//    [[AppDelegate sharedOCCommunication] readFolder:[_userDefaults objectForKey:@"serviceUrl"] onCommunication:[AppDelegate sharedOCCommunication] successRequest:^(NSHTTPURLResponse *response, NSArray *items, NSString *redirected) {
//        [[self userDefaults] removeObjectForKey:All_Folders_Key];
//        NSMutableArray * folders=[items valueForKey:@"fileName"];
//        
//        for (int i=1; i<items.count; i++){
//            OCFileDto * folder=items[i];
//            NSMutableDictionary * folderDic=[NSMutableDictionary dictionary];
//            [folderDic setValue:folder.fileName forKeyPath:@"fileName"];
//            [folderDic setValue:folder.filePath forKeyPath:@"filePath"];
//            [folderDic setValue:folder.fileTitle forKeyPath:@"fileTitle"];
//            [folderDic setValue:[NSNumber numberWithBool:folder.isDirectory] forKeyPath:@"isDirectory"];
//            [folderDic setValue:[NSNumber numberWithLong:folder.size] forKeyPath:@"size"];
//            [folderDic setValue:[NSNumber numberWithLong:folder.date] forKeyPath:@"date"];
//            [folderDic setValue:[NSNumber numberWithLongLong:folder.etag] forKeyPath:@"etag"];
//            [folders  addObject:folderDic];
//        }
//        [[self userDefaults] setObject:folders forKey:All_Folders_Key];
//        [[self userDefaults ] synchronize];
//        
////        if (_delegate) {
////            [_delegate cloudHelper:self didUpdateFolders:folders];
////        }
////        [[NSNotificationCenter defaultCenter] postNotificationName:Update_Folders_Notification_Name object:nil];
//        
//    } failureRequest:^(NSHTTPURLResponse *response, NSError *error) {
//        
//    }];
//}
//- (void)updateFoldersWithPath:(NSString *)path{
//    [[AppDelegate sharedOCCommunication] readFolder:[NSString stringWithFormat:@"%@%@",[_userDefaults objectForKey:@"serviceUrl"],path] onCommunication:[AppDelegate sharedOCCommunication] successRequest:^(NSHTTPURLResponse *response, NSArray *items, NSString *redirected) {
//        [[self userDefaults] removeObjectForKey:All_Folders_Key];
//        NSMutableArray * folders=[NSMutableArray array];
//        
//        for (int i=1; i<items.count; i++){
//            OCFileDto * folder=items[i];
//            NSMutableDictionary * folderDic=[NSMutableDictionary dictionary];
//            [folderDic setValue:folder.fileName forKeyPath:@"fileName"];
//            [folderDic setValue:folder.filePath forKeyPath:@"filePath"];
//            [folderDic setValue:folder.fileTitle forKeyPath:@"fileTitle"];
//            [folderDic setValue:[NSNumber numberWithBool:folder.isDirectory] forKeyPath:@"isDirectory"];
//            [folderDic setValue:[NSNumber numberWithLong:folder.size] forKeyPath:@"size"];
//            [folderDic setValue:[NSNumber numberWithLong:folder.date] forKeyPath:@"date"];
//            [folderDic setValue:[NSNumber numberWithLongLong:folder.etag] forKeyPath:@"etag"];
//            [folders  addObject:folderDic];
//        }
//        [[self userDefaults] setObject:folders forKey:All_Folders_Key];
//        [[self userDefaults ] synchronize];
//        
////        if (_delegate) {
////            [_delegate cloudHelper:self didUpdateFolders:folders];
////        }
//        //        [[NSNotificationCenter defaultCenter] postNotificationName:Update_Folders_Notification_Name object:nil];
//        
//    } failureRequest:^(NSHTTPURLResponse *response, NSError *error) {
//        
//    }];
//}
////-(NSUserDefaults *)userDefaults{
////    return [NSUserDefaults standardUserDefaults];
////}
@end
