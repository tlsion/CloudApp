//
//  ImageShowViewController.h
//  Soapcom
//
//  Created by William.lin on 8/22/11.
//  Copyright 2011 Quidsi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyScrollView.h"
#import "OCFileDto.h"
@interface ImageShowViewController : CASuperViewController<UIAlertViewDelegate,UIScrollViewDelegate> {
	UIScrollView *scrollView;
}
@property (strong, nonatomic) OCFileDto * showFileDto;
@property (copy, nonatomic) NSString * o_title;
@property (strong, nonatomic) NSMutableArray *imageArray; // 可以有UIImage、NSURL 、NSString(本地路径)
@property (assign) NSInteger currentPage;

@end
