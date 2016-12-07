//
//  AppDelegate.m
//  YCD
//
//  Created by dayu on 2016/11/21.
//  Copyright © 2016年 dayu. All rights reserved.
//

#import "AppDelegate.h"
#import "UserGuideViewController.h"
#import "LoginNC.h"
#import "RootTabBarController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    UIBarButtonItem *buttonItem = [UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil];
    [buttonItem setBackButtonTitlePositionAdjustment:UIOffsetMake(-1000, 0) forBarMetrics:UIBarMetricsDefault];
//    UIImage *backImage = [UIImage imageNamed:@"back"];
//    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:[backImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, backImage.size.width, 0, 0)]forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
//    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(-233, 0) forBarMetrics:UIBarMetricsDefault];
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isNightMode"]==YES) {
        [[DKNightVersionManager sharedManager] nightFalling];
        [UINavigationBar appearance].titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
        [UITableView appearance].sectionIndexColor = [UIColor whiteColor];
    }else{
        [[DKNightVersionManager sharedManager] dawnComing];
        [UINavigationBar appearance].titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor blackColor] forKey:NSForegroundColorAttributeName];
        [UITableView appearance].sectionIndexColor = [UIColor darkGrayColor];
    }
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: [NSBundle mainBundle]];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    //判断是不是第一次启动应用
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]){
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
        //第一次启动,使用UserGuideViewController (用户引导页面) 作为根视图
        self.window.rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"userGuide"];
    } else {
        //不是第一次启动
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"login"] == YES) { //登录了
            self.window.rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"root"];
        }else{ //未登录
            self.window.rootViewController = [storyboard instantiateViewControllerWithIdentifier:@"login"];
        }
    }
    [self.window makeKeyAndVisible];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.aaaaa
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
