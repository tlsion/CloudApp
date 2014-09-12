//
//  CABaseNavigationController.m
//  CloudApp
//
//  Created by Pro on 8/16/14.
//  Copyright (c) 2014 王庭协. All rights reserved.
//

#import "CABaseNavigationController.h"

@interface CABaseNavigationController ()

@end

@implementation CABaseNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (IS_IOS_7) {
        [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"顶部蓝条64.png"] forBarMetrics:UIBarMetricsDefault];
        
        [self.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                    WHITE,
                                                    UITextAttributeTextColor,nil]];
    }else{
        [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"顶部蓝条.png"] forBarMetrics:UIBarMetricsDefault];
    }
}
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    //    viewController.hidesBottomBarWhenPushed = YES;
    
    MainTabBarViewController * tab=(MainTabBarViewController *)self.tabBarController;
    [tab showTabbar:NO];

    [super pushViewController:viewController animated:YES];
}
-(UIViewController*)popViewControllerAnimated:(BOOL)animated
{
    
    //还有2级的时候 判断是否 显示 tabbar
    if (self.viewControllers.count <= 2) {
        MainTabBarViewController * tab=(MainTabBarViewController *)self.tabBarController;
        [tab showTabbar:YES];
        //        self.tabBarController.tabBar.hidden = NO;
    }
    return [super popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
