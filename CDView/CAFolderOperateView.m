//
//  CAFolderOperateView.m
//  CloudApp
//
//  Created by Pro on 8/11/14.
//  Copyright (c) 2014 王庭协. All rights reserved.
//

#import "CAFolderOperateView.h"

@implementation CAFolderOperateView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (IBAction)selectFolderOperateAction:(UIButton *)sender {
    if (self.delegate)
    [self.delegate selectFolderOperate:sender.tag];
}
-(void)setIsDirectory:(BOOL)isDirectory{
    _isDirectory=isDirectory;
    //下载的按钮
    UIButton * btn=[self.subviews objectAtIndex:1];
    if (isDirectory) {
        [btn setEnabled:NO];
    }
    else{
        [btn setEnabled:YES];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
