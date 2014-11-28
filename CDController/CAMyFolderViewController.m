//
//  CAMyFolderViewController.m
//  CloudApp
//
//  Created by Pro on 7/25/14.
//  Copyright (c) 2014 王庭协. All rights reserved.
//

#import "CAMyFolderViewController.h"
//#import "FirstViewController.h"
#import "CAFolerCell.h"
//#import "OCCommunication.h"
#import "OCFileDto.h"
#import "NSDate+Tingxie.h"
#import "TXSize.h"
#import "CAFolderOperateView.h"
#import "Base64.h"
#import "MJRefresh.h"
#import "CALoginViewController.h"
#import "CABaseNavigationController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "CTAssetsPickerController.h"
#import "NSDate+TimeInterval.h"
#import "CAMoveFolderViewController.h"
#import "CAShowFileViewController.h"
#import "OCWebDAVClient.h"
#import "Reachability.h"
#import "TXMD5.h"
#import "ImageShowViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "TGRImageViewController.h"
#import "TGRImageZoomAnimationController.h"
#define AV_RENAME_TAG 100
#define AS_UPLOAD_TAG 200

#define ASSET_PICKER_PHOTO_TAG @"ALAssetTypePhoto"
#define ASSET_PICKER_VIDEO_TAG @"ALAssetTypeVideo"
#define MaximumNumberOfSelection 10

@interface CAMyFolderViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,BottonOperateDelegate,CAFolerCellDelegate,CTAssetsPickerControllerDelegate,UIViewControllerTransitioningDelegate,UIDocumentInteractionControllerDelegate,UITextFieldDelegate>
{
    UIAlertView * addFolderAlertView ;
    NSUserDefaults * userDefaults;
    //    CACloudHelper * cloudHelper;
    BOOL isRequest;
    OCFileDto * selectItemDto;
    
    NSMutableArray * _assets;
    
    NSData * o_uploadData;
    
    
}

@end

@implementation CAMyFolderViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)dealloc  {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSNOTIFICATION_NAME_UPDATE_STATUS object:nil];
}
-(void)customNavigationBar{
    if (_az_isRootPath) {
        UIImageView  * logoImageView=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"左上角LOGO.png"]];
        UIBarButtonItem * leftBarItem=[[UIBarButtonItem alloc]initWithCustomView:logoImageView];
        [self.navigationItem setLeftBarButtonItem:leftBarItem];
    }
    else {
        UIBarButtonItem * backBarItem=[CrateComponent createBackBarButtonItemWithTarget:self andAction:@selector(backAction)];
        [self.navigationItem setLeftBarButtonItem:backBarItem];
    }
    
    UIButton * rightButton1=[UIButton buttonWithType:UIButtonTypeCustom];
    rightButton1.frame=CGRectMake(60, 0, 60, 44);
    [rightButton1 setTitle:@"新建" forState:UIControlStateNormal];
    rightButton1.titleLabel.font=FONTBOLD(13);
    [rightButton1 setContentEdgeInsets:UIEdgeInsetsMake(0, 16, 0, -16)];
    [rightButton1 setTitleEdgeInsets:UIEdgeInsetsMake(0, -55, 0, 0)];
    [rightButton1 setImage:[UIImage imageNamed:@"右上角按钮.png"] forState:UIControlStateNormal];
    [rightButton1 setTitleColor:WHITE forState:UIControlStateNormal];
    [rightButton1 addTarget:self action:@selector(newFolderAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton * rightButton2=[UIButton buttonWithType:UIButtonTypeCustom];
    rightButton2.frame=CGRectMake(0, 0, 60, 44);
    [rightButton2 setTitle:@"上传" forState:UIControlStateNormal];
    rightButton2.titleLabel.font=FONTBOLD(13);
    [rightButton2 setContentEdgeInsets:UIEdgeInsetsMake(0, 16, 0, -16)];
    [rightButton2 setTitleEdgeInsets:UIEdgeInsetsMake(0, -55, 0, 0)];
    [rightButton2 setImage:[UIImage imageNamed:@"右上角按钮.png"] forState:UIControlStateNormal];
    [rightButton2 setTitleColor:WHITE forState:UIControlStateNormal];
    [rightButton2 addTarget:self action:@selector(uploadFileAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIView * rightView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 120, 44)];
    
    UIView * lineView=[[UIView alloc]initWithFrame:CGRectMake(76, 0, 1, 44)];
    
    [rightView addSubview:rightButton1];
    [rightView addSubview:rightButton2];
    
    lineView.backgroundColor=SubBlue;
    [rightView addSubview:lineView];
    UIBarButtonItem * rightBarItem=[[UIBarButtonItem alloc]initWithCustomView:rightView];
    [self.navigationItem setRightBarButtonItem:rightBarItem];
    
    //    UIBarButtonItem * rightBarItem=[CrateComponent createRightBarButtonItemWithTitle:@"上传" andTarget:self andAction:@selector(uploadFileAction)];
    //    [self.navigationItem setRightBarButtonItem:rightBarItem];
}
-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    if (_az_isRootPath) {
        [super viewWillAppear:animated];
    }
    [[CAGlobalData shared].az_mainTab setAz_operateDelegate:self];
}
-(void)viewDidAppear:(BOOL)animated {
    
    [self initItemsData];
}
-(void)viewDidDisappear:(BOOL)animated{
    if (_az_isRootPath) {
        [super viewDidDisappear:animated];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupRefresh];
    
    [self customNavigationBar];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getFoldersDataReloadData) name:NSNOTIFICATION_NAME_UPDATE_STATUS object:nil];
    userDefaults =[NSUserDefaults standardUserDefaults];
    
    if (!_az_folderPath) _az_folderPath=@"";
    
    
    //    [[CAGlobalData shared].az_mainTab setAz_operateDelegate:self];
    
    //    [self Contacts];
}
-(void)initItemsData{
    if (!isRequest) {
        if (_az_isRootPath) {
            if ([userDefaults boolForKey:User_IsLogined]) {
                if ([CADataHelper getItemsOfPath:_az_folderPath].count>0) {
                    _itemsOfPath=[CADataHelper getItemsOfPath:_az_folderPath];
                    [_itemsTableView reloadData];
                }
                [self.itemsTableView headerBeginRefreshing];
            }
            else{
                [self enterLoginController];
            }
        }else{
            _itemsOfPath=[CADataHelper getItemsOfPath:_az_folderPath];
            [_itemsTableView reloadData];
            [self.itemsTableView headerBeginRefreshing];
            
        }
        isRequest=YES;
    }
}
-(void)newFolderAction{
    [[self addFolderAlertView]show];
}
-(void)uploadFileAction{
    //    [[self addFolderAlertView]show];
    //    [self getFoldersData];
    //    FirstViewController * f=[[FirstViewController alloc]init];
    //    [self.navigationController pushViewController:f  animated:YES];
    
    [[self uploadActionSheet] showInView:self.view];
    
}

