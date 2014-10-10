//
//  CAMoveFolderViewController.m
//  CloudApp
//
//  Created by Pro on 8/27/14.
//  Copyright (c) 2014 王庭协. All rights reserved.
//

#import "CAMoveFolderViewController.h"
#import "OCFileDto.h"
#import "MJRefresh.h"
@interface CAMoveFolderViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    
}
@end

@implementation CAMoveFolderViewController

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
    [self customNavigationBar];
    [self initItemsData];
}
-(void)customNavigationBar{
    UIBarButtonItem * backBarItem=[CrateComponent createBackBarButtonItemWithTarget:self andAction:@selector(backAction)];
    
    [self.navigationItem setLeftBarButtonItem:backBarItem];
    
    UIBarButtonItem * rightBarItem=[CrateComponent createRightBarButtonItemWithTitle:@"确定" andTarget:self andAction:@selector(moveAction)];
    [self.navigationItem setRightBarButtonItem:rightBarItem];
}
-(void)backAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)moveAction{
    __weak CAMoveFolderViewController * controller=self;
    NSString * destinyPath=[NSString stringWithFormat:@"%@%@",_folderPath,_itemDto.fileName];
    [self.view makeToastActivity];
    [CADataHelper moveFileOrFolder:_sourcePath toDestiny:destinyPath successRequest:^{
        [controller.view hideToastActivity];
        [self dismissViewControllerAnimated:YES completion:^{
            if (_homeDelegate) {
                [_homeDelegate getFoldersData];
            }
            if (_currentDelegate && _currentDelegate !=_homeDelegate) {
                [_currentDelegate getFoldersData];
            }
        }];
    } failureRequest:^{
        [controller.view makeToast:@"移动失败"];
        [controller.view hideToastActivity];
    } errorBeforeRequest:^{
        
        [controller.view makeToast:@"移动失败"];
        [controller.view hideToastActivity];
    }];
}
-(void)initItemsData{
    NSArray  * allItems=[CADataHelper getItemsOfPath:_folderPath];
    [self getFolderOfAllItems:allItems];
}
-(void)getFolderOfAllItems:(NSArray *)allItems{
    
    _itemsOfPath=[[NSMutableArray alloc]init];
    for (OCFileDto * fd in allItems) {
        if (fd.isDirectory && fd.etag !=_itemDto.etag) {
            [_itemsOfPath addObject:fd];
        }
    }
    
    
    [_itemsTableView reloadData];
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
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    [self.itemsTableView headerEndRefreshing];
    return _itemsOfPath.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * cellIdentifier=@"MoveFolderCellIdentifier";
    UITableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    OCFileDto * itemDto=_itemsOfPath[indexPath.row];
    cell.textLabel.font=[UIFont boldSystemFontOfSize:12];
    cell.textLabel.text=itemDto.fileTitle;
    cell.imageView.image=[UIImage imageNamed:@"文件-文件夹_2_4.png"];
    NSLog(@"%@%@,%@%@",_itemDto.filePath,_itemDto.fileName,itemDto.filePath,itemDto.fileName);
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    OCFileDto *itemDto=[_itemsOfPath objectAtIndex:indexPath.row];
    CAMoveFolderViewController * folderVC=[[CAMoveFolderViewController alloc]init];
    folderVC.title=itemDto.fileTitle;
    folderVC.homeDelegate=_homeDelegate;
    folderVC.currentDelegate=_currentDelegate;
    folderVC.folderPath=[NSString stringWithFormat:@"%@%@",[_folderPath stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding],[itemDto.fileName stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    folderVC.sourcePath=_sourcePath;
    folderVC.itemDto=_itemDto;
    [self.navigationController pushViewController:folderVC animated:YES];
}
- (void) getFoldersData {
    [CADataHelper updateFolderWithPath:_folderPath successRequest:^(NSHTTPURLResponse * response, NSArray *itemsOfPath) {
        //        NSLog(@"%@",itemsOfPath);
        NSArray  * allItems=[CADataHelper getItemsOfPath:_folderPath];
        [self getFolderOfAllItems:allItems];
        
    } failureRequest:^(NSHTTPURLResponse * response) {
        
        [_itemsTableView reloadData];
    }];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
