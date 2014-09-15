//
//  CAShowFileViewController.m
//  CloudApp
//
//  Created by Pro on 8/28/14.
//  Copyright (c) 2014 王庭协. All rights reserved.
//

#import "CAShowFileViewController.h"
#import "EGOImageLoader.h"
@interface CAShowFileViewController ()<EGOImageLoaderObserver>
{
    IBOutlet UIView *noSupportBgView;
    
    IBOutlet UIImageView *noSupportFileImageView;
    IBOutlet UILabel *noSupportFileNameLabel;
    IBOutlet UIImageView *showImageView;
}
@end

@implementation CAShowFileViewController

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
    // Do any additional setup after loading the view from its nib.
    UIBarButtonItem * backBarItem=[CrateComponent createBackBarButtonItemWithTarget:self andAction:@selector(backAction)];
    
    [self.navigationItem setLeftBarButtonItem:backBarItem];
    
    
    if (_itemDto.fileType==CAFileTypeCodeImage) {
        noSupportBgView.hidden=YES;
        showImageView.hidden=NO;
        self.title=_itemDto.fileTitle;
        
        
        NSData* fileData = [NSData dataWithContentsOfFile:[CADataHelper filePath:_itemDto.fileTitle]];
        if (fileData) {
            showImageView.image=[UIImage imageWithData:fileData];
        }
        else{
            NSURL * imageURL=[NSURL URLWithString:[CADataHelper urlWithOCFileDto:_itemDto]];
            UIImage * showImage=[[EGOImageLoader sharedImageLoader] imageForURL:imageURL shouldLoadWithObserver:self];
            if (showImage) {
                showImageView.image=showImage;
            }
            else{
                [self.view makeToastActivity];
            }
        }
    }
    else{
        noSupportBgView.hidden=NO;
        showImageView.hidden=YES;
        noSupportFileNameLabel.text=_itemDto.fileTitle;
        switch (_itemDto.fileType) {
            case CAFileTypeCodeFolder:
                noSupportFileImageView.image=[UIImage imageNamed:@"文件-文件夹_2_4.png"];
                break;
            case CAFileTypeCodeCompress:
                noSupportFileImageView.image=[UIImage imageNamed:@"文件-压缩_2_4.png"];
                break;
            case CAFileTypeCodeTxt:
                noSupportFileImageView.image=[UIImage imageNamed:@"文件-文档_2_4.png"];
                break;
            case CAFileTypeCodeAudio:
                noSupportFileImageView.image=[UIImage imageNamed:@"文件-音乐_2_4.png"];
                break;
            case CAFileTypeCodeVideo:
                noSupportFileImageView.image=[UIImage imageNamed:@"文件-视频_2_4.png"];
                break;
            case CAFileTypeCodeOther:
                noSupportFileImageView.image=[UIImage imageNamed:@"文件-其他_2_4.png"];
                break;
            default:
                break;
        }
    }
}
-(void)backAction{
    [self dismissViewControllerAnimated:YES completion:nil];
//    [self.navigationController popViewControllerAnimated:YES];
}
- (void)imageLoaderDidLoad:(NSNotification*)notification{
    [self.view hideToastActivity];
    showImageView.image=[[notification userInfo] objectForKey:@"image"];
}
- (void)imageLoaderDidFailToLoad:(NSNotification*)notification{
    [self.view hideToastActivity];
    [self.view makeToast:@"下载失败"];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
