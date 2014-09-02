//
//  CALoginViewController.h
//  CloudApp
//
//  Created by Pro on 7/31/14.
//  Copyright (c) 2014 王庭协. All rights reserved.
//

#import "CASuperViewController.h"
#import "CAMyFolderViewController.h"
@interface CALoginViewController : CASuperViewController
@property (nonatomic,weak) CAMyFolderViewController * delegate;
@end
