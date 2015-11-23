//
//  AppDelegate.m
//  SunnyAnalytics
//
//  Created by jiazhaoyang on 15/7/24.
//  Copyright © 2015年 gitpark. All rights reserved.
//

#import "AppDelegate.h"
#import "SAAnalytics.h"
#import "DCacheHelper.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self pushAnalytics];
    return YES;
}

#pragma mark - 上传统计信息策略
-(void)pushAnalytics{
    [SAAnalytics initSAAnalytics:@"http://172.16.30.15:8080/actionDetail/" reportPolicy:SAEVERYDAY channelId:@"AppStore"];
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"firstStart"]) {
        [SAAnalytics doEvent:app_init objectId:nil params:nil];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

/**
 *  type=1,按启动时发送，type=2,按间隔发送, value值为时间间隔，秒为单位，type=3,退出时发送
 *
 *  @param application
 */
- (void)applicationWillTerminate:(UIApplication *)application {
    NSString *strEvent = [DCacheHelper getCacehObj].sEventStrategy;
    if ([ strEvent isEqualToString:@"1,3"] || [strEvent isEqualToString:@"3"]) {
        [[SAAnalytics shareInstance] postDataThread];
    }
}

@end
