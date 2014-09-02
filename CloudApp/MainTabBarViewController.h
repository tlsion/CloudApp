//
//  MainTabBarViewController.h
//  Aite
//
//  Created by EDITOR on 13-10-23.
//  Copyright (c) 2013年 王庭协. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CAFolderOperateView.h"
@protocol BottonOperateDelegate;

@interface MainTabBarViewController : UITabBarController<CAFloderOperateDelegate>
{
    UIView * _tabbarView;
    UIImageView * _sliderView;
    UIImageView * _badgeView;
    NSMutableArray * btnArr;
}

@property (weak ,nonatomic) id<BottonOperateDelegate> az_operateDelegate;
@property (copy,nonatomic)NSString *count;
-(void)showBadge:(BOOL)show;
-(void)showTabbar:(BOOL)show;

-(void)showFileTabbar:(BOOL)show andIsFolder:(BOOL) isDirectory;
@end
@protocol BottonOperateDelegate <NSObject>

-(void)selectDidClick:(CAFloderOperateCode) code;

@end