#pragma mark 集成下拉刷新控件
- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [self.itemsTableView addHeaderWithTarget:self action:@selector(headerRereshing)];
    //#pragma mar warning-- 自动刷新(一进入程序就下拉刷新)
    //    [self.itemsTableView headerBeginRefreshing];
    
}
- (void)headerRereshing
{
    [self getFoldersData];
    //    dataList=[[NSMutableArray alloc]init];
    //    [self getGoodlist];
    //    // 2.2秒后刷新表格UI
    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //        // 刷新表格
    //        [self.itemsTableView reloadData];
    //
    //        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
    //        [self.itemsTableView headerEndRefreshing];
    //    });
}
#pragma mark 云方法
///-----------------------------------
/// @name Set Credentials in OCCommunication
///-----------------------------------

/**
 * Set username and password in the OCComunicacion
 */
//- (void) setCredencialsInOCCommunication {
//
//    //Sett credencials
//    [[AppDelegate sharedOCCommunication] setCredentialsWithUser:baseUser andPassword:basePassword];
//
//}
- (void) getFoldersData {
    [CADataHelper updateFolderWithPath:_az_folderPath successRequest:^(NSHTTPURLResponse * response, NSArray *itemsOfPath) {
        //        NSLog(@"%@",itemsOfPath);
        _itemsOfPath=[CADataHelper getItemsOfPath:_az_folderPath];
        
        [self backToNoSelect];
        
    } failureRequest:^(NSHTTPURLResponse * response) {
        
        [_itemsTableView reloadData];
    }];
    //    [CADataHelper updateFolderWithPath:_az_folderPath successRequest:^(NSHTTP NSArray * itemsOfPath) {
    //        NSLog(@"%@",itemsOfPath);
    //        _itemsOfPath=[CADataHelper getItemsOfPath:_az_folderPath];
    //        [_itemsTableView reloadData];
    //    } failureRequest:^(){
    //        NSLog(@"error");
    //         [_itemsTableView reloadData];
    //    }];
}
- (void) createFolderName:(NSString *)name {
    NSString * path=[NSString stringWithFormat:@"%@%@",_az_folderPath,name];
    [CADataHelper createFolderWithPath:path IsSuccess:^(BOOL isSuccess) {
        if (isSuccess) {
            [self getFoldersData];
        }
    }];
}

