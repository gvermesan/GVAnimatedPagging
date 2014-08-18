//
//  GVAppDelegate.m
//  GVAnimatedPagging
//
//  Created by Gabriel Vermesan on 8/9/14.
//  Copyright (c) 2014 Gabriel Vermesan. All rights reserved.
//

#import "GVAppDelegate.h"
#import "GVMainViewController.h"

@implementation GVAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    GVMainViewController *mainVC = [GVMainViewController new];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:mainVC];
    self.window.rootViewController = navController;
    [self.window makeKeyAndVisible];
    return YES;
}


@end
