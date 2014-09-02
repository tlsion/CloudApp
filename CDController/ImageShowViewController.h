//
//  ImageShowViewController.h
//  Soapcom
//
//  Created by William.lin on 8/22/11.
//  Copyright 2011 Quidsi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyScrollView.h"
//#import "SeeAllPhotoViewController.h"
#import "OCFileDto.h"
@interface ImageShowViewController : UIViewController<UIAlertViewDelegate,UIScrollViewDelegate> {
	UIScrollView *scrollView;
//	UILabel *titlelabel;
    int maxHeight;
}
@property (strong, nonatomic) OCFileDto * showFileDto;
@property (strong, nonatomic) NSMutableArray *imageArray;
@property (assign) int currentPage;

//@property(strong,nonatomic)NSMutableArray * imageFileId;
@end
