//
//  TXCommon.m
//  CloudApp
//
//  Created by Pro on 8/16/14.
//  Copyright (c) 2014 王庭协. All rights reserved.
//

#import "TXCommon.h"

@implementation CASuperViewController (CACloudApp)

- (void)viewDidLoad {
    
    [super viewDidLoad];
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
//    //自动添加"后退"按钮
//    [self customBackButton];
//    
//    //为NavigationBar和TabBar添加阴影
//    [self appendShadowToViews];
//    
//    //    self.view.backgroundColor = RGBCOLOR(241, 241, 239);
//    //自动添加标题Label
//    [self customTitleLabel];
}

//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//}
//
//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    
//    //自定义导航条
////    [self customNavigationBar];
//}

//-(UIStatusBarStyle)preferredStatusBarStyle{
//    return UIStatusBarStyleLightContent;
//}


//- (void)back {
//    [self.navigationController popViewControllerAnimated:YES];
//}
//
//- (void)setTabBarItemImageName:(NSString *)imageName withSelectedImageName:(NSString *)selectedImageName {
//    
//    [self.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:selectedImageName]
//                  withFinishedUnselectedImage:[UIImage imageNamed:imageName]];
//    
//    self.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
//}
//
///**
// *自定义添加标题Label,用于某些界面的标题修改方便
// */
//- (void)customTitleLabel {
//    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 160, 50)];
//    [titleLabel setBackgroundColor:[UIColor clearColor]];
//    titleLabel.textAlignment =  NSTextAlignmentCenter;
//    
//    [titleLabel setTextColor:[UIColor whiteColor]];
//    titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:18];
//    titleLabel.text = self.navigationItem.title;
//    self.navigationItem.titleView = titleLabel;
//}

/**
 * 自定义NavigationBar，如果是一级界面，使用带Logo的导航栏背景
 */
//- (void)customNavigationBar {
//    
//    UINavigationBar *navigationBar = self.navigationController.navigationBar;
//    
//    if ([DeviceUtils deviceSystemVersion] >= 7) {
//        self.edgesForExtendedLayout = UIRectEdgeNone;
//        self.extendedLayoutIncludesOpaqueBars = true;
//        self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
//        self.navigationController.navigationBar.translucent = false;
//        
//        self.navigationController.navigationBar.titleTextAttributes = @{
//                                                                        NSForegroundColorAttributeName: [UIColor whiteColor],
//                                                                        NSFontAttributeName: [UIFont systemFontOfSize:18.0]
//                                                                        };
//    } else {
//        self.navigationController.navigationBar.titleTextAttributes = @{
//                                                                        NSForegroundColorAttributeName: [UIColor whiteColor],
//                                                                        NSFontAttributeName: [UIFont systemFontOfSize:18.0]
//                                                                        };
//    }
//    
//    [navigationBar setBackgroundImage:[UIImage imageNamed:([DeviceUtils deviceSystemVersion] >= 7) ? @"red_nav_bg_568" : @"red_nav_bg"] forBarMetrics:UIBarMetricsDefault];
//    [navigationBar setBackgroundColor:[UIColor whiteColor]];
//    
//}

//- (void)customBackButton {
//    NSArray *controllers = self.navigationController.viewControllers;
//    if ((controllers.count > 1 && [controllers objectAtIndex:controllers.count-1] == self) /*|| [self isKindOfClass:[PlatformCartViewController class]]*/) {
//        
//        UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        backButton.frame = CGRectMake(0, 0, 40, 40);
//        
//        [backButton setImage:[UIImage imageNamed:@"back_btn"] forState:UIControlStateNormal];
//        [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
//        
//        UIControl *control = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
//        [control addSubview:backButton];
//        [control addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
//        
//        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:control];
//        leftItem.style = UIBarButtonItemStyleDone;
//        
//        self.navigationItem.leftBarButtonItem = leftItem;
//    }
//}
//
//- (void)addNavigationRightBarButtonItemWithView:(UIView *)view {
//    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:view];
//    item.style = UIBarButtonItemStyleDone;
//    
//    NSMutableArray *rightItems = [NSMutableArray arrayWithArray:self.navigationItem.rightBarButtonItems];
//    [rightItems addObject:item];
//    self.navigationItem.rightBarButtonItems = rightItems;
//}
//
///**
// * 如果系统版本小于iOS 6，则为NavigationBar和TabBar添加阴影
// */
//- (void)appendShadowToViews {
//    
//    if ([DeviceUtils deviceSystemVersion] >= 6.0f) {
//        return;
//    }
//    
//    UINavigationBar *navigationBar = self.navigationController.navigationBar;
//    [self addShadowToView:navigationBar];
//    
//    UITabBar *tabBar = self.tabBarController.tabBar;
//    [self addShadowToView:tabBar];
//}
//
///**
// * 为UIView添加阴影
// */
//- (void)addShadowToView:(UIView *)view {
//    view.layer.masksToBounds = NO;
//    view.layer.shadowColor = [[UIColor grayColor] CGColor];
//    view.layer.shadowOpacity = 0.8f;
//    view.layer.shadowRadius = 2.0f;
//    view.layer.shadowOffset = CGSizeMake(0, 0);
//}
//

-(void) dealloc
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
#ifdef DEBUG
    NSLog(@"Class %@ dealloc -----!-----\n\n",[self class]);
#endif
    
    
    
}

@end