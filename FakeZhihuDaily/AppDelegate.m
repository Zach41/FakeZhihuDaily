//
//  AppDelegate.m
//  FakeZhihuDaily
//
//  Created by ZachZhang on 15/11/28.
//  Copyright © 2015年 ZachZhang. All rights reserved.
//

#import <MMDrawerController.h>
#import <SVProgressHUD.h>
#import <SDWebImage/SDWebImageManager.h>
#import <SDWebImageDownloader.h>


#import "AppDelegate.h"
#import "MainController.h"
#import "ThemeMenuController.h"
#import "ZhihuClient.h"
#import "Constants.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self getLaunchImage];
    
    return YES;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self setupProgressHUD];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    MainController *main = [[MainController alloc] initWithStyle:UITableViewStylePlain];
    UINavigationController *mainNav = [[UINavigationController alloc] initWithRootViewController:main];
    
    ThemeMenuController *menuController = [[ThemeMenuController alloc] init];
    
    MMDrawerController *rootViewController = [[MMDrawerController alloc] initWithCenterViewController:mainNav leftDrawerViewController:menuController];
    
    [rootViewController setShowsShadow:NO];
    [rootViewController setMaximumLeftDrawerWidth:220.f];
    [rootViewController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [rootViewController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    rootViewController.shouldStretchDrawer = NO;

    self.window.rootViewController = rootViewController;
    
    [self.window makeKeyAndVisible];
    return YES;
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

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)setupProgressHUD {
    [SVProgressHUD setBackgroundColor:[UIColor clearColor]];
}

- (void)getLaunchImage {
    ZhihuClient *sharedClient = [ZhihuClient sharedClient];
    [sharedClient getWithURL:kLaunchImage1080_1776
                  parameters:nil
                     success:^(AFHTTPRequestOperation *operation, id responseObject) {
                         NSString *imageText = responseObject[@"text"];
                         NSString *imageURLString = responseObject[@"img"];
                         
                         SDWebImageManager *sharedWebManager = [SDWebImageManager sharedManager];
                         SDWebImageDownloader *downloader = [sharedWebManager imageDownloader];
                         
                         [downloader downloadImageWithURL:[NSURL URLWithString:imageURLString]
                                                  options:SDWebImageDownloaderHighPriority
                                                 progress:nil
                                                completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
                                                    [[sharedWebManager imageCache] storeImage:image forKey:kLaunchImage1080_1776];
                                                    [[NSUserDefaults standardUserDefaults] setObject:imageText forKey:kLaunchTextKey];
                                                    [[NSUserDefaults standardUserDefaults] synchronize];
                                                }];
                         
                     }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                         NSLog(@"Error : %@", error);
                     }];
}

@end
