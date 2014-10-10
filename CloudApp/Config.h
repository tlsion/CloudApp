//
//  BCConfig.h
//  cycling
//
//  Created by Pro on 3/4/14.
//  Copyright (c) 2014 王庭协. All rights reserved.
//

#ifndef CloudApp_Config_h
#import "AppDelegate.h"
#import "MVHTTPService.h"
#import "UIView+Action.h"
#import "CrateComponent.h"
#import "UIViewExt.h"
#import "CAGlobalData.h"
#import "ViewUtils.h"
#import "TXUtils.h"
#import "CADataHelper.h"
#import "CommonDefine.h"
#define DownLoadURL @"http://27.154.58.234:2001/version.php?type=ios"
//#define GaodeMapAppKey @"d73c73813b05a824b45689bb09f6f907"
//#define UmengAppkey @"53a39c7e56240b5c70078ad5"
#define STORYBAORD_NAME @"Main"
#define APP (AppDelegate *)[[UIApplication sharedApplication] delegate]

#define LuckyNoticeCount 10
#define LuckyTimer 3

#define TIMER 5
//导航栏高度
#define NAV_HEIGHT 44.0f
#define NAV_HEI_64 64.0f
#define TAB_HEIGHT 49.0f

#define SCREEN_MAX_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_MAX_HEIGHT [UIScreen mainScreen].bounds.size.height

//#define PIC_SCALE_WIDTH 320.0/480
//#define PIC_SCALE_HEIGHT [UIScreen mainScreen].bounds.size.height/800
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) //并发队列
#define kMainQueue dispatch_get_main_queue() //主线程队列

#define FORMAT(format, ...) [NSString stringWithFormat:(format), ##__VA_ARGS__]

//字体
#define FONTSIZES(x) [UIFont systemFontOfSize:x]
#define FONTBOLD(x) [UIFont boldSystemFontOfSize:x]
#define FONT_BIG [UIFont boldSystemFontOfSize:15]
#define FONT_MID [UIFont boldSystemFontOfSize:13]
#define FONT_SMA [UIFont boldSystemFontOfSize:11]
//#define FONT_BESTBIG [UIFont fontWithName:@"Heiti SC" size:20]
//颜色
#define YAHEI [UIColor colorWithRed:61.0/255 green:61.0/255 blue:61.0/255 alpha:1]
#define GRAY [UIColor colorWithRed:161.0/255 green:161.0/255 blue:161.0/255 alpha:1]
#define SubBlue [UIColor colorWithRed:0.0/255.0 green:193.0/255.0 blue:255.0/255.0 alpha:1]
#define CLEAR [UIColor clearColor]
#define WHITE [UIColor whiteColor]
#define RGB(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBA(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
//提示
#define ALERT(msg)  [[[UIAlertView alloc]initWithTitle:@"" message:msg delegate:nil \
cancelButtonTitle:@"确定" otherButtonTitles:nil,nil] show]
//版本
#define  SystemVersion [[[UIDevice currentDevice]systemVersion]floatValue]

//#define iOS7  ( [[[UIDevice currentDevice] systemVersion] compare:@"7.0"] != NSOrderedAscending )

//#define MYBUNDLE_NAME @ "mapapi.bundle"
//#define MYBUNDLE_PATH [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: MYBUNDLE_NAME]
//#define MYBUNDLE [NSBundle bundleWithPath: MYBUNDLE_PATH]

#define SERVICE_URL @"http://27.154.58.234:2001"
//#define HomeFolderPath [NSString stringWithFormat:@"%@/ext/storage/remote.php/webdav/",SERVICE_URL]
//user
static NSString *baseUser = @"admin";
////password
static NSString *basePassword = @"admin1";

//To test the download you must be enter a path of specific file
static NSString *pathOfDownloadFile = @"path of file to download"; //@"LibExampleDownload/default.png";

//Optional. Set the path of the file to upload
static NSString *pathOfUploadFile = @"1_new_file.jpg";

//#define SERVICE_URL @"http://192.168.0.144:8080/NewMovie"
//#define SERVICE_URL @"http://59.61.92.182:86/NewMovie"
#define IMAGE_URL(name) [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",[[NSUserDefaults standardUserDefaults] objectForKey:User_ServiceUrl],name]]
//#define IMG_URL(path) [NSURL URLWithString:path]

#define All_Folders_Key @"AllFolders"
//#define Update_Folders_Notification_Name @"UPDATE_FOLDERS"
#endif
