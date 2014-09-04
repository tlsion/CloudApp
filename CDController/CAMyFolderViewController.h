//
//  CAMyFolderViewController.h
//  CloudApp
//
//  Created by Pro on 7/25/14.
//  Copyright (c) 2014 王庭协. All rights reserved.
//
//wang
#import "CASubTabViewController.h"

@interface CAMyFolderViewController : CASubTabViewController
@property (nonatomic, assign) BOOL az_isRootPath;
@property (nonatomic, copy) NSString * az_folderPath;

@property (nonatomic,strong) NSArray *itemsOfPath;
@property (strong, nonatomic) IBOutlet UITableView *itemsTableView;
-(void)getFoldersData;
-(void)getFoldersDataReloadData;
@end
