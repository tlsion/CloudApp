//
//  CATransferCell.h
//  CloudApp
//
//  Created by Pro on 7/31/14.
//  Copyright (c) 2014 王庭协. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"
#import "OCFileDto.h"
@interface CATransferCell : UITableViewCell<OCFileDtoDelegate>
@property (strong, nonatomic) IBOutlet EGOImageView *mainImageView;
@property (strong, nonatomic) IBOutlet UILabel *mainTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *internetSpeedLabel;

@property (strong, nonatomic) IBOutlet UILabel *sizeLabel;
@property (strong, nonatomic) IBOutlet UIProgressView *scheduleProgressView;
//@property (strong, nonatomic) IBOutlet UIButton *operaterButton;

@property (strong, nonatomic) OCFileDto * itemDto;
@end
