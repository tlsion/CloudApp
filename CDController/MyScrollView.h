//
//  MyScrollView.h
//  PhotoBrowserEx
//
//  Created by  on 10-6-12.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "ImageManager.h"
#import "EGOImageView.h"
@interface MyScrollView : UIScrollView <UIScrollViewDelegate>
{
    NSString *imagePath;
	EGOImageView *imageView;
}

@property (nonatomic, copy) NSString *imagePath;
@property (nonatomic, strong) UIImage *image;
@end
