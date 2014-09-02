        //
//  ImageShowViewController.m
//  Soapcom
//
//  Created by William.lin on 8/22/11.
//  Copyright 2011 Quidsi. All rights reserved.
//

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
    self.tabBarController.hidesBottomBarWhenPushed = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=_showFileDto.fileTitle;
    NSString * fileImagePath=@"";
    if ([CADataHelper placeHasSave:_showFileDto]) {
        fileImagePath=[CADataHelper filePath:_showFileDto.fileTitle];
    }
    else{
        fileImagePath=[CADataHelper urlWithOCFileDto:_showFileDto];
    }
    self.imageArray=[NSMutableArray arrayWithObject:fileImagePath];
    
    self.view.backgroundColor = [UIColor whiteColor];
	CGSize textSize1;
	textSize1.width = 210;
	textSize1.height = 42;
	NSString *titleString;
	if ([self.imageArray count] == 0) {
		titleString = [[NSString alloc] initWithFormat:@"No photo found."];
	}
	else {
		titleString = [[NSString alloc] initWithFormat:@"%d/%d",self.currentPage+1, (int)[self.imageArray count]];
	}

//    titlelabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 0, SCREEN_WIDTH - 200, 44)];
//	titlelabel.backgroundColor = [UIColor clearColor];
//	titlelabel.textAlignment = NSTextAlignmentCenter;
//	titlelabel.font = [UIFont systemFontOfSize:23];
//    titlelabel.shadowOffset = CGSizeMake(0, 1);
//    titlelabel.textColor = [UIColor whiteColor];
//    titlelabel.text = [NSString stringWithFormat:@"%@", titleString];
 
    //标题栏
//    NavBar *nav = [[NavBar alloc] initWithFrame:CGRectMake(0, 0, WIDTH, NAV_HEIGHT)];
//    [nav addSubview:titlelabel];
//    [nav bringSubviewToFront:titlelabel];
//    [self.view addSubview:nav];
    
//    //返回按钮
//    BackButton *buttonback = [[BackButton alloc] initWithFrame:CGRectMake(BACK_BUTTON_X,
//                                                                          BACK_BUTTON_Y, BACK_BUTTON_WIDTH, BACK_BUTTON_HEIGHT)];
//    [buttonback.buttonback addTarget:self
//                              action:@selector(BackClick)
//                    forControlEvents:UIControlEventTouchUpInside];
//    [nav addSubview:buttonback];
    
//    UIButton *buttonSeeAll = [[UIButton alloc] initWithFrame:CGRectMake(270,
//                                                                        7, 40, 30)];
//    [buttonSeeAll setTitle:@"全部" forState:UIControlStateNormal];
//    [buttonSeeAll addTarget:self
//                     action:@selector(SeeAllClick)
//           forControlEvents:UIControlEventTouchDown];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:buttonSeeAll];
}
- (void)setScrollView {
    if (scrollView) {
        scrollView=nil;
        [scrollView removeFromSuperview];
    }
    CGRect  screenBounds=[UIScreen mainScreen].bounds;
	scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, screenBounds.size.height, screenBounds.size.height-64)];
	scrollView.delegate = self;
    scrollView.backgroundColor = [UIColor clearColor];
	scrollView.pagingEnabled = YES;
    scrollView.bounces=NO;
    scrollView.contentSize = CGSizeMake(screenBounds.size.width * [self.imageArray count], scrollView.frame.size.height);
	scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    for (int i = 0; i < [self.imageArray count]; i++) {
        MyScrollView *ascrView = [[MyScrollView alloc] initWithFrame:CGRectMake(floor(screenBounds.size.width*i), -30, scrollView.frame.size.width, scrollView.frame.size.height)];
        ascrView.backgroundColor=[UIColor blackColor];
        
        if([self.imageArray[i] isKindOfClass:[UIImage class]])
        {
            ascrView.image=self.imageArray[i];
        }
        else if ([self.imageArray[i] hasPrefix:@"http"]) {
//            NSData *imgData=[NSData dataWithContentsOfURL:[NSURL URLWithString:self.imageArray[i]]];
            ascrView.imagePath=self.imageArray[i];
        }
        else
        {
            ascrView.image=[UIImage imageWithContentsOfFile:self.imageArray[i]];
        }
		ascrView.tag = 100+i;
		[scrollView addSubview:ascrView];
	}
//    if ([self.imageArray count] == 0) {
//        self.title = [[NSString alloc] initWithFormat:@"No photo found."];
//    }
//    else {
//        self.title = [[NSString alloc] initWithFormat:@"%d/%d",self.currentPage+1, (int)[self.imageArray count]];
//    }
    CGRect frame = scrollView.frame;
    frame.origin.x = frame.size.width * self.currentPage;
    frame.origin.y = 0;
    [scrollView scrollRectToVisible:frame animated:NO];
}

- (void)BackClick {
    [self.navigationController popViewControllerAnimated:YES];
}
//-(void)SeeAllClick
//{
//    SeeAllPhotoViewController *seeAll=[[SeeAllPhotoViewController alloc]init];
//    seeAll.delegate=self;
//    seeAll.imageArr=self.imageArray;
//    
//    [self.navigationController pushViewController:seeAll animated:YES];
//}

-(void)passValue:(int)value
{
    self.currentPage=value;
//    NSString *titleString = [[NSString alloc] initWithFormat:@"%d/%d",self.currentPage+1, (int)[self.imageArray count]];
//    self.title = [NSString stringWithFormat:@"%@", titleString];
    
    CGRect frame = scrollView.frame;
    frame.origin.x = frame.size.width * self.currentPage;
    frame.origin.y = 0;
    [scrollView scrollRectToVisible:frame animated:NO];
}


#pragma mark ScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)t_scrollView
{
	CGFloat pageWidth = t_scrollView.frame.size.width;
	NSInteger page = floor((t_scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
//	self.title = [NSString stringWithFormat:@"%d/%d", page+1, [self.imageArray count]];
	if (self.currentPage != page)
	{
		MyScrollView *aView = (MyScrollView *)[t_scrollView viewWithTag:100+self.currentPage];
		aView.zoomScale = 1.0;
		
		self.currentPage = page;
	}
}


@end
