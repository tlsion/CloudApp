//
//  CAFolerCell.m
//  CloudApp
//
//  Created by Pro on 7/30/14.
//  Copyright (c) 2014 王庭协. All rights reserved.
//

#import "CAFolerCell.h"
#import "TXSize.h"
#import "NSDate+Tingxie.h"
#import "CommonHelper.h"
@implementation CAFolerCell

- (void)awakeFromNib
{
    // Initialization code
    self.mainImageView.placeholderImage=[UIImage imageNamed:@"预览小图.png"];
    self.longPressGesture.minimumPressDuration=0.5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)longPressGetures:(UILongPressGestureRecognizer *)sender {
    if(UIGestureRecognizerStateBegan == sender.state) {
        //        NSInteger row=gesture.view.tag;
        CAFolerCell * cell=(CAFolerCell *)sender.view.superview.superview;
        
        if (_delegate) {
            [_delegate longTouchSelectFoler:cell.itemDto cellIsSelect:cell.selectImageView.hidden];
        }
//        cell.selectImageView.hidden=!cell.selectImageView.hidden;
//        cell.itemDto.isSelect=!cell.selectImageView.hidden;
    }
}
-(void)setItemDto:(OCFileDto *)itemDto{
    _itemDto=itemDto;
    self.sizeLabel.text=[NSString stringWithFormat:@"%@",[CommonHelper getFileSizeString: itemDto.size]];
    switch (itemDto.fileType) {
        case CAFileTypeCodeFolder:
            self.mainImageView.image=[UIImage imageNamed:@"文件-文件夹_2_4.png"];
            self.sizeLabel.text=@"";
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
    
    self.selectImageView.hidden=!itemDto.isSelect;
    
    self.mainTitleLabel.text=itemDto.fileTitle;
    
    self.timeLabel.text=[NSDate getTimeWithTimeInterval:itemDto.date];
}
@end