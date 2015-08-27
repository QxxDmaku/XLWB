//
//  AppDelegate.m
//  新浪微博
//
//  Created by qsx on 15-7-27.
//  Copyright (c) 2015年 qsx_one. All rights reserved.
//

#import "AppDelegate.h"
#import <CoreData/CoreData.h>
#import "WBMianViewController.h"
#import "NewFeatureViewController.h"
#import "WBOAuthViewController.h"
#import "WBAccountModule.h"
#import "WBAccountTools.h"
#import "SDWebImageManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //1、创建窗口
    self.window = [[UIWindow alloc] init];
    self.window.frame = [UIScreen mainScreen].bounds;
    
    //2、设置根控制器
   
    WBAccountModule* account = [WBAccountTools account];
    
    //先从沙河中取出登陆的信息，
    if (account) {
        
            //2.0 取出上一次沙盒中的版本号
            NSString* lastVersion = [[NSUserDefaults standardUserDefaults] objectForKey:@"MyCFBundleVersion"];
        
            //2.1得到当前app的 版本号
            //NSDictionary* info = [NSBundle mainBundle].infoDictionary;
            //NSLog(@"%@ " , info);
            NSString* currentVersion = [NSBundle mainBundle].infoDictionary[@"CFBundleVersion"];
        
            if ([currentVersion isEqualToString:lastVersion]) {//和上一次打开的一样
                self.window.rootViewController = [[WBMianViewController alloc] init];
            }else{
                
                self.window.rootViewController =[[NewFeatureViewController alloc] init];
        
                //2.2版本号存进沙盒 ， 版本号是新的时候才存进 沙盒
                [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:@"MyCFBundleVersion"];
                [[NSUserDefaults standardUserDefaults] synchronize];//马上存进去
                
            }
    }else{
        //登陆成功后的代码中 跳转到 WBMianViewController 中
               self.window.rootViewController = [[WBOAuthViewController alloc]init];
    
    }

    
    //第二种方法来设置子控制器
    //tabbarVc.viewControllers = @[vc1,vc2,vc3,vc4];
   
    //4、显示窗口
    [self.window  makeKeyAndVisible];
    //上面代码的底层实现
    //1. application.keyWindow  =  self.window
    //2. self.window.hidden = NO;
    
    
    //打印出沙盒中的位置
    //NSLog(@"resourcePath is %@", [[NSBundle mainBundle]resourcePath]);
    NSLog(@"NSHomeDirectory is %@", NSHomeDirectory());
    
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
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}



#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.qsx.ios.____" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"____" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"____.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end

////3、   设置子控制器
//
//UIViewController*  vc1 = [[UIViewController alloc] init];
//vc1.view.backgroundColor = [UIColor redColor];
//vc1.tabBarItem.title = @"首页";
////3.1  设置图片的样式 系统用默认的时候在选中的时候是蓝色的
//vc1.tabBarItem.image = [UIImage imageNamed:@"tabbar_home"];
////3.2   默认的时候传到selectimage 中的图会自动的渲染成蓝色的
////vc1.tabBarItem.selectedImage = [UIImage imageNamed:@"tabbar_home_selected"];
////3.3   a.首先得到这个图片  b.然后再设置图片的渲染时候的模式
////3.4   设置图片选中之后的样子
//vc1.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabbar_home_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
////3.5   设置文字的样式
////未选中的时候的样式
//NSMutableDictionary* textAttrs = [NSMutableDictionary dictionary];
//textAttrs[NSForegroundColorAttributeName] = [UIColor blackColor];
//[vc1.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
////选中之后的样式
//NSMutableDictionary* selectTextAttrs = [NSMutableDictionary dictionary];
//selectTextAttrs[NSForegroundColorAttributeName] = [UIColor orangeColor];
//[vc1.tabBarItem setTitleTextAttributes:selectTextAttrs forState:UIControlStateSelected];
//
//
//UIViewController*  vc2 = [[UIViewController alloc] init];
//vc2.view.backgroundColor = [UIColor grayColor];
//vc2.tabBarItem.title = @"消息";
//vc2.tabBarItem.image = [UIImage imageNamed:@"tabbar_message_center"];
//vc2.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabbar_message_center_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
////3.5   设置文字的样式
////未选中的时候的样式
//[vc2.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
////选中之后的样式
//selectTextAttrs[NSForegroundColorAttributeName] = [UIColor orangeColor];
//[vc2.tabBarItem setTitleTextAttributes:selectTextAttrs forState:UIControlStateSelected];
//
//UIViewController*  vc3 = [[UIViewController alloc] init];
//vc3.view.backgroundColor =  [UIColor purpleColor];
//vc3.tabBarItem.title = @"发现";
//vc3.tabBarItem.image = [UIImage imageNamed:@"tabbar_discover"];
//vc3.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabbar_discover_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
////3.5   设置文字的样式
////未选中的时候的样式
//[vc3.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
////选中之后的样式
//selectTextAttrs[NSForegroundColorAttributeName] = [UIColor orangeColor];
//[vc3.tabBarItem setTitleTextAttributes:selectTextAttrs forState:UIControlStateSelected];
//
//UIViewController*  vc4 = [[UIViewController alloc] init];
//vc4.view.backgroundColor = [UIColor whiteColor];
//vc4.tabBarItem.title = @"我";
//vc4.tabBarItem.image = [UIImage imageNamed:@"tabbar_profile"];
//vc4.tabBarItem.selectedImage = [[UIImage imageNamed:@"tabbar_profile_selected"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
////3.5   设置文字的样式
////未选中的时候的样式
//[vc4.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
////选中之后的样式
//selectTextAttrs[NSForegroundColorAttributeName] = [UIColor orangeColor];
//[vc4.tabBarItem setTitleTextAttributes:selectTextAttrs forState:UIControlStateSelected];
////tabbarVc.viewControllers = @[vc1,vc2,vc3,vc4];

