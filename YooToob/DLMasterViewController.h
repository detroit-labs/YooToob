//
//  DLMasterViewController.h
//  YooToob
//
//  Created by Jeffrey Kelley on 12/7/11.
//  Copyright (c) 2011 Detroit Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DLDetailViewController;

@interface DLMasterViewController : UITableViewController

@property (strong, nonatomic) DLDetailViewController *detailViewController;

@end