-(void)uploadFile:(NSString *)fileName andData:(NSData *)fileData {
    NSString * path=[NSString stringWithFormat:@"%@%@",_az_folderPath,fileName];
    
    __weak AppDelegate * app=APP;
    [CADataHelper uploadFile:path uploadFileName:fileName fileData:fileData willStart:^{
        //        [app.window makeToast:@"添加至上传列表"];
    }progressUpload:^(NSUInteger bytesWrite, long long totalBytesWrite, long long totalExpectedBytesWrite) {
        //        NSLog(@"上传：%ld",bytesWrite);
    }successRequest:^{
        //        [app.window makeToast:@"上传成功"];
        [_itemsTableView headerBeginRefreshing];
        
        
        o_uploadData =nil;
    } failureRequest:^(NSError * error) {
        [app.window makeToast:@"上传失败"];
        o_uploadData =nil;
    } failureBeforeRequest:^(NSError *error) {
        [app.window makeToast:@"上传失败"];
        o_uploadData =nil;
    }];
    
}

-(void)downloadFileDto:(OCFileDto *)fileDto {
//    NSString * path=[NSString stringWithFormat:@"%@%@",_az_folderPath,fileDto.fileName];
    
    
    __weak AppDelegate * app=APP;
   [CADataHelper downloadFileDto:fileDto willStart:^{
        //        [app.window makeToast:@"添加至下载列表"];
    }progressDownload:^(NSUInteger bytesRead, long long totalBytesRead, long long totalExpectedBytesRead) {
        
        //        NSLog(@"下载外：%ld",bytesRead);
    } successRequest:^(NSString *downPath) {
        //        [app.window makeToast:@"下载成功"];
        
        [CADataHelper updatePlaseFileStatusWithStatus:CAPlaceStutusDownload andFileDto:fileDto];
//        [self getFoldersDataReloadData];
    } failureRequest:^(NSError *error) {
        [app.window makeToast:@"下载失败"];
    }];
    
    [self backToNoSelect];
}

-(void)deleteFile:(OCFileDto *)itemDto{
    
    NSString * path=[NSString stringWithFormat:@"%@%@",_az_folderPath,itemDto.fileName];
    
    __weak AppDelegate * app=APP;
    [CADataHelper deleteFileOrFolder:path successRequest:^{
        [app.window makeToast:[NSString stringWithFormat:@"删除成功"]];
        [_itemsTableView headerBeginRefreshing];
    } failureRquest:^(NSError *error) {
        [app.window makeToast:@"删除失败"];
        [_itemsTableView reloadData];
    }];
    
    [self backToNoSelect];
}

-(void)renameItemDto:(OCFileDto *)itemDto andNewName:(NSString *)newName{
    
    NSString * oldPath=[NSString stringWithFormat:@"%@%@",_az_folderPath,itemDto.fileName];
    NSString * newPath=[NSString stringWithFormat:@"%@%@",_az_folderPath,newName];
    
    __weak AppDelegate * app=APP;
    [CADataHelper moveFileOrFolder:oldPath toDestiny:newPath successRequest:^{
        [app.window makeToast:[NSString stringWithFormat:@"重命名成功"]];
        [_itemsTableView headerBeginRefreshing];
    } failureRequest:^{
        [app.window makeToast:[NSString stringWithFormat:@"重命名失败"]];
    } errorBeforeRequest:^{
        [app.window makeToast:[NSString stringWithFormat:@"重命名失败"]];
    }];
    
    [self backToNoSelect];
    
}

#pragma mark -- placeGetData

-(void)getFoldersDataReloadData{
    _itemsOfPath=[CADataHelper getItemsOfPath:_az_folderPath];
    [_itemsTableView reloadData];
}

