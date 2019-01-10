//
//  AppDelegate.m
//  Wallet
//
//  All rights reserved.
//

#import "AppDelegate.h"
#import "AppState.h"
#import "TouchIDTool.h"
#import "DeviceState.h"
#import "VStoryboard.h"
#import "DeviceState.h"
#import "WalletMgr.h"
#import "AppDelegate+DismissKeyboard.h"
#import "MonitorViewController.h"
#import "PasswordInputViewController.h"
#import "Language.h"
#import "PasswordInputModel.h"
#import "WindowManager.h"
#import "MonitorViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.    
    [self enableAutoDismissKeyboard];

    [[DeviceState shareInstance] startBluetoothMonitor];
    
    UIApplication.sharedApplication.statusBarStyle = UIStatusBarStyleLightContent;
    _window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    [_window makeKeyAndVisible];
    
    if (AppState.shareInstance.hasWallet) {
        PasswordInputModel *model = [[PasswordInputModel alloc] init];
        model.title = VLocalize(@"launch_page_title");
        model.titleDetail = VLocalize(@"password_auth_title_detail");
        PasswordInputViewController *pwdInputVC = [[PasswordInputViewController alloc] initWithModel:model result:nil];
        _window.rootViewController = pwdInputVC;
    } else {
        _window.rootViewController = [VStoryboard.Generate instantiateInitialViewController];
    }
    
    if ([AppState shareInstance].connectionCheckEnable) {
        [self checkConnection: self.window];
    }
    
    sleep(1.f);
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
    if ([AppState shareInstance].connectionCheckEnable) {
        [self checkConnection:self.window];
    } else {
        [self checkPassword: self.window];
    }
}

- (void)checkConnection:(UIWindow *)currentWindow {
    NSLog(@"start connection check");
    __weak typeof(self) weakself = self;
    if ([weakself.window.rootViewController isMemberOfClass:MonitorViewController.class]) {
        return;
    }
    if ([DeviceState shareInstance].wifiEnable || [DeviceState shareInstance].bluetoothEnable || [DeviceState shareInstance].cellularEnable) {
        MonitorViewController *vc = [[UIStoryboard storyboardWithName:@"Connection" bundle:nil] instantiateInitialViewController];
        [vc redetectionCallback:^{
            if (![DeviceState shareInstance].wifiEnable && ![DeviceState shareInstance].bluetoothEnable && ![DeviceState shareInstance].cellularEnable) {
                weakself.window = currentWindow;
                [weakself.window makeKeyAndVisible];
                [weakself checkPassword: currentWindow];
            }
        }];
        UIWindow *window = [[UIWindow alloc] init];
        window.rootViewController = vc;
        self.window = window;
        [window makeKeyAndVisible];
    } else {
        [self checkPassword: currentWindow];
    }
}

- (void)checkPassword:(UIWindow *)currentWindow {
    __weak typeof(self) weakself = self;
    if (AppState.shareInstance.hasWallet) {
        if ([self.window.rootViewController isMemberOfClass:PasswordInputViewController.class]) {
            return;
        }
        PasswordInputModel *model = [[PasswordInputModel alloc] init];
        model.title = VLocalize(@"launch_page_title");
        model.titleDetail = VLocalize(@"password_auth_title_detail");
        PasswordInputViewController *vc = [[PasswordInputViewController alloc] initWithModel:model result:^(BOOL success) {
            if (success) {
                weakself.window = currentWindow;
                [weakself.window makeKeyAndVisible];
            }
        }];
        UIWindow *window = [[UIWindow alloc] init];
        window.rootViewController = vc;
        self.window = window;
        [window makeKeyAndVisible];
    }
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)application:(UIApplication *)application shouldAllowExtensionPointIdentifier:(UIApplicationExtensionPointIdentifier)extensionPointIdentifier {
    if ([extensionPointIdentifier isEqualToString:@"com.apple.keyboard-service"]) {
        return NO;
    }
    return YES;
}


@end
