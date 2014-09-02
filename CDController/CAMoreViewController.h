//
//  CDMoreViewController.h
//  CloudDisk
//
//  Created by Pro on 7/17/14.
//  Copyright (c) 2014 王庭协. All rights reserved.
//

//#import "CASubTabViewController.h"
#import <UIKit/UIKit.h>

#import <MessageUI/MessageUI.h>

@interface CAMoreViewController : UITableViewController 
@property (strong, nonatomic) IBOutlet UISwitch *syncOnStartSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *syncinBackgroundSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *showFaviconsSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *showThumbnailsSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *markWhileScrollingSwitch;
@property (strong, nonatomic) IBOutlet UITableViewCell *syncOnStartCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *syncInBackgroundCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *showFaviconsCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *showThumbnailsCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *markWhileScrollingCell;

- (IBAction)syncOnStartChanged:(id)sender;
- (IBAction)syncInBackgroundChanged:(id)sender;
- (IBAction)showFaviconsChanged:(id)sender;
- (IBAction)showThumbnailsChanged:(id)sender;
- (IBAction)markWhileScrollingChanged:(id)sender;
- (IBAction)didTapDone:(id)sender;

@end
