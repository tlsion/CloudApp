//
//  CATransferListViewController.m
//  CloudApp
//
//  Created by Pro on 7/25/14.
//  Copyright (c) 2014 王庭协. All rights reserved.
//

#import "CATransferListViewController.h"
#import "CATransferCell.h"
#import "ViewUtils.h"
#import "CATransferHelper.h"
#import "CAShowFileViewController.h"
#import "CABaseNavigationController.h"

#import <MediaPlayer/MediaPlayer.h>
#import "TGRImageViewController.h"
#import "TGRImageZoomAnimationController.h"
typedef NS_ENUM(NSInteger, CATransferListCode) {
    CATransferListCodeUploading,
    CATransferListCodeUploaded,
    CATransferListCodeDownloading,
    CATransferListCodeDownloaded
};
@interface CATransferListViewController ()<UITableViewDataSource,UITableViewDelegate,UIViewControllerTransitioningDelegate,UIDocumentInteractionControllerDelegate>
{
    //#define Plist_Name_AllFolders @"AllFolders.plist"
    //#define Plist_Name_Uploading @"UploadingFiles.plist"
    //#define Plist_Name_Uploaded @"UploadedFiles.plist"
    //#define Plist_Name_Downloading @"DownloadingFiles.plist"
    //#define Plist_Name_Downloaded @"DownloadedFiles.plist"
    IBOutlet UIScrollView *mainScrollView;
    IBOutlet UITableView *downloadTableView;
    
    IBOutlet UITableView *uploadTabelView;
    IBOutlet UIButton *downloadButton;
    
    IBOutlet UIButton *uploadButton;
    
    NSMutableArray * uploadingFiles;
    NSMutableArray * uploadedFiles;
    NSMutableArray * downloadingFiles;
    NSMutableArray * downloadedFiles;
    
    //    UITableView * selectTabelView;
    //    NSIndexPath * selectIndexPath;
}
@end

