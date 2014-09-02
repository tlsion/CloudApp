//
//  SeeAllPhotoViewController.m
//  shangliang
//
//  Created by 智美合 on 14-2-25.
//  Copyright (c) 2014年 huangbaozhi. All rights reserved.
//

#import "SeeAllPhotoViewController.h"
#import "ImageShowViewController.h"
#import "EGOImageButton.h"
@interface SeeAllPhotoViewController ()

@end

@implementation SeeAllPhotoViewController

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
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=7)
    {
        self.view.bounds = CGRectMake(0, -20, SCREEN_WIDTH, SCREEN_HEIGHT);
    }

    self.view.backgroundColor = [UIColor whiteColor];
    //标题栏
    NavBar *nav = [[NavBar alloc] initWithFrame:CGRectMake(0, 0, WIDTH, NAV_HEIGHT)];
    [self.view addSubview:nav];
    
//    //返回按钮
//    BackButton *buttonback = [[BackButton alloc] initWithFrame:CGRectMake(BACK_BUTTON_X,
//                                                                          BACK_BUTTON_Y, BACK_BUTTON_WIDTH, BACK_BUTTON_HEIGHT)];
//    [buttonback.buttonback addTarget:self
//                              action:@selector(BackClick)
//                    forControlEvents:UIControlEventTouchDown];
//    [nav addSubview:buttonback];
    
    //展示全部按钮
    UIButton *buttonDone = [[UIButton alloc] initWithFrame:CGRectMake(270,
                                                                        7, 50, 30)];
    [buttonDone setTitle:@"done" forState:UIControlStateNormal];
    [buttonDone addTarget:self
                     action:@selector(DoneClick)
           forControlEvents:UIControlEventTouchDown];
    [nav addSubview:buttonDone];
    
    
    
    int lineCount=_imageArr.count/4+1;
    for (int i = 0; i < lineCount; i ++ ) {
        
        for (int j = 0; j < 4; j ++) {
            
            if ((4*i+j)<_imageArr.count) {
                
//                UIImage *img=[[UIImage alloc]init];
                EGOImageButton *imageBtn = [EGOImageButton buttonWithType:UIButtonTypeCustom];
                [imageBtn addTarget:self action:@selector(ImageBtnClick:) forControlEvents:UIControlEventTouchDown];
                imageBtn.frame = CGRectMake(8 , 5 , 70, 100);
                imageBtn.tag=i*4+j;
                if ([_imageArr[i*4+j] hasPrefix:@"http"]) {
//                    NSData *imgData=[NSData dataWithContentsOfURL:[NSURL URLWithString:_imageArr[i*4+j]]];
//                    img=[UIImage imageWithData:imgData];
                    imageBtn.imageURL=_imageArr[i*4+j];
//                    [imageBtn setBackgroundImage:img forState:UIControlStateNormal];
                }
                else
                {
                    [imageBtn setBackgroundImage:_imageArr[i*4+j] forState:UIControlStateNormal];
//                    img=[UIImage imageWithContentsOfFile:_imageArr[i*4+j]];
                }
                
                UIImageView *imgV=[[UIImageView alloc]init];
                imgV.frame=CGRectMake(78*j, 44+105*i, 78, 105);
                imgV.userInteractionEnabled = YES;
                [self.view addSubview:imgV];
                
//                UIButton *imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//                [imageBtn addTarget:self action:@selector(ImageBtnClick:) forControlEvents:UIControlEventTouchDown];
//                imageBtn.frame = CGRectMake(8 , 5 , 70, 100);
//                imageBtn.tag=i*4+j;
//                [imageBtn setBackgroundImage:img forState:UIControlStateNormal];
//                [imgV addSubview:imageBtn];
            }
        }
    }
}

//-(void)BackClick
//{
//    [self.navigationController popViewControllerAnimated:YES];
////    for (UIViewController *controller in [self.navigationController viewControllers]) {
////        if ([controller isKindOfClass:NSClassFromString(@"TalkingViewController")]          ||[controller isKindOfClass:NSClassFromString(@"CallingCardViewController")]) {
////            [self.navigationController popToViewController:controller animated:YES];
////            break;
////        }
////    }
//}

-(void)DoneClick
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)ImageBtnClick:(UIButton *)sender
{
    if (_delegate) {
        [_delegate passValue:sender.tag];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
