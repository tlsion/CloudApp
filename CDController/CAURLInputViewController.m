//
//  CAIPInputViewController.m
//  CloudApp
//
//  Created by Pro on 7/31/14.
//  Copyright (c) 2014 王庭协. All rights reserved.
//

#import "CAURLInputViewController.h"
#import "TitleTextField.h"
@interface CAURLInputViewController ()
{
    IBOutlet TitleTextField *serviceURLTxt;
    
}
@end

@implementation CAURLInputViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)customNavigationBar{
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
    [serviceURLTxt setTxtTitle:@"URL"];
}
- (IBAction)comfirmAction:(id)sender {
    if (serviceURLTxt.text.length>0) {
//        NSUserDefaults * userDefaults=[NSUserDefaults standardUserDefaults];
//        [userDefaults setObject:serviceURLTxt.text forKey:User_ServiceUrl];
//        
//        [cloudHelper.userDefaults synchronize];
//        [self dismissViewControllerAnimated:YES completion:^(){
//            [cloudHelper login];
//            [cloudHelper updateFolders];
//        }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
