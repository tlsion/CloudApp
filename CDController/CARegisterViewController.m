//
//  CARegisterViewController.m
//  CloudApp
//
//  Created by Pro on 7/31/14.
//  Copyright (c) 2014 王庭协. All rights reserved.
//

#import "CARegisterViewController.h"
#import "TitleTextField.h"
@interface CARegisterViewController ()
{
    IBOutlet TitleTextField *acountTxt;
    
    IBOutlet TitleTextField *passwordTxt1;
    IBOutlet TitleTextField *passwordTxt2;
}
@end

@implementation CARegisterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)customNavigationBar{
//    self.navigationItem.hidesBackButton=YES;
    UIBarButtonItem * backBarItem=[CrateComponent createBackBarButtonItemWithTarget:self andAction:@selector(backAction)];
    [self.navigationItem setLeftBarButtonItem:backBarItem];
}
-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self customNavigationBar];
    [acountTxt setTxtTitle:@"账   号"];
    [passwordTxt1 setTxtTitle:@"密   码"];
    [passwordTxt2 setTxtTitle:@"再次输入密码"];
}
- (IBAction)registerAction:(id)sender {
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
