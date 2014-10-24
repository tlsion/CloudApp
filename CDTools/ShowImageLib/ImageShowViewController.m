        //
//  ImageShowViewController.m
//  Soapcom
//
//  Created by William.lin on 8/22/11.
//  Copyright 2011 Quidsi. All rights reserved.
//


#define MY_SCROLLVIEW_TAG 100
#import "ImageShowViewController.h"

@implementation ImageShowViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self performSelectorOnMainThread:@selector(setScrollView)
                           withObject:nil
                        waitUntilDone:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customNavigationBar];
    
    
    self.title=_showFileDto.fileTitle;
    
    if ([CADataHelper placeHasSave:_showFileDto]) {
        NSString * fileImagePath=[CADataHelper filePath:_showFileDto.fileTitle];
        self.imageArray=[NSMutableArray arrayWithObject:fileImagePath];
    }
    else{
        NSURL * imageURL=[NSURL URLWithString:[CADataHelper urlWithOCFileDto:_showFileDto]];
         self.imageArray=[NSMutableArray arrayWithObject:imageURL];
    }
    
    self.view.backgroundColor = [UIColor whiteColor];
//    CGSize textSize1;
//    textSize1.width = 210;
//    textSize1.height = 42;
//    NSString *titleString;
//    if ([self.imageArray count] == 0) {
//        titleString = [[NSString alloc] initWithFormat:@"No photo found."];
//    }
//    else {
//        titleString = [[NSString alloc] initWithFormat:@"%d/%d",self.currentPage+1, (int)[self.imageArray count]];
//    }
    
    
    //    //展示全部按钮
//    if (_isOwn) {
//        UIButton *buttonSeeAll = [[UIButton alloc] initWithFrame:CGRectMake(270,
//                                                                            7, 40, 30)];
//        [buttonSeeAll setTitle:@"删除" forState:UIControlStateNormal];
//        [buttonSeeAll addTarget:self
//                         action:@selector(deleteClick)
//               forControlEvents:UIControlEventTouchDown];
//        [nav addSubview:buttonSeeAll];
//
//    }
//    else{
//        UIButton *buttonSeeAll = [[UIButton alloc] initWithFrame:CGRectMake(270,
//                                                                            7, 40, 30)];
//        [buttonSeeAll setTitle:@"全部" forState:UIControlStateNormal];
//        [buttonSeeAll addTarget:self
//                         action:@selector(SeeAllClick)
//               forControlEvents:UIControlEventTouchDown];
//        [nav addSubview:buttonSeeAll];
//
//    }
}

-(void)customNavigationBar{
    //    UIImageView  * logoImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"左上角LOGO.png"]];
    //    UIBarButtonItem * leftBarItem=[[UIBarButtonItem alloc]initWithCustomView:logoImageView];
    //    [self.navigationItem setLeftBarButtonItem:leftBarItem];
    
    if (self.navigationController.viewControllers.count>1) {
        UIBarButtonItem * backBarItem=[CrateComponent createBackBarButtonItemWithTarget:self andAction:@selector(backAction)];
        [self.navigationItem setLeftBarButtonItem:backBarItem];
    }
    
    //    UIBarButtonItem * rightBarItem=[CrateComponent createRightBarButtonItemWithTitle:@"注册" andTarget:self andAction:@selector(registerAction)];
    //    [self.navigationItem setRightBarButtonItem:rightBarItem];
}
-(void)backAction{
    if (
        ![self.navigationController popViewControllerAnimated:YES]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
    //     [self dismissViewControllerAnimated:YES completion:nil];
    //    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setO_title:(NSString *)o_title{
    UILabel * titleLabel=(UILabel *)self.navigationItem.titleView;
    titleLabel.text=o_title;
}
- (void)setScrollView {
    if (scrollView) {
        scrollView=nil;
        [scrollView removeFromSuperview];
    }
	scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
	scrollView.delegate = self;
//    scrollView.backgroundColor = [UIColor blackColor];
	scrollView.pagingEnabled = YES;
    scrollView.bounces=NO;
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width * [self.imageArray count], self.view.frame.size.height);
	scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    for (int i = 0; i < [self.imageArray count]; i++) {
        MyScrollView *ascrView = [[MyScrollView alloc] initWithFrame:CGRectMake(floor(scrollView.frame.size.width*i), 0, scrollView.frame.size.width, scrollView.frame.size.height)];
        
        [scrollView makeToastActivity];
        
        [scrollView addSubview:ascrView];
        
        id element = self.imageArray[i];
        if([element isKindOfClass:[UIImage class]])
        {
            ascrView.image=self.imageArray[i];
        }
        else if ([element isKindOfClass:[NSURL class]]) {
            ascrView.imageURL=self.imageArray[i];
        }
        else
        {
            ascrView.imagePath=self.imageArray[i];
        }
		ascrView.tag = MY_SCROLLVIEW_TAG+i;
        
	}
    //避免超出试图范围
    if (self.currentPage>=self.imageArray.count) {
        self.currentPage=self.imageArray.count-1;
    }
    
    CGRect frame = scrollView.frame;
    frame.origin.x = frame.size.width * self.currentPage;
    frame.origin.y = 0;
    [scrollView scrollRectToVisible:frame animated:NO];
    
    if ([self.imageArray count] == 0) {
        self.o_title = [[NSString alloc] initWithFormat:@"No photo found."];
    }
    else {
        self.o_title = [[NSString alloc] initWithFormat:@"%d/%d",self.currentPage+1, [self.imageArray count]];
    }
    
}
- (void)BackClick {
//    if (_isDelete) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"FINISHEN_DELETEPIC" object:nil];
//    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)t_scrollView
{
	CGFloat pageWidth = t_scrollView.frame.size.width;
	NSInteger page = floor((t_scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    self.currentPage=page;
	self.o_title = [NSString stringWithFormat:@"%d/%d", self.currentPage+1, [self.imageArray count]];
//	if (self.currentPage != page)
//	{
//		MyScrollView *aView = (MyScrollView *)[t_scrollView viewWithTag:MY_SCROLLVIEW_TAG+self.currentPage];
//		aView.zoomScale = 1.0;
//        self.currentPage=page;
//	}
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationLandscapeRight;
}

@end
