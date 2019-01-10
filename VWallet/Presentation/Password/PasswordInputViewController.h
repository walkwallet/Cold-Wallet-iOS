//
//  PasswordInputViewController.h
//  Wallet
//
//  All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PasswordInputModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PasswordInputViewController : UIViewController

- (instancetype)initWithModel:(PasswordInputModel *_Nullable)model result:(void(^ __nullable)(BOOL success))result;

@end

NS_ASSUME_NONNULL_END
