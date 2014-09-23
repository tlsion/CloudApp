//
//  CALoginViewController.m
//  CloudApp
//
//  Created by Pro on 7/31/14.
//  Copyright (c) 2014 王庭协. All rights reserved.
//

#import "CALoginViewController.h"
#import "TitleTextField.h"
#import "CARegisterViewController.h"
//#import "CAURLInputViewController.h"
@interface CALoginViewController ()<UITextFieldDelegate>
{
    
    IBOutlet TitleTextField *acountTxt;
    IBOutlet TitleTextField *passwordTxt;
    IBOutlet TitleTextField *serviceURLTxt;
}
@end

@implementation CALoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
-(void)viewWillAppear:(BOOL)animated{
}
-(void)viewWillDisappear:(BOOL)animated{
}

- (void)viewDidLoad
{
    self.title=@"登录";
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self customNavigationBar];
    [acountTxt setTxtTitle:@"账   号"];
    [passwordTxt setTxtTitle:@"密   码"];
    [serviceURLTxt setTxtTitle:@"服务器地址"];
    if (self.navigationController.viewControllers.count < 2) {
        NSLog(@"aaa");
    }
    
    NSUserDefaults * userDefaults=[NSUserDefaults standardUserDefaults];
    if ([userDefaults objectForKey:User_UserName]) {
        acountTxt.text=[userDefaults objectForKey:User_UserName];
    }
    if ([userDefaults objectForKey:User_UserPassword]) {
        passwordTxt.text=[userDefaults objectForKey:User_UserPassword];
    }
    if ([userDefaults objectForKey:User_AllServiceUrl]) {
        serviceURLTxt.text=[userDefaults objectForKey:User_AllServiceUrl];
    }
}
-(void)registerAction{
    CARegisterViewController * regVC=[[CARegisterViewController alloc]init];
    regVC.title=@"注册赛凡账号";
    [self.navigationController pushViewController:regVC animated:YES];
}
- (IBAction)loginAction:(id)sender {
    if (acountTxt.text.length * passwordTxt.text.length * serviceURLTxt.text.length!=0) {
        
        __weak NSUserDefaults * userDefaults=[NSUserDefaults standardUserDefaults];
        [userDefaults setObject:acountTxt.text forKey:User_UserName];
        [userDefaults setObject:passwordTxt.text forKey:User_UserPassword];
        [userDefaults setObject:serviceURLTxt.text forKey:User_AllServiceUrl];
        
        NSString * serviceUrl=serviceURLTxt.text;
        if ([serviceUrl hasSuffix:@"/"]) {
            serviceUrl=[serviceUrl substringToIndex:serviceUrl.length-1];
        }
        [userDefaults setObject:serviceUrl forKey:User_ServiceUrl];
        [userDefaults setObject:[self getDomain:serviceUrl] forKey:User_Domain];
        
        [userDefaults synchronize];
        
        [[AppDelegate sharedOCCommunication] setCredentialsWithUser:acountTxt.text andPassword:passwordTxt.text];
        
        [CADataHelper updateFolderWithPath:@"" successRequest:^(NSHTTPURLResponse *response, NSArray *items) {
            if (response.statusCode==kOCOKServerSuccess) {
                //登录成功
//                [userDefaults setBool:YES forKey:User_IsLogined];
//                [userDefaults synchronize];
//                
//                //                    [CADataHelper deletePlistItemsOfName:Plist_Name_AllFolders];
//                
//                if (controller) {
//                    [controller getFoldersDataReloadData];
//                }
                
                
//                dispatch_async(kBgQueue, ^{
                
                    [userDefaults setBool:YES forKey:User_IsLogined];
                    [userDefaults synchronize];
                    
//                    [CADataHelper deletePlistItemsOfName:Plist_Name_AllFolders];
                    
                    if (_delegate) {
                        [_delegate getFoldersDataReloadData];
                    }
                    
                    [self backAction];
//                });
                
                
//
            }
            else if (response.statusCode==kOCErrorServerURLNotCorrect){
                ALERT(@"服务器连接错误！");
            }
            else {
                ALERT(@"登录失败！");
            }
        } failureRequest:^(NSHTTPURLResponse *response) {
            if (response.statusCode==kOCErrorServerUserNoFault) {
                ALERT(@"账号密码错误！");
            }
            else {
                ALERT(@"登录失败！");
            }
        }];
//        [self dismissViewControllerAnimated:YES completion:^(){
//            [userDefaults setBool:YES forKey:User_IsLogined];
//            [userDefaults synchronize];
        
//            //清除本地文件夹
//            [CADataHelper deletePlistItemsOfName:Plist_Name_AllFolders];
//            
//            if (_delegate) {
//                [_delegate getFoldersData];
//            }
//        }];
//        CAURLInputViewController * controller=[[CAURLInputViewController alloc]init];
//        [self.navigationController pushViewController:controller animated:YES];
        [self resignAllFirstResponder];
    }
    else{
        ALERT(@"请填写完整");
    }
}
-(NSString *)getDomain:(NSString *)serviceUrl{
    NSString * domain=serviceURLTxt.text;
    domain = [domain stringByReplacingOccurrencesOfString:@"http://" withString:@""];
    NSRange cut=[domain rangeOfString:@"/"];
    if (cut.length>0) {
        domain = [domain substringToIndex:cut.location];
    }
    domain=[domain stringByReplacingOccurrencesOfString:@"/" withString:@":"];
    NSLog(@"Domain:%@",domain);
    return domain;
}
- (IBAction)forgetPasswordAction:(id)sender {
}
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self resignAllFirstResponder];
}
- (IBAction)scrollViewTapAction:(id)sender {
    [self resignAllFirstResponder];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self loginAction:nil];
    return YES;
}
-(void)resignAllFirstResponder{
    [acountTxt resignFirstResponder];
    [passwordTxt resignFirstResponder];
    [serviceURLTxt resignFirstResponder];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
