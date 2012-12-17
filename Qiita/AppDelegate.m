//
//  AppDelegate.m
//  Qiita
//
//  Created by yusuke_yasuo on 2012/10/13.
//  Copyright (c) 2012年 yusuke_yasuo. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "StockViewController.h"
#import "PostViewController.h"
#import "SearchViewController.h"
#import "TagViewController.h"
#import "SaveToken.h"
#import "FollowingTag.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.

    UIViewController *viewController0 = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
    UINavigationController *navController0 = [[UINavigationController alloc] initWithRootViewController:viewController0];
    navController0.navigationBar.tintColor = [UIColor colorWithRed:0.392 green:0.788 blue:0.078 alpha:1];
    
    UIViewController *viewController1 = [[StockViewController alloc] initWithNibName:@"StockViewController" bundle:nil];
    UINavigationController *navController1 = [[UINavigationController alloc] initWithRootViewController:viewController1];
    navController1.navigationBar.tintColor = [UIColor colorWithRed:0.392 green:0.788 blue:0.078 alpha:1];
    
    UIViewController *viewController2 = [[SearchViewController alloc] initWithNibName:@"SearchViewController" bundle:nil];
    UINavigationController *navController2 = [[UINavigationController alloc] initWithRootViewController:viewController2];
    navController2.navigationBar.tintColor = [UIColor colorWithRed:0.392 green:0.788 blue:0.078 alpha:1];

    UIViewController *viewController3 = [[TagViewController alloc] initWithNibName:@"TagViewController" bundle:nil];
    UINavigationController *navController3 = [[UINavigationController alloc] initWithRootViewController:viewController3];
    navController3.navigationBar.tintColor = [UIColor colorWithRed:0.392 green:0.788 blue:0.078 alpha:1];
    
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.viewControllers = @[navController0, navController1, navController2, navController3];
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [[SaveToken sharedManager] load];
    [[FollowingTag sharedManager] load];
    if ([SaveToken sharedManager].current_token != nil) {
        [[FollowingTag sharedManager] update_tags:nil];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/

@end
