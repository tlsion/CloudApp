//
//  CAFolerCell.h
//  CloudApp
//
//  Created by Pro on 7/30/14.
//  Copyright (c) 2014 王庭协. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"
#import "OCFileDto.h"
@protocol CAFolerCellDelegate;
@interface CAFolerCell : UITableViewCell<EGOImageViewDelegate>
@property (strong, nonatomic) IBOutlet EGOImageView *mainImageView;
@property (strong, nonatomic) IBOutlet UIImageView *statusImageView;
@property (strong, nonatomic) IBOutlet UILabel *mainTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *sizeLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UIButton *selectButton;
@property (strong, nonatomic) OCFileDto * itemDto;
@property (weak, nonatomic) id<CAFolerCellDelegate>delegate;
//@property (weak, nonatomic) IBOutlet UILongPressGestureRecognizer *longPressGesture;

@end
@protocol CAFolerCellDelegate <NSObject>

-(void)longTouchSelectFoler:(OCFileDto *)itemDto cellIsSelect:(BOOL)isSelect;

@end