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
#define AV_RENAME_TAG 100
#define AS_UPLOAD_TAG 200

#define ASSET_PICKER_PHOTO_TAG @"ALAssetTypePhoto"
#define ASSET_PICKER_VIDEO_TAG @"ALAssetTypeVideo"
#define MaximumNumberOfSelection 1

@interface CAMyFolderViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,BottonOperateDelegate,CAFolerCellDelegate,CTAssetsPickerControllerDelegate>
{
    UIAlertView * addFolderAlertView ;
    NSUserDefaults * userDefaults;
//    CACloudHelper * cloudHelper;
    BOOL isRequest;
    OCFileDto * selectItemDto;
    
    NSMutableArray * _assets;
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
    
    UIBarButtonItem * rightBarItem=[CrateComponent createRightBarButtonItemWithTitle:@"上传" andTarget:self andAction:@selector(updateFileAction)];
    [self.navigationItem setRightBarButtonItem:rightBarItem];
}
-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    if (_az_isRootPath) {
        [super viewWillAppear:animated];
    }
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
    
    userDefaults =[NSUserDefaults standardUserDefaults];

    if (!_az_folderPath) _az_folderPath=@"";
    

    [[CAGlobalData shared].az_mainTab setAz_operateDelegate:self];
    
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
-(void)updateFileAction{
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
        [_itemsTableView reloadData];

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
//    NSString * path=[NSString stringWithFormat:@"%@/%@",_az_folderPath,name];
//    [CADataHelper createFolderWithPath:path IsSuccess:^(BOOL isSuccess) {
//        if (isSuccess) {
//            [self getFoldersData];
//        }
//    }];
}

-(void)uploadFile:(NSString *)fileName andData:(NSData *)fileData {
    NSString * path=[NSString stringWithFormat:@"%@/%@",_az_folderPath,fileName];
    
    __weak CAMyFolderViewController * controller=self;
    [CADataHelper uploadFile:path uploadFileName:fileName fileData:fileData willStart:^{
        [controller.view makeToast:@"已加入上传列表"];
    }progressUpload:^(NSUInteger bytesWrite, long long totalBytesWrite, long long totalExpectedBytesWrite) {
        NSLog(@"上传：%ld",bytesWrite);
    }successRequest:^{
        [controller.view makeToast:@"上传成功"];
        [_itemsTableView headerBeginRefreshing];
    } failureRequest:^(NSError * error) {
        [controller.view makeToast:@"上传失败"];
    } failureBeforeRequest:^(NSError *error) {
        [controller.view makeToast:@"上传失败"];
    }];
}
-(void)downloadFile:(NSString *)fileName {
    NSString * path=[NSString stringWithFormat:@"%@/%@",_az_folderPath,fileName];
    
    __weak CAMyFolderViewController * controller=self;
    
    [CADataHelper downloadFile:path downloadFileName:fileName willStart:^{
        [controller.view makeToast:@"已加入下载列表"];
    }progressDownload:^(NSUInteger bytesRead, long long totalBytesRead, long long totalExpectedBytesRead) {
        
//        NSLog(@"下载外：%ld",bytesRead);
    } successRequest:^(NSString *downPath) {
         [controller.view makeToast:@"下载成功"];
    } failureRequest:^(NSError *error) {
         [controller.view makeToast:@"下载失败"];
    }];
    
    [self backToNoSelect];
}
-(void)deleteFile:(OCFileDto *)itemDto{
    
    NSString * path=[NSString stringWithFormat:@"%@/%@",_az_folderPath,itemDto.fileName];
    __weak CAMyFolderViewController * controller=self;
    [CADataHelper deleteFileOrFolder:path successRequest:^{
        [controller.view makeToast:[NSString stringWithFormat:@"删除成功"]];
        [_itemsTableView headerBeginRefreshing];
    } failureRquest:^(NSError *error) {
        [controller.view makeToast:@"删除失败"];
//        [_itemsTableView reloadData];
    }];
    
    [self backToNoSelect];
}
-(void)renameItemDto:(OCFileDto *)itemDto andNewName:(NSString *)newName{
    NSString * oldPath=[NSString stringWithFormat:@"%@/%@",_az_folderPath,itemDto.fileName];
    NSString * newPath=[NSString stringWithFormat:@"%@/%@",_az_folderPath,newName];
    __weak CAMyFolderViewController * controller=self;
    [CADataHelper moveFileOrFolder:oldPath toDestiny:newPath successRequest:^{
        [controller.view makeToast:[NSString stringWithFormat:@"重命名成功"]];
        [_itemsTableView headerBeginRefreshing];
    } failureRequest:^{
        [controller.view makeToast:[NSString stringWithFormat:@"重命名失败"]];
    } errorBeforeRequest:^{
        [controller.view makeToast:[NSString stringWithFormat:@"重命名失败"]];
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
            
            folderVC.az_folderPath=[NSString stringWithFormat:@"%@/%@",_az_folderPath,itemDto.fileName];
            [self.navigationController pushViewController:folderVC animated:YES];
        }
        else{
//            [self showImageWithOCFileDto:itemDto];
            CAShowFileViewController * controller=[[CAShowFileViewController alloc]init];
            controller.itemDto=itemDto;
            [self.navigationController pushViewController:controller animated:YES];
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
        [[CAGlobalData shared].az_mainTab showFileTabbar:isSelect andIsFolder:itemDto.isDirectory];
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
                [self downloadFile:selectItemDto.fileName];
                
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
                folderVC.sourcePath=[NSString stringWithFormat:@"%@/%@",_az_folderPath,selectItemDto.fileName];
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
     [[CAGlobalData shared].az_mainTab showFileTabbar:NO andIsFolder:NO];
}
#pragma mark -- alertView
- (UIAlertView*)addFolderAlertView {
    if (!addFolderAlertView) {
        addFolderAlertView = [[UIAlertView alloc] initWithTitle:@"新建文件夹" message:@"请输入文件夹的名称" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"添加", nil];
        addFolderAlertView.alertViewStyle = UIAlertViewStylePlainTextInput;
        UITextField * alertTextField = [addFolderAlertView textFieldAtIndex:0];
        alertTextField.text=@"新建文件夹";
        alertTextField.clearButtonMode=UITextFieldViewModeAlways;
        alertTextField.keyboardType = UIKeyboardTypeDefault;
        alertTextField.placeholder = @"新建文件夹";
    }
    return addFolderAlertView;
}
-(UIAlertView *)rechristenAlerView{
    UIAlertView * av=[[UIAlertView alloc] initWithTitle:@"重命名文件" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    av.tag=AV_RENAME_TAG;
    av.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField * alertTextField = [av textFieldAtIndex:0];
    alertTextField.clearButtonMode=UITextFieldViewModeAlways;
    alertTextField.keyboardType = UIKeyboardTypeDefault;
    alertTextField.text = selectItemDto.fileTitle;
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
                [self renameItemDto:selectItemDto andNewName:txt.text];
            }
        }
    }
}

