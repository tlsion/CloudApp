//
//  MDSlideNavigationViewController.m
//  MDSlideNavigationController
//
//  Created by Mohammed Eldehairy on 6/2/13.
//  Copyright (c) 2013 Mohammed Eldehairy. All rights reserved.
//

#import "MDSlideNavigationViewController.h"
@interface MDSlideNavigationViewController ()

@end

@implementation MDSlideNavigationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)loadLayerWithImage
{
   

    //获取上下文 默认为1倍大小
    
    UIGraphicsBeginImageContext(self.visibleViewController.view.bounds.size);
    //将当前的layer绘制到上下文中
    [self.visibleViewController.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    //获取当前屏幕的图像
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    [animationLayer setContents: (id)viewImage.CGImage];
    [animationLayer setHidden:NO];
    
    
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"顶部蓝条64.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                     WHITE,
                                                                     UITextAttributeTextColor,nil]];
    
    animationLayer = [CALayer layer] ;
    CGRect layerFrame = self.view.frame;
    layerFrame.origin.y=layerFrame.origin.y+20;
    animationLayer.frame = layerFrame;
    animationLayer.masksToBounds = YES;
    [animationLayer setContentsGravity:kCAGravityBottomLeft];
    [self.view.layer insertSublayer:animationLayer atIndex:0];
    animationLayer.delegate = self;
    
    
}
- (id<CAAction>)actionForLayer:(CALayer *)layer forKey:(NSString *)event
{
    id<CAAction> action = (id)[NSNull null];
    return action;
}

