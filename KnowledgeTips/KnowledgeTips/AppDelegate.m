//
//  AppDelegate.m
//  KnowledgeTips
//
//  Created by 葛聪颖 on 2020/4/22.
//  Copyright © 2020 葛聪颖. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "NetworkViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    NetworkViewController *ctrl = [NetworkViewController new];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:ctrl];
    self.window.rootViewController = nav;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    return YES;
}


@end