#pragma mark -- UIActionSheet
-(UIActionSheet *)uploadActionSheet{
    UIActionSheet * as=[[UIActionSheet alloc]initWithTitle:@"上传文件" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"照片",@"视频", nil];
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
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateStyle = NSDateFormatterMediumStyle;
        dateFormatter.timeStyle = NSDateFormatterMediumStyle;
        NSLog(@"a:%@,b:%@,c:%@",[dateFormatter stringFromDate:[asset valueForProperty:ALAssetPropertyDate]],[asset valueForProperty:ALAssetPropertyType],[UIImage imageWithCGImage:asset.thumbnail]);
        
        NSString *fileName =[NSString stringWithFormat:@"%@.jpg",[NSDate nameDescriptionOfTimeInterval:[[asset valueForProperty:ALAssetPropertyDate] timeIntervalSince1970]]];
        NSString * ALAssetType=[NSString stringWithFormat:@"%@",[asset valueForProperty:ALAssetPropertyType]];
        NSData * uploadData=nil;
        if ([ALAssetType isEqualToString:ASSET_PICKER_PHOTO_TAG]) {
            uploadData=UIImageJPEGRepresentation([UIImage imageWithCGImage:asset.thumbnail], 1);
        }
        else if ([ALAssetType isEqualToString:ASSET_PICKER_VIDEO_TAG]) {
            uploadData=UIImageJPEGRepresentation([UIImage imageWithCGImage:[[asset  defaultRepresentation]fullScreenImage]], 1);
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
        NSLog(@"name:%@,size:%ld",fileName,uploadData.length);
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
    if ([mediaType isEqualToString:@"public.image"]) {
        
        __weak UIImage * pickerImage=[info objectForKey:UIImagePickerControllerOriginalImage];
        NSData * imageData=UIImageJPEGRepresentation(pickerImage, 1);
        
        NSURL *imageURL = [info valueForKey:UIImagePickerControllerReferenceURL];
        ALAssetsLibraryAssetForURLResultBlock resultblock = ^(ALAsset *myasset)
        {
            ALAssetRepresentation *representation = [myasset defaultRepresentation];
            NSString *fileName = [representation filename];
            fileName=[fileName stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSLog(@"fileName : %@",fileName);
            
            [self uploadFile:fileName andData:imageData];
        };
        
        ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
        [assetslibrary assetForURL:imageURL
                       resultBlock:resultblock
                      failureBlock:nil];
        
        
    }
//    NSURL *assetURL = [info objectForKey:UIImagePickerControllerReferenceURL];
//    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
//    [library assetForURL:assetURL
//             resultBlock:^(ALAsset *asset) {
//                 NSDictionary* imageMetadata = [[NSMutableDictionary alloc] initWithDictionary:asset.defaultRepresentation.metadata];
//                 NSDictionary *GPSDict=[imageMetadata objectForKey:kCGImagePropertyGPSDictionary];
//                 NSLog(@"%@",GPSDict);
//                 NSLog(@"%@",imageMetadata);
////                  GPSDict 里面即是照片的GPS信息,具体可以输出看看
//             }
//            failureBlock:^(NSError *error) {
//            }];

    
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

//-(void)showImageWithOCFileDto:(OCFileDto *)itemDto{
//    ImageShowViewController * controller=[[ImageShowViewController alloc]init];
//    controller.showFileDto=itemDto;
//    [self.navigationController pushViewController:controller animated:YES];
//}
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
@end