-(void)viewWillLayoutSubviews{
    [super viewWillLayoutSubviews];
    CGRect layerFrame = self.view.bounds;
    layerFrame.origin.y=layerFrame.origin.y+20;
    animationLayer.frame = layerFrame;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [animationLayer removeFromSuperlayer];
    [self.view.layer insertSublayer:animationLayer atIndex:0];
    
    
//    viewController.hidesBottomBarWhenPushed = YES;
    
    MainTabBarViewController * tab=(MainTabBarViewController *)self.tabBarController;
    [tab showTabbar:NO];
    
    if(animated)
    {
        [self loadLayerWithImage];
        UIView * toView = [viewController view];
        CABasicAnimation *Animation  = [CABasicAnimation animationWithKeyPath:@"transform"];
        CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
        rotationAndPerspectiveTransform.m34 = 1.0 / -1000;
        rotationAndPerspectiveTransform = CATransform3DMakeTranslation(self.view.frame.size.width, 0, 0);
        [Animation setFromValue:[NSValue valueWithCATransform3D:CATransform3DMakeTranslation(self.view.bounds.size.width, 0, 0)]];
        [Animation setToValue:[NSValue valueWithCATransform3D:CATransform3DMakeTranslation(0, 0, 0)]];
        [Animation setDuration:0.3];
        Animation.delegate = self;
        Animation.removedOnCompletion = NO;
        Animation.fillMode = kCAFillModeBoth;
        [toView.layer addAnimation:Animation forKey:@"fromRight"];
        CABasicAnimation *Animation1  = [CABasicAnimation animationWithKeyPath:@"transform"];
        CATransform3D rotationAndPerspectiveTransform1 = CATransform3DIdentity;
        rotationAndPerspectiveTransform1.m34 = 1.0 / -1000;
        rotationAndPerspectiveTransform1 = CATransform3DMakeScale(1.0, 1.0, 1.0);
        [Animation1 setToValue:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.95, 0.95, 0.95)]];
        [Animation1 setDuration:0.3];
        Animation1.delegate = self;
        Animation1.removedOnCompletion = NO;
        Animation1.fillMode = kCAFillModeBoth;
        [animationLayer addAnimation:Animation1 forKey:@"scale"];
    }
    [super pushViewController:viewController animated:NO];
}
-(UIViewController*)popViewControllerAnimated:(BOOL)animated
{
    if (self.viewControllers.count<2) return [super popViewControllerAnimated:YES];
    
    [animationLayer removeFromSuperlayer];
    [self.view.layer insertSublayer:animationLayer above:self.view.layer];
    
    //还有2级的时候 判断是否 显示 tabbar
    if (self.viewControllers.count <= 2) {
        MainTabBarViewController * tab=(MainTabBarViewController *)self.tabBarController;
        [tab showTabbar:YES];
//        self.tabBarController.tabBar.hidden = NO;
    }
    
    if(animated)
    {
        [self loadLayerWithImage];
        
        [self viewAppearFromLeft];
        
        UIView * toView = [[self.viewControllers objectAtIndex:[self.viewControllers indexOfObject:self.visibleViewController]-1] view];
        
        
        CABasicAnimation *Animation  = [CABasicAnimation animationWithKeyPath:@"transform"];
        CATransform3D rotationAndPerspectiveTransform = CATransform3DIdentity;
        rotationAndPerspectiveTransform.m34 = 1.0 / -1000;
        rotationAndPerspectiveTransform = CATransform3DMakeTranslation(self.view.frame.size.width, 0, 0);
        [Animation setFromValue:[NSValue valueWithCATransform3D:CATransform3DIdentity]];
        [Animation setToValue:[NSValue valueWithCATransform3D:CATransform3DMakeTranslation(self.view.bounds.size.width, 0, 0)]];
        [Animation setDuration:0.3];
        Animation.delegate = self;
        Animation.removedOnCompletion = NO;
        Animation.fillMode = kCAFillModeBoth;
        [animationLayer addAnimation:Animation forKey:@"scale"];
        
        
        CABasicAnimation *Animation1  = [CABasicAnimation animationWithKeyPath:@"transform"];
        CATransform3D rotationAndPerspectiveTransform1 = CATransform3DIdentity;
        rotationAndPerspectiveTransform1.m34 = 1.0 / -1000;
        rotationAndPerspectiveTransform1 = CATransform3DMakeScale(1.0, 1.0, 1.0);
        [Animation1 setFromValue:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9, 0.9, 0.9)]];
        [Animation1 setToValue:[NSValue valueWithCATransform3D:CATransform3DIdentity]];
        [Animation1 setDuration:0.3];
        Animation1.delegate = self;
        Animation1.removedOnCompletion = NO;
        Animation1.fillMode = kCAFillModeBoth;
        [toView.layer addAnimation:Animation1 forKey:@"scale"];
        
    }
    return [super popViewControllerAnimated:NO];
}
-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [animationLayer setContents:nil];
    [animationLayer removeAllAnimations];
    [self.visibleViewController.view.layer removeAllAnimations];
    
    
}
- (void) viewAppearFromLeft
{
    [self.navigationItem.leftBarButtonItem.customView setTransform:CGAffineTransformMakeTranslation(-60, 0)];
    [UIView beginAnimations:@"viewAppearFromLeft" context:nil];
    [UIView setAnimationDuration:0.3];
    [self.navigationItem.leftBarButtonItem.customView setAlpha:1.0];
    [self.navigationItem.leftBarButtonItem.customView setTransform:CGAffineTransformMakeTranslation(0, 0)];
    [UIView commitAnimations];
}
- (void) viewAppearFromRight
{
    [self.navigationItem.leftBarButtonItem.customView setTransform:CGAffineTransformMakeTranslation(60, 0)];
    [UIView beginAnimations:@"viewAppearFromRight" context:nil];
    [UIView setAnimationDuration:0.3];
    [self.navigationItem.leftBarButtonItem.customView setAlpha:1.0];
    [self.navigationItem.leftBarButtonItem.customView setTransform:CGAffineTransformMakeTranslation(0, 0)];
    [UIView commitAnimations];
}
- (void) viewDisappearFromLeft
{
    [UIView beginAnimations:@"viewDisappearFromLeft" context:nil];
    [self.navigationItem.leftBarButtonItem.customView setTransform:CGAffineTransformMakeTranslation(60, 0)];
    [UIView setAnimationDuration:0.3];
    [self.navigationItem.leftBarButtonItem.customView setAlpha:0];
    [UIView commitAnimations];
}
- (void) viewDisappearFromRight
{
    [UIView beginAnimations:@"viewDisappearFromRight" context:nil];
    [self.navigationItem.leftBarButtonItem.customView setTransform:CGAffineTransformMakeTranslation(-60, 0)];
    [UIView setAnimationDuration:0.3];
    [self.navigationItem.leftBarButtonItem.customView setAlpha:0];
    [UIView commitAnimations];
}

//- (UIViewController *)popViewControllerAnimated:(BOOL)animated
//{
//    if (animated) {
//        UIViewController *popController = [self.viewControllers lastObject];
//        UIViewController *pushController = [self.viewControllers objectAtIndex:self.viewControllers.count - 2];
//        [popController viewDisappearFromLeft];
//        [pushController viewAppearFromLeft];
//    }
//    return [super popViewControllerAnimated:animated];
//}
//- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
//{
//    if (animated) {
//        UIViewController *popController = [self.viewControllers lastObject];
//        UIViewController *pushController = viewController;
//        [popController viewDisappearFromRight];
//        [pushController viewAppearFromRight];
//    }
//    [super pushViewController:viewController animated:animated];
//}
@end