//
//  MainTabBarViewController.m
//  Aite
//
//  Created by EDITOR on 13-10-23.
//  Copyright (c) 2013年 王庭协. All rights reserved.
//

#import "MainTabBarViewController.h"
#import "CATransferListViewController.h"
#import "CAMoreViewController.h"
#import "CAMyFolderViewController.h"
#import "CABaseNavigationController.h"
#import "UIViewExt.h"
#import <QuartzCore/QuartzCore.h>

@interface MainTabBarViewController ()
{
    CAFolderOperateView * aq_folderBottomOperateBgView;
}
@end

@implementation MainTabBarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [self.tabBar setHidden:YES];
    }
    return self;
}
-(void)initViewController
{
    //创建几个视图控制器
    CAMyFolderViewController * vc1=[[CAMyFolderViewController alloc]init];
    vc1.az_isRootPath=YES;
    [vc1 setTitle:@"赛凡云"];
    
    CATransferListViewController * vc2=[[CATransferListViewController alloc]init];
    [vc2 setTitle:@"传输列表"];
    CAMoreViewController * vc3=[[CAMoreViewController alloc]init];
    
    NSArray * views=[NSArray arrayWithObjects:vc1,vc2,vc3, nil];
    
    NSMutableArray * viewControllers = [NSMutableArray arrayWithCapacity:views.count];
    for (UIViewController * viewController in views) {
        CABaseNavigationController * nav = [[CABaseNavigationController alloc]initWithRootViewController:viewController];
//        nav.navigationBarHidden=YES;
        [viewControllers addObject:nav];
    }
    self.viewControllers = viewControllers;
}
// 创建自定义Tab
-(void)initTabbarView
{
    _tabbarView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_MAX_HEIGHT-49, 320, 49)];
    [self.view addSubview:_tabbarView];
    // 设置 tabbar 的背景图片
    _tabbarView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"操作按钮底部.png"]];
    // 存按钮背景图片
    NSMutableArray * backgroud =[NSMutableArray arrayWithCapacity:self.viewControllers.count];
    NSMutableArray * heightBackground =[NSMutableArray arrayWithCapacity:self.viewControllers.count];
    for (int i=0; i<self.viewControllers.count; i++) {
        NSString * backgroudStr=[NSString stringWithFormat:@"tab_icon%d",i+1];
        [backgroud addObject:backgroudStr];
        
        NSString * heightBackgroudStr=[NSString stringWithFormat:@"tab_icon%d_select",i+1];
        [heightBackground addObject:heightBackgroudStr];
    };
    NSArray * titles=[NSArray arrayWithObjects:@"我的目录",@"传输列表",@"我的设置", nil];
    //用for语句 给按钮设置图片
    btnArr =[[NSMutableArray alloc]init];
    for (int i = 0; i<backgroud.count; i++)
    {
        NSString * backImage =  [backgroud objectAtIndex:i];
        NSString * heightImage = [heightBackground objectAtIndex:i];
        
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake((320/self.viewControllers.count)*i, 0, SCREEN_MAX_WIDTH/self.viewControllers.count, 49);
        btn.tag = i;
        btn.showsTouchWhenHighlighted = YES;
        [btn setImage:[UIImage imageNamed:heightImage] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:backImage] forState:UIControlStateHighlighted];
        [btn setImage:[UIImage imageNamed:backImage] forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(selectedTab:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitle:[titles objectAtIndex:i] forState:UIControlStateNormal];
        [btn setTitleColor:GRAY forState:UIControlStateNormal];
        [btn setTitleColor:SubBlue forState:UIControlStateHighlighted];
        [btn setTitleColor:SubBlue forState:UIControlStateSelected];
        btn.titleLabel.font=FONT_MID;
        
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 4, 0, -4)];
        [btn setImageEdgeInsets:UIEdgeInsetsMake(0, -4, 0, 4)];
        
        
        if (i==0) {
            btn.selected=YES;
        }
        [_tabbarView addSubview:btn];
        [btnArr addObject:btn];
    } 
}


