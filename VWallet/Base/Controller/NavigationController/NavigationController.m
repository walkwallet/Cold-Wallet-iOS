//
//  NavigationController.m
//  Wallet
//
//  All rights reserved.
//

#import "NavigationController.h"

#import "UIImage+Color.h"
#import "VColor.h"

@interface NavigationController () <UIGestureRecognizerDelegate>

@end

@implementation NavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationBar];
}

- (void)setupNavigationBar {
    self.view.backgroundColor = VColor.navigationBgColor;
    self.navigationBar.translucent = NO;
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : VColor.textColor};
    self.navigationBar.tintColor = VColor.navigationTintColor;
    self.navigationBar.shadowImage = UIImage.new;
    self.navigationBar.backgroundColor = VColor.navigationBgColor;
    [self.navigationBar setBackgroundImage:[UIImage imageWithColor:VColor.navigationBgColor] forBarMetrics:UIBarMetricsDefault];
    if (@available(iOS 11.0, *)) {
        self.navigationBar.prefersLargeTitles = YES;
        self.navigationBar.largeTitleTextAttributes = @{NSForegroundColorAttributeName : VColor.textColor};
    }
    
    [UINavigationBar appearance].backIndicatorTransitionMaskImage = [UIImage imageNamed:@"ico_navi_back"];
    [UINavigationBar appearance].backIndicatorImage = [UIImage imageNamed:@"ico_navi_back"];
    
    [[UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[self.class]]
     setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16.f], NSForegroundColorAttributeName : VColor.orangeColor}
     forState:UIControlStateNormal];
    [[UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[self.class]]
     setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16.f], NSForegroundColorAttributeName : VColor.orangeColor}
     forState:UIControlStateHighlighted];
    [[UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[self.class]]
     setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16.f], NSForegroundColorAttributeName : VColor.textSecondColor}
     forState:UIControlStateDisabled];
    
    self.interactivePopGestureRecognizer.delegate = self;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    viewController.hidesBottomBarWhenPushed = self.viewControllers.count;
    self.viewControllers.lastObject.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    [super pushViewController:viewController animated:animated];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return [self.viewControllers count] > 1;
}

@end
