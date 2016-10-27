//
//  AppDelegate.m
//  OpenEyes
//
//  Created by AppleCheng on 2016/10/22.
//  Copyright © 2016年 AppleCheng. All rights reserved.
//

#import "AppDelegate.h"
#import "NiceChoiceVC.h"
#import "AuthorVC.h"
#import "DiscoveryVC.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    NiceChoiceVC * nice =[[NiceChoiceVC alloc] init];
    UINavigationController * nav =[[UINavigationController alloc] initWithRootViewController:nice];
    nav.title =@"精选";
    nav.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemFavorites tag:0];
    
    AuthorVC * author =[[AuthorVC alloc] init];
    UINavigationController * nav2 =[[UINavigationController alloc] initWithRootViewController:author];
    nav2.tabBarItem =[[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemContacts tag:1];
    
    DiscoveryVC * discovery =[[DiscoveryVC alloc] init];
    UINavigationController * nav3 =[[UINavigationController alloc] initWithRootViewController:discovery];
    nav3.tabBarItem =[[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemMostViewed tag:2];
    
    UITabBarController * tab =[[UITabBarController alloc] init];
    tab.tabBar.tintColor =[UIColor blackColor];
    tab.viewControllers =@[nav,nav3,nav2];
    
    _window.bounds = [UIScreen mainScreen].bounds;
    _window.backgroundColor =[UIColor whiteColor];
    _window.rootViewController = tab;
    [_window makeKeyAndVisible];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
