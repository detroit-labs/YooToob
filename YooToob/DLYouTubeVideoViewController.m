//
//  DLYouTubeVideoViewController.m
//  YooToob
//
//  Created by Jeffrey Kelley on 12/7/11.
//  Copyright (c) 2011 Detroit Labs. All rights reserved.
//


#import "DLYouTubeVideoViewController.h"


@interface DLYouTubeVideoViewController (PrivateMethods)

- (NSURL *)videoURLForVideoID:(NSString *)videoID;

@end

@implementation DLYouTubeVideoViewController (PrivateMethods)

- (NSURL *)videoURLForVideoID:(NSString *)videoID
{
	NSString *urlAsString = [NSString stringWithFormat:@"http://m.youtube.com/watch?v=%@", videoID];
	NSURL *returnURL = [NSURL URLWithString:urlAsString];
	
	return returnURL;
}

@end


@implementation DLYouTubeVideoViewController

@synthesize videoID = _videoID;
@synthesize webView = _webView;

#pragma mark - View Controller Lifecycle

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
				NSURLRequest *request = [NSURLRequest requestWithURL:[self videoURLForVideoID:videoID]];
				[[self webView] loadRequest:request];
			}
		}
	}
}

#pragma mark -

@end