//#pragma mark CACloudHelperDelegate
//-(void)cloudHelper:(CACloudHelper *)helper didUpdateFolders:(NSArray *)floders{
//    _itemsOfPath=floders;
//    [self.itemsTableView reloadData];
//}
#pragma mark --- tableView

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    [self.itemsTableView headerEndRefreshing];
    return _itemsOfPath.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 63;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellOfOrderListIdentifier = @"CAFolerCell";
    CAFolerCell *cell = (CAFolerCell *)[tableView  dequeueReusableCellWithIdentifier:cellOfOrderListIdentifier];
    if (!cell) {
        cell = [ViewUtils loadViewFromNib:@"CAFolerCell"];
        cell.delegate=self;
    }
    cell.tag=indexPath.row;
    
    OCFileDto *itemDto=[_itemsOfPath objectAtIndex:indexPath.row];
    [cell setItemDto:itemDto];
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    NSLog(@"height:%f , width:%f",self.view.superview.frame.size.height,self.view.superview.frame.size.width);
    BOOL cellIsSelect=NO;
    for (OCFileDto * oc in _itemsOfPath) {
        if (oc.isSelect) {
            cellIsSelect=YES;
        }
    }
    OCFileDto *itemDto=[_itemsOfPath objectAtIndex:indexPath.row];
    
    if (!cellIsSelect)
    {
        if (itemDto.fileType==CAFileTypeCodeFolder) {
            CAMyFolderViewController * folderVC=[[UIStoryboard storyboardWithName:STORYBAORD_NAME bundle:nil] instantiateViewControllerWithIdentifier:@"CAMyFolderViewController"];
            folderVC.title=itemDto.fileTitle;
            
            folderVC.az_folderPath=[NSString stringWithFormat:@"%@%@",[_az_folderPath stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[itemDto.fileName stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            [self.navigationController pushViewController:folderVC animated:YES];
        }
        else{
//                        CAShowFileViewController * controller=[[CAShowFileViewController alloc]init];
//                        controller.itemDto=itemDto;
//                        CABaseNavigationController * nController=[[CABaseNavigationController alloc]initWithRootViewController:controller];
//                        [self presentViewController:nController animated:YES completion:nil];
            
            //            CAShowFileViewController * controller=[[CAShowFileViewController alloc]init];
            //            controller.itemDto=itemDto;
            //            [self.navigationController pushViewController:controller animated:YES];
            
//            [self palyVideo:itemDto];
//            [self showImage:itemDto];
//            [self showImageWithOCFileDto:itemDto];
            
            [self openFileWithFileDto:itemDto];
        }
    }
    else{
        [self longTouchSelectFoler:itemDto cellIsSelect:cellIsSelect];
    }
}
-(void)longTouchSelectFoler:(OCFileDto *)itemDto cellIsSelect:(BOOL)isSelect{
    for (OCFileDto * oc in _itemsOfPath) {
        if (itemDto !=oc) oc.isSelect=NO;
    }
    itemDto.isSelect=!itemDto.isSelect;
    if (itemDto.isSelect) {
        selectItemDto=itemDto;
        
        BOOL needDelete=YES;
        if (itemDto.isDirectory || itemDto.placeStatus==CAPlaceStutusDownload || itemDto.placeStatus==CAPlaceStutusUpload) {
            needDelete=NO;
        }
        [[CAGlobalData shared].az_mainTab showFileTabbar:isSelect andNeedDelete:needDelete];
    }else{
        [self backToNoSelect];
    }
    [_itemsTableView reloadData];
}
-(void)selectDidClick:(CAFloderOperateCode)code{
    if (selectItemDto) {
        switch (code) {
            case CAFloderOperateCodeDownload:
            {
                [self downloadFileDto:selectItemDto];
                
                [self backToNoSelect];
            }
                break;
            case CAFloderOperateCodeDelete:
            {
                [self deleteFile:selectItemDto];
            }
                break;
            case CAFloderOperateCodeRechristen:
            {
                [[self rechristenAlerView]show];
            }
                break;
            case CAFloderOperateCodeMove:
            {
                
                CAMoveFolderViewController * folderVC=[[CAMoveFolderViewController alloc]init];
                CABaseNavigationController * controllerNC=[[CABaseNavigationController alloc]initWithRootViewController:folderVC];
                folderVC.title=@"赛凡云";
                folderVC.homeDelegate=[self.navigationController. viewControllers objectAtIndex:0];
                folderVC.currentDelegate=self;
                folderVC.folderPath=@"";
                folderVC.sourcePath=[NSString stringWithFormat:@"%@%@",_az_folderPath,selectItemDto.fileName];
                folderVC.itemDto=selectItemDto;
                [self presentViewController:controllerNC animated:YES completion:^{
                    [self backToNoSelect];
                }];
                
                
            }
                break;
            default:
                break;
        }
    }
}
-(void)backToNoSelect{
    for (OCFileDto * oc in _itemsOfPath) {
        if (oc.isSelect) oc.isSelect=NO;
    }
    [_itemsTableView reloadData];
    
    selectItemDto=nil;
    
    [[CAGlobalData shared].az_mainTab showFileTabbar:NO andNeedDelete:YES];
//    if (self.navigationController.viewControllers.count <= 2) {
//        [[CAGlobalData shared].az_mainTab showFileTabbar:NO andNeedDelete:YES];
//    }else{
//    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField.tag==100) {
        [textField selectAll:self];
    }
}
#pragma mark -- alertView
- (UIAlertView*)addFolderAlertView {
    if (!addFolderAlertView) {
        addFolderAlertView = [[UIAlertView alloc] initWithTitle:@"新建文件夹" message:@"请输入文件夹的名称" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"添加", nil];
        addFolderAlertView.alertViewStyle = UIAlertViewStylePlainTextInput;
        UITextField * alertTextField = [addFolderAlertView textFieldAtIndex:0];
        alertTextField.clearButtonMode=UITextFieldViewModeAlways;
        alertTextField.keyboardType = UIKeyboardTypeDefault;
        alertTextField.placeholder = @"新建文件夹";
    }
    [[addFolderAlertView textFieldAtIndex:0] setText:@"新建文件夹"];
    
    return addFolderAlertView;
}
-(UIAlertView *)rechristenAlerView{
    NSString * editingName=@"";
    if (selectItemDto.isDirectory) {
        editingName=selectItemDto.fileTitle;
    }
    else{
        editingName=[self getRenameWithJudgeName:selectItemDto.fileTitle andCombineName:@"" andIsExtension:NO];
    }
    
    UIAlertView * av=[[UIAlertView alloc] initWithTitle:@"重命名文件" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    av.tag=AV_RENAME_TAG;
    av.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField * alertTextField = [av textFieldAtIndex:0];
    alertTextField.delegate=self;
    alertTextField.tag=100;
    alertTextField.clearButtonMode=UITextFieldViewModeAlways;
    alertTextField.keyboardType = UIKeyboardTypeDefault;
    alertTextField.text = editingName;
    alertTextField.placeholder = @"文件名";
    return av;
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView==addFolderAlertView) {
        if (buttonIndex == 1) {
            [self createFolderName:[[alertView textFieldAtIndex:0] text] ];
        }
    }
    else if (alertView.tag==AV_RENAME_TAG){
        if (buttonIndex == 1) {
            UITextField * txt=[alertView textFieldAtIndex:0];
            if ([[txt text] length]==0) {
                [self.view makeToast:@"请输入文件名"];
            }
            else {
                //重命名
                
                NSString * newName=@"";
                if (selectItemDto.isDirectory) {
                    newName=txt.text;
                }
                else{
                    newName=FORMAT(@"%@%@",txt.text,[self getRenameWithJudgeName:selectItemDto.fileTitle andCombineName:@"" andIsExtension:YES]);
                }
                
                NSLog(@"fileName:%@",newName);

                [self renameItemDto:selectItemDto andNewName:[self removeTheSensitiveCharacter:newName]];
            }
        }
    }
}
-(NSString *)removeTheSensitiveCharacter:(NSString *)string{
    string =[string stringByReplacingOccurrencesOfString:@"/" withString:@""];
    string =[string stringByReplacingOccurrencesOfString:@"<" withString:@""];
    string =[string stringByReplacingOccurrencesOfString:@">" withString:@""];
    string =[string stringByReplacingOccurrencesOfString:@":" withString:@""];
    string =[string stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    string =[string stringByReplacingOccurrencesOfString:@" " withString:@""];
    string =[string stringByReplacingOccurrencesOfString:@"?" withString:@""];
    //    string =[string stringByReplacingOccurrencesOfString:@"'" withString:@""];
    //    string =[string stringByReplacingOccurrencesOfString:@"," withString:@""];
    //    string =[string stringByReplacingOccurrencesOfString:@";" withString:@""];
    NSLog(@"%@",string);
    return string;
}
#pragma mark -- UIActionSheet
-(UIActionSheet *)uploadActionSheet{
    UIActionSheet * as=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"照片",@"视频", nil];
    as.tag=AS_UPLOAD_TAG;
    return as;
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag==AS_UPLOAD_TAG) {
        switch (buttonIndex) {
            case 0:
            {
                [self showAssetPicker:ASSET_PICKER_PHOTO_TAG];
                //                [self showPickerController:(NSString *)kUTTypeImage];
            }
                break;
                
            case 1:
            {
                //                [self showAssetPicker:ASSET_PICKER_VIDEO_TAG];
                [self showPickerController:(NSString *)kUTTypeMovie];
                
            }
                break;
            case 2:
            {
                NSLog(@"取消");
            }
                break;
            default:
                break;
        }
    }
}
#pragma mark  -- assetsPicker
-(void)showAssetPicker:(NSString *)assetsType{
    if (!_assets)
        _assets = [[NSMutableArray alloc] init];
    
    ALAssetsFilter *assetsFilter=[ALAssetsFilter allAssets];
    if ([assetsType isEqualToString: ASSET_PICKER_PHOTO_TAG]) {
        assetsFilter=[ALAssetsFilter allPhotos];
    }else if ([assetsType isEqualToString: ASSET_PICKER_VIDEO_TAG]){
        assetsFilter=[ALAssetsFilter allVideos];
    }
    CTAssetsPickerController *picker = [[CTAssetsPickerController alloc] init];
    picker.maximumNumberOfSelection = MaximumNumberOfSelection;
    picker.assetsFilter = assetsFilter;
    picker.delegate = self;
    
    [self presentViewController:picker animated:YES completion:NULL];
}
- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    for (ALAsset *asset in assets) {
        //        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
        //        dateFormatter.dateStyle = NSDateFormatterMediumStyle;
        //        dateFormatter.timeStyle = NSDateFormatterMediumStyle;
        //        NSLog(@"a:%@,b:%@,c:%@",[dateFormatter stringFromDate:[asset valueForProperty:ALAssetPropertyDate]],[asset valueForProperty:ALAssetPropertyType],[UIImage imageWithCGImage:asset.thumbnail]);
        //        [asset valueForProperty:ALAssetPropertyType]
        NSString *fileName =[NSString stringWithFormat:@"%@.jpg",[NSDate nameDescriptionOfTimeInterval:[[asset valueForProperty:ALAssetPropertyDate] timeIntervalSince1970]]];
        NSString * ALAssetType=[NSString stringWithFormat:@"%@",[asset valueForProperty:ALAssetPropertyType]];
        NSData * uploadData=nil;
        if ([ALAssetType isEqualToString:ASSET_PICKER_PHOTO_TAG]) {
            CGImageRef ref = [[asset  defaultRepresentation]fullScreenImage];
            UIImage *img = [[UIImage alloc]initWithCGImage:ref];
            uploadData=UIImageJPEGRepresentation(img, 1);
            //            uploadData=UIImageJPEGRepresentation([UIImage imageWithCGImage:[[asset  defaultRepresentation]fullScreenImage]], 1);
        }
        else if ([ALAssetType isEqualToString:ASSET_PICKER_VIDEO_TAG]) {
            //暂未完成多选视频
            NSLog(@"ALAssetPropertyAssetURL:%@",[[asset defaultRepresentation]metadata]);
            //            NSURL *videoURL = [[asset  defaultRepresentation] url];
            //            NSString *videoPath=videoURL.absoluteString;
            //            uploadData= [NSData dataWithContentsOfURL:videoURL];
            //            获取缩略图：
            //
            //            CGImageRef  ref = [result thumbnail];
            //
            //            UIImage *img = [[UIImage alloc]initWithCGImage:ref];
            //
            //            获取全屏相片：
            //
            //            CGImageRef ref = [[result  defaultRepresentation]fullScreenImage];
            //
            //            UIImage *img = [[UIImage alloc]initWithCGImage:ref];
            //
            //            获取高清相片：
            //
            //            CGImageRef ref = [[result  defaultRepresentation]fullResolutionImage];
        }
        
        //        NSLog(@"name:%@,size:%ld",fileName,uploadData.length);
        //        NSString *fileName = [asset filename];
        //        fileName=[fileName stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        //        NSLog(@"fileName : %@",fileName);
        //
        //        NSString *uploadFileName = [self getFileName:fileName];
        
        [self uploadFile:fileName andData:uploadData];
        
    }
    
    //    [self.tableView beginUpdates];
    //    [self.tableView insertRowsAtIndexPaths:[self indexPathOfNewlyAddedAssets:assets]
    //                          withRowAnimation:UITableViewRowAnimationBottom];
    //
    //    [self.assets addObjectsFromArray:assets];
    //    [self.tableView endUpdates];
}

