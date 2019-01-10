//
//  TabBarController.m
//  Wallet
//
//  All rights reserved.
//

#import "TabBarController.h"

#import "Language.h"
#import "VColor.h"
#import "UIImage+Color.h"

@interface TabBarController ()

@end

@implementation TabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTabBar];
}

- (void)setupTabBar {
    self.tabBar.translucent = NO;
    self.tabBar.tintColor = VColor.tabbarTintColor;
    self.tabBar.shadowImage = UIImage.new;
    self.tabBar.backgroundImage = [UIImage imageWithColor:VColor.tabbarBgColor];
//    self.tabBar.barTintColor = VColor.tabbarBgColor;
//    self.tabBar.backgroundColor = VColor.tabbarBgColor;
    self.tabBar.layer.shadowColor = UIColor.blackColor.CGColor;
    self.tabBar.layer.shadowOffset = CGSizeMake(0, -4.f);
    self.tabBar.layer.shadowRadius = 12.f;
    self.tabBar.layer.shadowOpacity = 0.1f;
    
    for (int i = 0; i < self.viewControllers.count ; i++) {
        UITabBarItem *item = [self.viewControllers[i] tabBarItem];
        [item setTitlePositionAdjustment:UIOffsetMake(0, -3)];
        NSString *key = [NSString stringWithFormat:@"tabbar_name_%d", i];
        [item setTitle:VLocalize(key)];
    }
}

@end
