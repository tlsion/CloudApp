//
//  SeeAllPhotoViewController.h
//  shangliang
//
//  Created by 智美合 on 14-2-25.
//  Copyright (c) 2014年 huangbaozhi. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol PassValueDelegate <NSObject>

-(void)passValue:(int)value;

@end

@interface SeeAllPhotoViewController : UIViewController
@property(strong,nonatomic)NSMutableArray *imageArr;
@property(assign,nonatomic)id<PassValueDelegate>delegate;

@end
