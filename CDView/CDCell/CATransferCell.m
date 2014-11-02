//
//  CATransferCell.m
//  CloudApp
//
//  Created by Pro on 7/31/14.
//  Copyright (c) 2014 王庭协. All rights reserved.
//

#import "CATransferCell.h"
#import "CommonHelper.h"
@implementation CATransferCell
- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setItemDto:(OCFileDto *)itemDto{
    _itemDto=itemDto;
    if (itemDto) {
        if (itemDto.isTransfer) {
            _itemDto.delegate=self;
        }
        
        switch (itemDto.fileType) {
            case CAFileTypeCodeFolder:
                self.mainImageView.image=[UIImage imageNamed:@"文件-文件夹_2_4.png"];
                break;
            case CAFileTypeCodeImage:
                self.mainImageView.image=[UIImage imageNamed:@"文件-图片_2_4.png"];
                break;
            case CAFileTypeCodeCompress:
                self.mainImageView.image=[UIImage imageNamed:@"文件-压缩_2_4.png"];
                break;
            case CAFileTypeCodeTxt:
                self.mainImageView.image=[UIImage imageNamed:@"文件-文档_2_4.png"];
                break;
            case CAFileTypeCodeAudio:
                self.mainImageView.image=[UIImage imageNamed:@"文件-音乐_2_4.png"];
                break;
            case CAFileTypeCodeVideo:
                self.mainImageView.image=[UIImage imageNamed:@"文件-视频_2_4.png"];
                break;
            case CAFileTypeCodeOther:
                self.mainImageView.image=[UIImage imageNamed:@"文件-其他_2_4.png"];
                break;
            default:
                break;
        }
        
//        self.operaterButton.hidden=YES;
//        switch (itemDto.tranferStatus) {
//            case CATransferStatusDefault:
//                
//                break;
//            case CATransferStatusDoing:
//                self.operaterButton.hidden=NO;
//                self.operaterButton.selected=YES;
//                break;
//            case CATransferStatusStop:
//                self.operaterButton.hidden=NO;
//                self.operaterButton.selected=NO;
//                break;
//            case CATransferStatusDid:
//                
//                break;
//            default:
//                break;
//        }
        
        self.mainTitleLabel.text=itemDto.fileTitle;
        self.sizeLabel.text=[NSString stringWithFormat:@"%@/%@",[CommonHelper getFileSizeString:itemDto.totalBytes],[CommonHelper getFileSizeString: itemDto.size]];
        
        if (itemDto.size==0) {
            [self.scheduleProgressView setProgress:1 animated:NO];
        }else{
            
            [self.scheduleProgressView setProgress:itemDto.totalBytes/itemDto.size animated:NO];
        }
//        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(aaa) userInfo:nil repeats:YES];
    }
    
}
-(void)setDoBytes:(NSInteger)aBytes{
    dispatch_async(kMainQueue, ^{
        
        self.internetSpeedLabel.text=[CommonHelper getFileSizeString:aBytes];
    });
}
-(void)setDoTotalBytes:(long long)aTotalBytes{
//    NSLog(@"%lld",aTotalBytes);
    dispatch_async(kMainQueue, ^{
        CGFloat progress=(CGFloat)aTotalBytes/(CGFloat)_itemDto.size;
        self.sizeLabel.text=[NSString stringWithFormat:@"%@/%@",[CommonHelper getFileSizeString:aTotalBytes],[CommonHelper getFileSizeString: _itemDto.size]];
//        NSLog(@"%@",self.sizeLabel.text);
        [self.scheduleProgressView setProgress:progress animated:YES];
    });
}
@end
