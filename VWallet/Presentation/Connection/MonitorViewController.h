//
//  MonitorTableViewController.h
//  Wallet
//
//  All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MonitorViewController : UIViewController

- (void)redetectionCallback:(void(^)(void))callback;

@end

NS_ASSUME_NONNULL_END