-(void)_resizeView:(BOOL)show
{
    for (UIView * subView in self.view.subviews) {
        if (show) {
            subView.height = SCREEN_MAX_HEIGHT - 49+20;
        }
        else
        {
            subView.height = SCREEN_MAX_HEIGHT+20;
        }
    }
}
// 显示、隐藏未读数
-(void)showBadge:(BOOL)show
{
    _badgeView.hidden = !show;
}
// 是否隐藏tabbar
-(void)showTabbar:(BOOL)show
{
    [UIView animateWithDuration:0.5 animations:^{
    if (show) {
//        _tabbarView.left = 0;
        _tabbarView.bottom=SCREEN_MAX_HEIGHT;
    }
    else
    {
        _tabbarView.bottom=SCREEN_MAX_HEIGHT+49;
//        _tabbarView.left = -SCREEN_MAX_WIDTH;
    }
    }];
//    [self _resizeView:show];
}
// tab 按钮的点击事件
-(void)selectTab:(UIButton * )button
{
    float x = button.left + (button.width -_sliderView.width)/2;
    [UIView animateWithDuration:0.2 animations:^{
        _sliderView.left = x ;
    }];
    // 判断是否是重复点击tab 按钮
    if (button.tag == self.selectedIndex && button.tag==0) {
        
    }
}

// 通过tag切换界面 。
-(void)selectedTab:(UIButton * )button
{
    for (UIButton * b in btnArr) {
        b.selected=NO;
    }
    button.selected=YES;
    self.selectedIndex =button.tag;
}
-(void)showFileTabbar:(BOOL)show andIsFolder:(BOOL)isDirectory{
    
    if (show && !aq_folderBottomOperateBgView.isShow) {
        
        aq_folderBottomOperateBgView.isDirectory=isDirectory;
        
        [UIView animateWithDuration:0.3 animations:^{
            _tabbarView.bottom=SCREEN_MAX_HEIGHT+49;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3 animations:^{
                aq_folderBottomOperateBgView.bottom=SCREEN_MAX_HEIGHT;
            }];
        }];
    }
    else{
        [UIView animateWithDuration:0.3 animations:^{
            
            aq_folderBottomOperateBgView.bottom=SCREEN_MAX_HEIGHT+49;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3 animations:^{
                _tabbarView.bottom=SCREEN_MAX_HEIGHT;
            }];
        }];
    }
}
- (void)viewDidLoad
{
    
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.tabBar.hidden = YES;
    self.view.backgroundColor=[UIColor whiteColor];
    
    [[CAGlobalData shared] setAz_mainTab:self];
    
//    [self initViewController];
    CABaseNavigationController * nc1=self.viewControllers[0];
    CAMyFolderViewController * vc1=nc1.viewControllers[0];
    vc1.az_isRootPath=YES;
//    [vc1 setTitle:@"赛凡云"];
//
//    CATransferListViewController * vc2=[[CATransferListViewController alloc]init];
//    [vc2 setTitle:@"传输列表"];
//    CAMoreViewController * vc3=[[CAMoreViewController alloc]init];
    aq_folderBottomOperateBgView=[ViewUtils loadViewWithViewClass:[CAFolderOperateView class]];
    aq_folderBottomOperateBgView.frame=CGRectMake(0, SCREEN_MAX_HEIGHT, 320, 49);
    aq_folderBottomOperateBgView.delegate=self;
    [self.view addSubview:aq_folderBottomOperateBgView];
    
    [self initTabbarView];
    
    
}
-(void)selectFolderOperate:(CAFloderOperateCode)code{
    if (_az_operateDelegate && [_az_operateDelegate respondsToSelector:@selector(selectDidClick:)]) {
        [_az_operateDelegate selectDidClick:code];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
@end  