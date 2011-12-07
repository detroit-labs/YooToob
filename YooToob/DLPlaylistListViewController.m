//
//  DLPlaylistListViewController.m
//  YooToob
//
//  Created by Jeffrey Kelley on 12/7/11.
//  Copyright (c) 2011 Detroit Labs. All rights reserved.
//


#import "DLPlaylistListViewController.h"

#import <objc/runtime.h>

#import "GData.h"

#import "DLYouTubeVideoViewController.h"


@interface DLPlaylistListViewController (PrivateMethods)

- (NSString *)applicationCacheDirectory;
- (NSString *)thumbnailCacheDirectory;

@end


@implementation DLPlaylistListViewController (PrivateMethods)

- (NSString *)applicationCacheDirectory
{
	return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,
												NSUserDomainMask,
												YES) objectAtIndex:0];
}

- (NSString *)thumbnailCacheDirectory
{
	return [[self applicationCacheDirectory] stringByAppendingPathComponent:@"DL__YOUTUBE__THUMBNAILS"];
}

@end


@implementation DLPlaylistListViewController

@synthesize videos = _videos;

#pragma mark - Object Lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil
			   bundle:(NSBundle *)nibBundleOrNil
{
	self = [super initWithNibName:nibNameOrNil
						   bundle:nibBundleOrNil];
	
	if (self) {
		_videos = [[NSMutableArray alloc] init];
	}
	
	return self;
}

#pragma mark - View Controller Lifecycle

- (void)viewDidLoad
{
	// Load videos.
	GDataServiceGoogleYouTube *youTubeService = [[GDataServiceGoogleYouTube alloc] init];
	
	[youTubeService fetchFeedWithURL:[GDataServiceGoogleYouTube youTubeURLForFeedID:kGDataYouTubeFeedIDTopRated]
				   completionHandler:^(GDataServiceTicket *ticket, GDataFeedBase *feed, NSError *error) {
					   for (id entry in [feed entries]) {
						   [[self videos] addObject:entry];
					   }
					   
					   [[self tableView] reloadData];
				   }];
}

#pragma mark - UITableViewDataSource Protocol Methods

static NSInteger const kNumberOfSections = 1;

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return kNumberOfSections;
}

static NSString * const kCellIdentifier = @"VideoPreviewCell";
static void *kIndexPathKey = &kIndexPathKey;

- (UITableViewCell *)tableView:(UITableView *)tableView
		 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
	
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
									  reuseIdentifier:kCellIdentifier];
	}
	
	[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
	
	GDataEntryYouTubeVideo *video = [[self videos] objectAtIndex:[indexPath row]];
	
	[[cell textLabel] setText:[[video title] stringValue]];
	
	NSString *thumbnailURL = [[[video mediaGroup] highQualityThumbnail] URLString];
	
	NSString *indexPathString = [NSString stringWithFormat:@"%d %d",
								 [indexPath section],
								 [indexPath row]];
	
	objc_setAssociatedObject(cell,
							 kIndexPathKey,
							 indexPathString,
							 OBJC_ASSOCIATION_COPY);
	
	if (thumbnailURL) {
		NSString *thumbnailURLHash = [NSString stringWithFormat:@"%lu", [thumbnailURL hash]];
		
		NSFileManager *fm = [NSFileManager defaultManager];
		
		NSString *thumbnailPath = [[self thumbnailCacheDirectory] stringByAppendingPathComponent:thumbnailURLHash];
		
		if ([fm fileExistsAtPath:thumbnailPath]) {
			UIImage *image = [[UIImage alloc] initWithContentsOfFile:thumbnailPath];
			
			[[cell imageView] setImage:image];
		} else {
			dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul), ^{
				NSURL *url = [NSURL URLWithString:thumbnailURL];
				NSURLRequest *request = [NSURLRequest requestWithURL:url];
				NSURLResponse *response = nil;
				NSError *error = nil;
				
				NSData *data = [NSURLConnection sendSynchronousRequest:request
													 returningResponse:&response
																 error:&error];
				
				if (data) {
					UIImage *image = [UIImage imageWithData:data];
					
					dispatch_async(dispatch_get_main_queue(), ^{
						NSString *cellIndexPath = objc_getAssociatedObject(cell, kIndexPathKey);
						
						if ([cellIndexPath isEqualToString:indexPathString]) {
							[[cell imageView] setImage:image];
							[cell setNeedsLayout];
						}
					});
					
					[data writeToFile:thumbnailPath atomically:YES];
				}
			});
		}
	}
	
	
	return cell;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
	return [[self videos] count];
}

#pragma mark - UITableViewDelegate Protocol Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	GDataEntryYouTubeVideo *video = [[self videos] objectAtIndex:[indexPath row]];
	GDataYouTubeMediaGroup *mediaGroup = [video mediaGroup];

	DLYouTubeVideoViewController *vc = [[DLYouTubeVideoViewController alloc] initWithNibName:nil
																					  bundle:nil];
	[vc setVideoID:[mediaGroup videoID]];
	
	[[self navigationController] pushViewController:vc
										   animated:YES];
}

#pragma mark -

@end