- (NSArray *)indexPathOfNewlyAddedAssets:(NSArray *)assets
{
    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
    
    //    for (int i = _assets.count; i < assets.count + _assets.count ; i++)
    //        [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:0]];
    
    return indexPaths;
}
#pragma mark -  UIImagePicker
-(void)showPickerController:( NSString *)mediaType{
    //kUTTypeImage kUTTypeVideo
    
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    // 设置所支持的类型，设置只能拍照，或则只能录像，或者两者都可以
    //    picker.allowsEditing = YES;
    NSString *requiredMediaType =mediaType;
    NSArray *arrMediaTypes=[NSArray arrayWithObjects: requiredMediaType,nil];
    [picker setMediaTypes:arrMediaTypes];
    [self presentViewController:picker animated:YES completion:nil];
    
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    
    __weak NSData * uploadData=nil;
    
    if ([mediaType isEqualToString:@"public.image"]) {
        
        UIImage * pickerImage=[info objectForKey:UIImagePickerControllerOriginalImage];
        uploadData=UIImageJPEGRepresentation(pickerImage, 1);
        
        //        NSURL *imageURL = [info valueForKey:UIImagePickerControllerReferenceURL];
        //        ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
        //        {
        //            ALAssetRepresentation *representation = [myasset defaultRepresentation];
        //            NSString *fileName = [representation filename];
        //            fileName=[fileName stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        //            NSLog(@"fileName : %@",fileName);
        //
        //            [self uploadFile:fileName andData:imageData];
        //        };
        //
        //        ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
        //        [assetslibrary assetForURL:imageURL
        //                       resultBlock:resultblock
        //                      failureBlock:nil];
        
        
    }
    else if ([mediaType isEqualToString:@"public.movie"]){
        
        NSString *videoPath = (NSString *)[[info objectForKey:UIImagePickerControllerMediaURL] path];
        uploadData= [NSData dataWithContentsOfFile:videoPath];
    }
    //    videoPath	__NSCFString *	@"/private/var/mobile/Applications/43421C8A-ED55-4E61-B45D-B1F722E60D30/tmp/trim.5E80BB7F-A77B-416E-AF30-78714154557A.MOV"	0x158238c0
    
    o_uploadData=uploadData;
    NSURL *imageURL = [info valueForKey:UIImagePickerControllerReferenceURL];
    ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
    {
        //        ALAssetRepresentation *representation = [myasset defaultRepresentation];
        //        NSString *fileName = [representation filename];
        //        fileName=[fileName stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        //        NSLog(@"fileName : %@",fileName);
        NSString *fileName =[NSString stringWithFormat:@"%@.MOV",[NSDate nameDescriptionOfTimeInterval:[[myasset valueForProperty:ALAssetPropertyDate] timeIntervalSince1970]]];
        //        NSString *uploadFileName = [self getFileName:fileName];
        [self uploadFile:fileName andData:o_uploadData];
        
    };
    
    ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
    [assetslibrary assetForURL:imageURL
                   resultBlock:resultblock
                  failureBlock:nil];
    
    
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}
#pragma end mark
-(void)enterLoginController{
    CALoginViewController * controller=[[CALoginViewController alloc]init];
    controller.delegate=self;
    CABaseNavigationController * navController=[[CABaseNavigationController alloc]initWithRootViewController:controller];
    [self presentViewController:navController animated:YES completion:nil];
    //    [self.navigationController presentViewController:navController animated:YES completion:nil];
}

