//
//  AppDelegate.h
//  JYDS
//
//  Created by dayu on 2016/11/21.
//  Copyright © 2016年 dayu. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <AFNetworkReachabilityManager.h>
@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
@property (assign, nonatomic) BOOL isReachable;
@end
