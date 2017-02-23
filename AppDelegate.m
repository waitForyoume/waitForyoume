//
//  AppDelegate.m
//  熊猫
//
//  Created by wait_foryou on 16/1/28.
//  Copyright © 2016年 wait_foryou. All rights reserved.
//

#import "AppDelegate.h"
#import "BaseTabBarController.h"
#import "AFNetworking.h"
#import "StartLaunchViewController.h"


@interface AppDelegate ()

@end

@implementation AppDelegate

// 程序启动之后执行, 只有在第一次程序启动后才执行, 以后不再执行
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.isNetwork = YES;
    [self checkNetwork]; // 检查网络
    
    // 用户索引项, 存储用户信息, 程序是否第一次启动
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (![userDefaults boolForKey:@"FirstLanch"]) {
        
        // 把标识符存到本地
        [userDefaults setBool:YES forKey:@"FirstLanch"];
        // 立即同步
        [userDefaults synchronize];
        // 创建视图控制器
        StartLaunchViewController *guideImgVC = [[StartLaunchViewController alloc] init];
        self.window.rootViewController = guideImgVC;
        
    } else {
        
        self.window.rootViewController = [[BaseTabBarController alloc] init];
    }
    
    // 获取程序的Home目录
    NSString *homeDirectory = NSHomeDirectory();
    NSLog(@"获取程序的Home目录 : %@", homeDirectory);
    
    // 获取document目录
    NSArray *pathsDocument = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *pathDocument = [pathsDocument objectAtIndex:0];
    NSLog(@"获取document目录 : %@", pathDocument);
    
    // 获取Cache目录
    NSArray *pathsCache = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *pathCache = [pathsCache objectAtIndex:0];
    NSLog(@"获取Cache目录 : %@", pathCache);
    
    // 获取Library目录
    NSArray *pathsLibrary = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *pathLibrary = [pathsLibrary objectAtIndex:0];
    NSLog(@"%@", pathLibrary);
    
    // 获取Tmp目录
    NSString *tmpDir = NSTemporaryDirectory();
    NSLog(@"获取Tmp目录 : %@", tmpDir);
    
    // 写入文件
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *docDir = [paths objectAtIndex:0];
//    if (!docDir) {
//        NSLog(@"Documents 目录未找到");
//    }
//    NSArray *array = [[NSArray alloc] initWithObjects:@"内容", @"content", nil];
//    NSString *filePath = [docDir stringByAppendingPathComponent:@"testFile.txt"];
//    [array writeToFile:filePath atomically:YES];
    
    // 读取文件
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *docDir = [paths objectAtIndex:0];
//    NSString *filePath = [docDir stringByAppendingPathComponent:@"testFile.txt"];
//    NSArray *array = [[NSArray alloc]initWithContentsOfFile:filePath];
//    NSLog(@"%@", array);
    
    NSLog(@" [self getDeviceId]%@", [self uuid]);
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (NSString*)uuid {
    CFUUIDRef uuid = CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString( nil, uuid );
    NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
    CFRelease(uuid);
    CFRelease(uuidString);
    return result;
}

- (NSString *)getDeviceId {
    NSString *currentDeviceUUIDStr;
    NSUUID * currentDeviceUUID  = [UIDevice currentDevice].identifierForVendor;
    currentDeviceUUIDStr = currentDeviceUUID.UUIDString;
    currentDeviceUUIDStr = [currentDeviceUUIDStr stringByReplacingOccurrencesOfString:@"-" withString:@""];
    currentDeviceUUIDStr = [currentDeviceUUIDStr lowercaseString];
    return currentDeviceUUIDStr;
}

#pragma mark - 检查网络

- (void)checkNetwork {
    // 准备一个测试网络的地址
    NSURL *url = [NSURL URLWithString:@"http://www.apple.com"];
    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
    [manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusReachableViaWiFi:
            {
                NSLog(@"有网络...");
                self.isNetwork = YES;
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
            {
                self.isNetwork = YES;
            }
                break;
            case AFNetworkReachabilityStatusNotReachable:
            {
                NSLog(@"无网络...");
                self.isNetwork = NO;
            }
                break;
            default:
                break;
        }
    }];
    
    // 开始监控
    [manager.reachabilityManager startMonitoring];
}

// 程序将要被激活时(获得焦点)执行, 程序激活用户才能操作
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

// 程序进入后台执行, 注意进入后台先失去焦点再进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

// 程序将要进入前台时执行
- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

// 程序被激活(获得焦点)后执行, 注意程序被激活时会先进入前台再被激活
- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

// 程序在终止时执行, 包括正常终止或异常终止, 例如说一个应用程序在后台运行,(例如播放软件, 社交软件等)占用太多内存这时会意外终止调用此方法
- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