-(void)showImageWithOCFileDto:(OCFileDto *)itemDto{
    ImageShowViewController * controller=[[ImageShowViewController alloc]init];
    controller.showFileDto=itemDto;
    [self.navigationController pushViewController:controller animated:YES];
}
-(NSString *)getFileName:(NSString *)oldFileName{
    //    oldFileName hasSuffix:
    NSRange suffixRange=[oldFileName rangeOfString:@"."];
    NSString * suffixStr=[oldFileName substringFromIndex:suffixRange.location-1];
    //    NSDateFormatter * dateFormatter=[[NSDateFormatter alloc]init];
    //    [dateFormatter setDateFormat:@"yyyy-MM-ddHH:mm:ss"];
    //    NSString * dateStr=[dateFormatter stringFromDate:[NSDate date]];
    NSString * dateStr=[NSString stringWithFormat:@"%.0f",[[NSDate date]timeIntervalSince1970] * 1000];
    NSLog(@"%@",dateStr);
    dateStr=[dateStr stringByAppendingFormat:@"%d",arc4random()%999];
    //    dateStr=[TXMD5 md5:dateStr];
    dateStr=[dateStr stringByAppendingFormat:@"%@",suffixStr];
    NSLog(@"filename1:%@",dateStr);
    return dateStr;
}

