//
//  CAMoveFolderViewController.h
//  CloudApp
//
//  Created by Pro on 8/27/14.
//  Copyright (c) 2014 王庭协. All rights reserved.
//

#import "CASubTabViewController.h"

@interface CAMoveFolderViewController : CASubTabViewController

@property (nonatomic, copy) NSString * folderPath;

@property (nonatomic,strong) NSMutableArray *itemsOfPath;
@property (strong, nonatomic) IBOutlet UITableView *itemsTableView;
@property (nonatomic, copy) NSString * sourcePath;
@property (nonatomic, strong) OCFileDto * itemDto;
@property (nonatomic, weak) id homeDelegate;
@property (nonatomic, weak) id currentDelegate;
@end
