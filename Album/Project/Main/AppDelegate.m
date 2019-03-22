//
//  AppDelegate.m
//  Album
//
//  Created by Marshal on 2017/10/11.
//  Copyright © 2017年 Marshal. All rights reserved.
//

#import "AppDelegate.h"
#import "QYLMainController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self initOthers];
    [self initWindows];
    return YES;
}

- (void)initWindows {
    _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _window.backgroundColor = [UIColor whiteColor];
    [_window makeKeyAndVisible];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:[[QYLMainController alloc] init]];
    nc.navigationBar.barStyle = UIBarStyleBlack;
    nc.navigationBar.backgroundColor = [UIColor blackColor];//需要两个一起设定，不然不黑
    _window.rootViewController = nc;
}

#pragma mark --initOthers
- (void)initOthers {
    if (SCREEN_HEIGHT == 812) {
        topHeight = 88;
        bottomHeight = 83;
    }else {
        topHeight = 64;
        bottomHeight = 49;
    }
}

//强制所有界面竖屏
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
        return UIInterfaceOrientationMaskPortrait;
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
