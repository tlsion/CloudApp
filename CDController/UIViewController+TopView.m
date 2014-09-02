//
//  UIViewController+TopView.m
//  Diancan
//
//  Created by chenzhihui on 13-9-29.
//  Copyright (c) 2013年 青岛晨之辉信息服务有限公司. All rights reserved.
//

#import "UIViewController+TopView.h"

@implementation UIViewController (TopView)
LeftButtonBlcok leftButtonBlock;
RightButtonBlcok rightButtonBlock;
UIButton *rightButton;
UIImageView *imgeBG;
-(void)loadNavBar{
    imgeBG=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    imgeBG.image=[UIImage imageNamed:@"juchi"];
    imgeBG.userInteractionEnabled=YES;
    imgeBG.contentMode=UIViewContentModeScaleToFill;
    [self.view addSubview:imgeBG];
}
-(void)loadLeftButton:(NSString *)imageNameNor andSelected:(NSString *)imageSe{
    //nav左边按钮

    UIButton *loginButton=[[UIButton alloc]initWithFrame:CGRectMake(10, 0, 40, 40)];
    [loginButton setImage:[UIImage imageNamed:imageNameNor] forState:UIControlStateNormal];
    [loginButton setImage:[UIImage imageNamed:imageSe] forState:UIControlStateHighlighted];
    [loginButton addTarget:self action:@selector(leftButtonTaped:) forControlEvents:UIControlEventTouchUpInside];
    [imgeBG addSubview:loginButton];
   
}

-(void)loadRightButton:(NSString *)imageNameNor andSelected:(NSString *)imageSe{
    //nav右边按钮
    UIButton *setButton=[[UIButton alloc]initWithFrame:CGRectMake(270, 0, 40, 40)];
    [setButton setImage:[UIImage imageNamed:imageNameNor] forState:UIControlStateNormal];
    [setButton setImage:[UIImage imageNamed:imageSe] forState:UIControlStateHighlighted];
    [setButton addTarget:self action:@selector(rightButtonTaped:) forControlEvents:UIControlEventTouchUpInside];
    [imgeBG addSubview:setButton];
}
-(void)setLeftButtonAction:(LeftButtonBlcok)block{
    leftButtonBlock=block;

}
-(void)setRightButtonAction:(RightButtonBlcok)block{
    rightButtonBlock=block;
}
-(void)leftButtonTaped:(UIButton *)button{
    if (leftButtonBlock) {
        leftButtonBlock();
    }

}
-(void)rightButtonTaped:(UIButton *)button{
    if (rightButtonBlock) {
        rightButtonBlock();
    }
}
-(void)loadMiddleView:(NSString *)title{
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(120, 2, 100, 40)];
    label.backgroundColor=[UIColor clearColor];
    label.textAlignment=NSTextAlignmentCenter;
    label.text=title;
    label.textColor=[UIColor blackColor];
    label.font=[UIFont systemFontOfSize:18];
    [imgeBG addSubview:label];
}
@end
