//
//  TradeConfirmTableViewController.h
//  Wallet
//
//  All rights reserved.
//

#import <UIKit/UIKit.h>
@class VsysAccount;

NS_ASSUME_NONNULL_BEGIN

@interface TradeConfirmTableViewController : UITableViewController

- (instancetype)initWithTradeInfo:(NSString *)tradeInfo account:(VsysAccount *)account;

- (UINavigationController *)naviVC;

@end

NS_ASSUME_NONNULL_END
