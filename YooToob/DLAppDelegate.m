//
//  DLAppDelegate.m
//  YooToob
//
//  Created by Jeffrey Kelley on 12/7/11.
//  Copyright (c) 2011 Detroit Labs. All rights reserved.
//

#import "DLAppDelegate.h"

#import "DLPlaylistListViewController.h"

@implementation DLAppDelegate

@synthesize window = _window;
@synthesize navigationController = _navigationController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self setWindow:[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]]];

	DLPlaylistListViewController *vc = [[DLPlaylistListViewController alloc] initWithNibName:nil
																					  bundle:nil];
	
	[self setNavigationController:[[UINavigationController alloc] initWithRootViewController:vc]];
	[[self window] setRootViewController:[self navigationController]];
    [[self window] makeKeyAndVisible];
	
    return YES;
}

@end
