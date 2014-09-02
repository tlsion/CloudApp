//
//  CAFolderOperateView.h
//  CloudApp
//
//  Created by Pro on 8/11/14.
//  Copyright (c) 2014 王庭协. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, CAFloderOperateCode) {
    CAFloderOperateCodeDownload=1,
    CAFloderOperateCodeDelete,
    CAFloderOperateCodeRechristen,
    CAFloderOperateCodeMove
};
@protocol CAFloderOperateDelegate <NSObject>

-(void)selectFolderOperate:(CAFloderOperateCode) code;

@end
@interface CAFolderOperateView : UIView
@property (assign ,nonatomic) id<CAFloderOperateDelegate> delegate;
@property (assign, nonatomic) BOOL isShow;
@property (assign, nonatomic) BOOL isDirectory;
@end