@implementation CATransferListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewDidAppear:(BOOL)animated{
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //    [self.navigationController setTitle:@"赛凡云"];
    UIImageView  * logoImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"左上角LOGO.png"]];
    UIBarButtonItem * logoLeftItem=[[UIBarButtonItem alloc]initWithCustomView:logoImageView];
    [self.navigationItem setLeftBarButtonItem:logoLeftItem];
    //    mainScrollView.frame=CGRectMake(0, 109, SCREEN_MAX_WIDTH, SCREEN_MAX_HEIGHT-109-20);
    [[NSNotificationCenter defaultCenter ] addObserver:self selector:@selector(transferChange:) name:NSNOTIFICATION_NAME_TRANSFER_CHANGE object:nil];
    
    [self updateAllTransferFile];
    
}
-(void)viewDidLayoutSubviews{
    
    mainScrollView.contentSize=CGSizeMake(mainScrollView.width*2, CGRectGetHeight(mainScrollView.frame));
}
- (IBAction)topOperaterAction:(UIButton *)sender {
    for (UIButton * btn in sender.superview.subviews) {
        btn.selected=NO;
    }
    sender.selected=YES;
    if (sender.tag==10) {
        [mainScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
    else {
        [mainScrollView setContentOffset:CGPointMake(SCREEN_MAX_WIDTH, 0) animated:YES];
    }
}
-(void)transferChange:(NSNotification *)notification{
    //    NSDictionary * infoDict=[notification de]
    NSInteger status=[[notification.userInfo objectForKey:@"status"] integerValue];
    if (status==CATransferTypeStartDownload) {
        downloadingFiles=[[CATransferHelper sharedInstance] downloadingFiles];
        [downloadTableView reloadData];
    }
    else if(status==CATransferTypeStartUpload){
        uploadingFiles=[[CATransferHelper sharedInstance] uploadingFiles];
        [uploadTabelView reloadData];
    }
    else if(status==CATransferTypeDidDownloaded){
        downloadedFiles=[CADataHelper getPlistItemsOfName:Plist_Name_Downloaded];
        [downloadTableView reloadData];
    }
    else if(status==CATransferTypeDidUploaded){
        uploadedFiles=[CADataHelper getPlistItemsOfName:Plist_Name_Uploaded];
        [uploadTabelView reloadData];
    }
}
-(void)updateAllTransferFile{
    [self getAllUploadFiles];
    [self getAllDownloadFiles];
    [downloadTableView reloadData];
    [uploadTabelView reloadData];
}
-(void)getAllUploadFiles{
    uploadingFiles=[[CATransferHelper sharedInstance] uploadingFiles];
    uploadedFiles=[CADataHelper getPlistItemsOfName:Plist_Name_Uploaded];
}
-(void)getAllDownloadFiles{
    downloadingFiles=[[CATransferHelper sharedInstance] downloadingFiles];//[CADataHelper getPlistItemsOfName:Plist_Name_Downloading];
    downloadedFiles=[CADataHelper getPlistItemsOfName:Plist_Name_Downloaded];
}
#pragma mark --- tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView==downloadTableView){
        if (section==0) {
            return downloadingFiles.count;
        }
        else{
            return downloadedFiles.count;
        }
    }
    else{
        if (section==0) {
            return uploadingFiles.count;
        }
        else{
            return uploadedFiles.count;
        }
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}
-(CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * headBgView=[[UIView alloc]init];
    headBgView.backgroundColor=RGB(229, 234, 237);
    UILabel * headerLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 280, 25)];
    headerLabel.font=FONT_MID;
    headerLabel.textColor=RGB(180, 184, 192);
    headerLabel.backgroundColor=CLEAR;
    
    if (tableView==downloadTableView){
        if (section==0) {
            headerLabel.text=[NSString stringWithFormat:@"    正在下载(%ld)",downloadingFiles.count];
        }
        else{
            headerLabel.text=[NSString stringWithFormat:@"    下载成功(%ld)",downloadedFiles.count];
        }
    }
    else{
        if (section==0) {
            headerLabel.text=[NSString stringWithFormat:@"    正在上传(%ld)",uploadingFiles.count];
        }
        else{
            headerLabel.text=[NSString stringWithFormat:@"    上传成功(%ld)",uploadedFiles.count];
        }
    }
    
    UIView * lineView=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(headerLabel.frame)-1, 320, 1)];
    lineView.backgroundColor=RGB(200, 200, 200);
    
    [headBgView addSubview:lineView];
    [headBgView addSubview:headerLabel];
    return headBgView;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"CAFolderCell";
    CATransferCell *cell = (CATransferCell *)[tableView  dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [ViewUtils loadViewFromNib:@"CATransferCell"];
    }
    OCFileDto * item=nil;
    CATransferListCode code;
    if (tableView==downloadTableView){
        if (indexPath.section==0) {
            item=downloadingFiles[indexPath.row];
            code=CATransferListCodeDownloading;
        }
        else{
            item=downloadedFiles[indexPath.row];
            code=CATransferListCodeDownloaded;
        }
    }
    else{
        if (indexPath.section==0) {
            item=uploadingFiles[indexPath.row];
            code=CATransferListCodeUploading;
        }
        else{
            item=uploadedFiles[indexPath.row];
            code=CATransferListCodeUploaded;
        }
    }
    cell.tag=code;
    //    cell.operaterButton.tag=indexPath.row;
    [cell setItemDto:item];
    //    [cell.operaterButton addTarget:self action:@selector(playAndPauseAction:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    OCFileDto * item=nil;
    if (tableView==downloadTableView){
        if (indexPath.section==0) {
            item=downloadingFiles[indexPath.row];
        }
        else{
            item=downloadedFiles[indexPath.row];
        }
    }
    else{
        if (indexPath.section==0) {
            item=uploadingFiles[indexPath.row];
        }
        else{
            item=uploadedFiles[indexPath.row];
        }
    }
    
    [self openFileWithFileDto:item];
