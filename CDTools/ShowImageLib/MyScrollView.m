//
//  MyScrollView.m
//  PhotoBrowserEx
//
//  Created by on 10-6-12.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MyScrollView.h"

@implementation MyScrollView


#pragma mark -
#pragma mark === Intilization ===
#pragma mark -
- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame]))
	{
		self.delegate = self;
		self.minimumZoomScale = 0.5;
		self.maximumZoomScale = 2.5;
		self.showsVerticalScrollIndicator = NO;
		self.showsHorizontalScrollIndicator = NO;
//        self.backgroundColor=[UIColor blackColor];
        
		imageView  = [[EGOImageView alloc] initWithPlaceholderImage:nil delegate:self];
        imageView.frame=CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [imageView setContentMode:UIViewContentModeScaleAspectFit];
        [imageView setTag:100];
        [imageView setUserInteractionEnabled:NO];
//        [imageView setDelegate:self];
		//imageView.contentMode = UIViewContentModeCenter;
		[self addSubview:imageView];
    }
    return self;
}
- (void)setImageURL:(NSURL *)imageURL
{
    [imageView setImageURL:imageURL];
    
    [self.superview makeToastActivity];
}
- (void)setImagePath:(NSString *)path
{
    imageView.image=[UIImage imageWithContentsOfFile:path];
}

- (void)setImage:(UIImage *)image
{
    imageView.image = image;
}

#pragma mark -
#pragma mark === UIScrollView Delegate ===
#pragma mark -
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{	
	return imageView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale
{
	CGFloat zs = scrollView.zoomScale;
	zs = MAX(zs, 1.0);
	zs = MIN(zs, 2.0);	
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];		
	scrollView.zoomScale = zs;	
	[UIView commitAnimations];
}

#pragma mark -
#pragma mark === UITouch Delegate ===
#pragma mark -
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [touches anyObject];
	
	if ([touch tapCount] == 2) 
	{
		
		CGFloat zs = self.zoomScale;
		zs = (zs == 1.0) ? 2.0 : 1.0;
		
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.3];			
		self.zoomScale = zs;	
		[UIView commitAnimations];
	}
}



- (void)imageViewLoadedImage:(EGOImageView*)imageView{
    
    [self.superview hideToastActivity];
}
- (void)imageViewFailedToLoadImage:(EGOImageView*)imageView error:(NSError*)error{
    [self.superview makeToast:@"下载出错"];
    [self.superview hideToastActivity];
}

@end
