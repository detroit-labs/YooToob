//
//  DLYouTubeVideoViewController.m
//  YooToob
//
//  Created by Jeffrey Kelley on 12/7/11.
//  Copyright (c) 2011 Detroit Labs. All rights reserved.
//


#import "DLYouTubeVideoViewController.h"


@interface DLYouTubeVideoViewController (PrivateMethods)

#if TARGET_IPHONE_SIMULATOR == 1
- (NSURL *)videoURLForVideoID:(NSString *)videoID;
#else
- (NSString *)htmlStringForVideoID:(NSString *)videoID;
#endif

@end

@implementation DLYouTubeVideoViewController (PrivateMethods)

#if TARGET_IPHONE_SIMULATOR == 1
- (NSURL *)videoURLForVideoID:(NSString *)videoID
{
	NSString *urlAsString = [NSString stringWithFormat:@"http://m.youtube.com/watch?v=%@", videoID];
	NSURL *returnURL = [NSURL URLWithString:urlAsString];
	
	return returnURL;
}
#else
- (NSString *)htmlStringForVideoID:(NSString *)videoID
{
	NSInteger width = [[self webView] frame].size.width;
	
	NSString *htmlString = [NSString stringWithFormat:@"<html><head><meta name = \"viewport\" content = \"initial-scale = 1.0, user-scalable = no, width = %d\"/></head><body style=\"background:black;margin-top:0px;margin-left:0px;margin-right:0px;margin-bottom:0px\"><div><object width=\"100%%\" height=\"100%%\"><param name=\"movie\" value=\"http://www.youtube.com/v/%@&f=gdata_videos&c=ytapi-my-clientID&d=nGF83uyVrg8eD4rfEkk22mDOl3qUImVMV6ramM\"></param><param name=\"wmode\" value=\"transparent\"></param><embed src=\"http://www.youtube.com/v/%@&f=gdata_videos&c=ytapi-my-clientID&d=nGF83uyVrg8eD4rfEkk22mDOl3qUImVMV6ramM\" type=\"application/x-shockwave-flash\" wmode=\"transparent\" width=\"100%%\" height=\"100%%\"></embed></object></div></body></html>", width, videoID, videoID];
	
	return htmlString;
}
#endif

@end


@implementation DLYouTubeVideoViewController

@synthesize videoID = _videoID;
@synthesize webView = _webView;

#pragma mark - Object Lifecycle

- (void)dealloc
{
	[self removeObserver:self
			  forKeyPath:@"videoID"];
}

#pragma mark - View Controller Lifecycle

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
	return (toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)viewDidLoad
{
	[self addObserver:self
		   forKeyPath:@"videoID"
			  options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionInitial)
			  context:NULL];
}

- (void)viewDidUnload
{
	[self removeObserver:self
			  forKeyPath:@"videoID"];

	[self setWebView:nil];
	
	[super viewDidUnload];
}

#pragma mark - Key-Value Observing

- (void)observeValueForKeyPath:(NSString *)keyPath
					  ofObject:(id)object
						change:(NSDictionary *)change
					   context:(void *)context
{
	if (object == self) {
		if ([keyPath isEqualToString:@"videoID"]) {
			NSString *videoID = [change objectForKey:NSKeyValueChangeNewKey];
			
			if (videoID != nil &&
				[videoID length] > 0) {
#if TARGET_IPHONE_SIMULATOR == 1
				NSURLRequest *request = [NSURLRequest requestWithURL:[self videoURLForVideoID:videoID]];
				[[self webView] loadRequest:request];
#else
				NSString *htmlString = [self htmlStringForVideoID:videoID];
				
				[[self webView] loadHTMLString:htmlString
									   baseURL:[NSURL URLWithString:@"http://www.detroitlabs.com"]];
#endif
			}
		}
	}
}

#pragma mark -

@end