//    CAShowFileViewController * controller=[[CAShowFileViewController alloc]init];
//    controller.itemDto=item;
//    CABaseNavigationController * nController=[[CABaseNavigationController alloc]initWithRootViewController:controller];
//    [self presentViewController:nController animated:YES completion:nil];
    //    [self.navigationController pushViewController:controller animated:YES];
}
//删除
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle==UITableViewCellEditingStyleDelete)//删除
    {
        OCFileDto * item=nil;
        NSString * plistName=nil;
        NSMutableArray * operateArr=nil;
        if (tableView==downloadTableView){
            if (indexPath.section==0) {
                item=downloadingFiles[indexPath.row];
                if (item.isDelete==NO) {
                    item.isDelete=YES;
                    return;
                }
                else {
                    operateArr=downloadingFiles;
                    plistName=Plist_Name_Downloading;
                }
            }
            else{
                item=downloadedFiles[indexPath.row];
                operateArr=downloadedFiles;
                plistName=Plist_Name_Downloaded;
            }
        }
        else{
            if (indexPath.section==0) {
                item=uploadingFiles[indexPath.row];
                if (item.isDelete==NO) {
                    item.isDelete=YES;
                    return;
                }
                else {
                    operateArr=uploadingFiles;
                    plistName=Plist_Name_Uploading;
                }
            }
            else{
                item=uploadedFiles[indexPath.row];
                operateArr=uploadedFiles;
                plistName=Plist_Name_Uploaded;
            }
        }
        if (operateArr.count>indexPath.row) {
            [operateArr removeObjectAtIndex:[indexPath row]];
        }
        //        item.isDelete=YES;
        //        if ([[CATransferHelper sharedInstance].downloadingFiles containsObject:item]) {
        //            NSLog(@"fileName:%@",item.fileName);
        //        }
        [CADataHelper deletePlaceFileDto:item andPlistName:plistName];
        
        
        //        删除单元格的某一行时，在用动画效果实现删除过程
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        
        //        if (tableView==uploadTabelView) {
        //            [self getAllUploadFiles];
        //        }
        //        else{
        //            [self getAllDownloadFiles];
        //        }
    }
    
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}
-(void)playAndPauseAction:(UIButton *)sender{
    CATransferCell *cell=(CATransferCell *)sender.superview.superview.superview;
    
    CATransferListCode code=cell.tag;
    NSInteger row=sender.tag;
    
    if (sender.selected==NO) {
        OCFileDto * item=nil;
        switch (code) {
            case CATransferListCodeDownloading:{
                item=downloadingFiles[row];
                
                [self downloadFile:item];
            }
                break;
                
            case CATransferListCodeUploading:{
                item=downloadingFiles[row];
                
                NSData* fileData = [NSData dataWithContentsOfFile:[CADataHelper filePath:item.fileTitle]];
                [self uploadFile:item andData:fileData];
            }
                break;
                
            default:
                break;
        }
    }
    else{
        
    }
    
    
}
-(void)downloadFile:(OCFileDto *)item {
    NSString * fileName=item.fileTitle;
    NSString * filePath=item.filePath;
    filePath = [filePath stringByReplacingOccurrencesOfString:RemoteWebdav withString:@""];
    filePath =[filePath stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"/%@",item.fileName] withString:@""];
    NSLog(@"path:%@,file:%@",filePath,fileName);
    NSString * path=[NSString stringWithFormat:@"%@%@",filePath,fileName];
    
    //    __weak CATransferListViewController * controller=self;
    
    [CADataHelper downloadFile:path downloadFileName:fileName willStart:^{
        //        [controller.view makeToast:@"已加入下载列表"];
    }progressDownload:^(NSUInteger bytesRead, long long totalBytesRead, long long totalExpectedBytesRead) {
        
        NSLog(@"下载：%ld",bytesRead);
    } successRequest:^(NSString *downPath) {
        //        [controller.view makeToast:@"下载成功"];
    } failureRequest:^(NSError *error) {
        //        [controller.view makeToast:@"下载失败"];
    }];
    
}
-(void)uploadFile:(OCFileDto *)item andData:(NSData *)fileData {
    NSString * fileName=item.fileTitle;
    NSString * filePath=item.filePath;
    filePath = [filePath stringByReplacingOccurrencesOfString:RemoteWebdav withString:@""];
    filePath =[filePath stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"/%@",item.fileName] withString:@""];
    NSLog(@"path:%@,file:%@",filePath,fileName);
    NSString * path=[NSString stringWithFormat:@"%@%@",filePath,fileName];
    
    //    __weak CAMyFolderViewController * controller=self;
    [CADataHelper uploadFile:path uploadFileName:fileName fileData:fileData willStart:^{
    }progressUpload:^(NSUInteger bytesWrite, long long totalBytesWrite, long long totalExpectedBytesWrite) {
        NSLog(@"上传：%ld",bytesWrite);
    }successRequest:^{
        //        [controller.view makeToast:@"上传成功"];
    } failureRequest:^(NSError * error) {
        //        [controller.view makeToast:@"上传失败"];
    } failureBeforeRequest:^(NSError *error) {
    }];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    SLLogPoint(scrollView.contentOffset);
    if (scrollView==mainScrollView) {
        if (scrollView.contentOffset.x>=SCREEN_MAX_WIDTH) {
            uploadButton.selected=YES;
            downloadButton.selected=NO;
        }else {
            downloadButton.selected=YES;
            uploadButton.selected=NO;
        }
    }
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark -- OpenFile
-(void)openFileWithFileDto:(OCFileDto *)fileDto{
    if (fileDto.fileType==CAFileTypeCodeImage) {
        [self showImage:fileDto];
    }
    else if(fileDto.fileType==CAFileTypeCodeAudio || fileDto.fileType==CAFileTypeCodeVideo){
        [self playVideo:fileDto];
    }
    else if(fileDto.fileType==CAFileTypeCodeTxt || fileDto.fileType==CAFileTypeCodeCompress || fileDto.fileType==CAFileTypeCodeOther){
        [self openDocument:fileDto];
    }
}
- (void)showImage:(OCFileDto *)fileDto{
    TGRImageViewController *viewController = [[TGRImageViewController alloc] initWithImageDto:fileDto];
    viewController.transitioningDelegate = self;
    
    [self presentViewController:viewController animated:YES completion:nil];
}
-(void)playVideo:(OCFileDto *)fileDto{
    NSURL * videoURL=nil;
    //[NSURL URLWithString:@"http://static.tripbe.com/videofiles/20121214/9533522808.f4v.mp4"]
    if ([CADataHelper placeHasSave:fileDto]) {
        NSString * fileImagePath=[CADataHelper filePath:fileDto.fileTitle];
        videoURL=[NSURL fileURLWithPath:fileImagePath];
    }
    else{
        videoURL=[NSURL URLWithString:[CADataHelper urlWithOCFileDto:fileDto]];
    }
    MPMoviePlayerViewController *playerViewController =[[MPMoviePlayerViewController alloc]initWithContentURL:videoURL];
    [self presentMoviePlayerViewControllerAnimated:playerViewController];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoFinished) name:MPMoviePlayerPlaybackStateDidChangeNotification object:nil];
    
    
}
-(void)videoFinished{
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = UIInterfaceOrientationPortrait;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}

