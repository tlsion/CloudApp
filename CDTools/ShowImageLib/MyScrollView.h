//
//  MyScrollView.h
//  PhotoBrowserEx
//
//  Created by  on 10-6-12.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"
@interface MyScrollView : UIScrollView <UIScrollViewDelegate,EGOImageViewDelegate>
{
	EGOImageView *imageView;
}
@property (nonatomic, strong) NSURL *imageURL;
@property (nonatomic, copy) NSString *imagePath;
@property (nonatomic, strong) UIImage *image;
@end
