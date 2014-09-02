//
//  UIViewController+TopView.h
//  Diancan
//
//  Created by chenzhihui on 13-9-29.
//  Copyright (c) 2013年 青岛晨之辉信息服务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface UIViewController (TopView)
typedef void (^LeftButtonBlcok)();
typedef void (^RightButtonBlcok)();
-(void)setLeftButtonAction:(LeftButtonBlcok)block;
-(void)setRightButtonAction:(RightButtonBlcok)block;
-(void)loadLeftButton:(NSString *)imageNameNor andSelected:(NSString *)imageSe;
-(void)loadRightButton:(NSString *)imageNameNor andSelected:(NSString *)imageSe;
-(void)loadNavBar;
-(void)loadMiddleView:(NSString *)title;
@end