-(void)openDocument:(OCFileDto *)fileDto{
    //    NSURL *URL = [[NSBundle mainBundle] URLForResource:@"Example" withExtension:@"odt"];
    if ([CADataHelper placeHasSave:fileDto]) {
        [self openDocumentWithFileDto:fileDto];
    }
}
-(void) openDocumentWithFileDto:(OCFileDto *)fileDto{
    NSString * fileImagePath=[CADataHelper filePath:fileDto.fileTitle];
    NSURL * URL=[NSURL fileURLWithPath:fileImagePath];
    if (URL) {
        // Initialize Document Interaction Controller
        UIDocumentInteractionController * documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:URL];
        
        // Configure Document Interaction Controller
        [documentInteractionController setDelegate:self];
        
        // Preview PDF
        if (![documentInteractionController presentPreviewAnimated:YES]) {
            
            CAShowFileViewController * controller=[[CAShowFileViewController alloc]init];
            controller.itemDto=fileDto;
            controller.title=fileDto.fileName;
            CABaseNavigationController * nController=[[CABaseNavigationController alloc]initWithRootViewController:controller];
            [self presentViewController:nController animated:YES completion:nil];
            
            
        }
    }
}
#pragma mark Document Interaction Controller Delegate Methods
- (UIViewController *) documentInteractionControllerViewControllerForPreview: (UIDocumentInteractionController *) controller {
    return self;
}

@end
