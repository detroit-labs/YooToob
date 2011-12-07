//
//  DLYouTubeVideoViewController.h
//  YooToob
//
//  Created by Jeffrey Kelley on 12/7/11.
//  Copyright (c) 2011 Detroit Labs. All rights reserved.
//


#import <UIKit/UIKit.h>


@interface DLYouTubeVideoViewController : UIViewController

@property (strong) IBOutlet UIWebView	*webView;
@property (copy)            NSString 	*videoID;

@end