-(NSString * )getRenameWithJudgeName:(NSString *)jName andCombineName:(NSString *)cName andIsExtension:(BOOL) isExtension{
    NSRange aRange=[jName rangeOfString:@"."];
    if (aRange.length>0) {
        NSString * beforeName=[jName substringToIndex:aRange.location+1];
        NSString * afterName=[jName substringFromIndex:aRange.location+1];
        return [self getRenameWithJudgeName:afterName andCombineName:[NSString stringWithFormat:@"%@%@",cName,beforeName] andIsExtension:isExtension];
    }
    
    if (cName.length>0) {
        NSString * lastStr=[cName substringFromIndex:cName.length-1];
        if ([lastStr isEqualToString:@"."]) {
            cName=[cName substringToIndex:cName.length-1];
            jName=[NSString stringWithFormat:@".%@",jName];
        }
        
        return isExtension?jName:cName;
    }
    else{
        return isExtension?cName:jName;
    }
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
 测试http://27.154.58.234:2001/ext/storage/index.php/apps/contacts/addressbook/local/1
 */
//-(void)Contacts{
//    OCWebDAVClient * webDAVClient=[[OCWebDAVClient alloc]init];
//    [webDAVClient shareByLinkFileOrFolderByServer:@"http://27.154.58.234:2001/ext/storage/remote.php/webdav/contacts/addressbook" andPath:@"/Users/jonas/Library/Application Support/iPhone Simulator/7.1-64/Applications/99A6974E-9C5D-4330-BD34-7A6233E8C6E6/Library/Caches/27.154.58.234:2001/admin111/CloudApp/jonas.vcf" onCommunication:[AppDelegate sharedOCCommunication] success:^(OCHTTPRequestOperation * operation, id object) {
//        NSLog(@"object:%@",object);
//    } failure:^(OCHTTPRequestOperation * operation, NSError *error) {
//        NSLog(@"error:%@",error);
//    }];
//}


//- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
//    if ([presented isKindOfClass:TGRImageViewController.class]) {
//        return [[TGRImageZoomAnimationController alloc] initWithReferenceImageView:self.imageButton.imageView];
//    }
//    return nil;
//}
//
//- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
//    if ([dismissed isKindOfClass:TGRImageViewController.class]) {
//        return [[TGRImageZoomAnimationController alloc] initWithReferenceImageView:self.imageButton.imageView];
//    }
//    return nil;
//}
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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoFinished) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    

}
-(void)videoFinished{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
}

