//
//  DLDetailViewController.h
//  YooToob
//
//  Created by Jeffrey Kelley on 12/7/11.
//  Copyright (c) 2011 Detroit Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DLDetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end
