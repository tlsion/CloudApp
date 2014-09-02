//
//  NoWifiShowView.m
//  CloudApp
//
//  Created by Pro on 9/1/14.
//  Copyright (c) 2014 王庭协. All rights reserved.
//

#import "NoWifiShowView.h"

@implementation NoWifiShowView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (IBAction)hiddenAction:(id)sender {
    [self removeFromSuperview];
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
