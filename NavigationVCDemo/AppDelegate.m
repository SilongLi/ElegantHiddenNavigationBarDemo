//
//  AppDelegate.m
//  NavigationVCDemo
//
//  Created by lisilong on 2018/11/13.
//  Copyright © 2018 lisilong. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    static NSString *identifier = @"RootViewController";
    ViewController *root = [self loadStoryBoardViewControllerWhithIdentifier:identifier];
    UINavigationController *NAV = [[UINavigationController alloc] initWithRootViewController:root];
    
    [self.window setRootViewController:NAV];
    [self.window makeKeyWindow];
    [self.window makeKeyAndVisible];
    
    return YES;
}
    
- (id)loadStoryBoardViewControllerWhithIdentifier:(NSString *)identifier {
    return [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:identifier];
}

 


@end