-(void)openDocument:(OCFileDto *)fileDto{
//    NSURL *URL = [[NSBundle mainBundle] URLForResource:@"Example" withExtension:@"odt"];
    if ([CADataHelper placeHasSave:fileDto]) {
        [self openDocumentWithFileDto:fileDto];
    }
    else{
//        NSString * path=[NSString stringWithFormat:@"%@%@",_az_folderPath,fileDto.fileName];
        
        
        __weak AppDelegate * app=APP;
        [app.window makeToastActivity];
        [CADataHelper downloadFileDto:fileDto willStart:^{
            //        [app.window makeToast:@"添加至下载列表"];
        }progressDownload:^(NSUInteger bytesRead, long long totalBytesRead, long long totalExpectedBytesRead) {
            
        } successRequest:^(NSString *downPath) {
            //        [app.window makeToast:@"下载成功"];
            [app.window hideToastActivity];
            
            
            [CADataHelper updatePlaseFileStatusWithStatus:CAPlaceStutusDownload andFileDto:fileDto];
            
            [self openDocumentWithFileDto:fileDto];
        } failureRequest:^(NSError *error) {
            [app.window hideToastActivity];
            [app.window makeToast:@"下载失败"];
        }];
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
            controller.title=fileDto.fileTitle;
            CABaseNavigationController * nController=[[CABaseNavigationController alloc]initWithRootViewController:controller];
            [self presentViewController:nController animated:YES completion:nil];
            

        }
    }
}
- (UIViewController*)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController*)controller

{
    
    return self;
    
}

- (UIView*)documentInteractionControllerViewForPreview:(UIDocumentInteractionController*)controller

{
    
    return self.view;
    
}

- (CGRect)documentInteractionControllerRectForPreview:(UIDocumentInteractionController*)controller

{
    
    return self.view.frame;
    
}

// 点击预览窗口的“Done”(完成)按钮时调用

- (void)documentInteractionControllerDidEndPreview:(UIDocumentInteractionController*)_controller

{
    
}
@end
