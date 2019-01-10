//
//  TradeVerifyQRPreviewViewController.h
//  Wallet
//
//  All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TradeVerifyQRPreviewViewController : UIViewController

- (instancetype)initWithTitle:(NSString *)title
                         desc:(NSString *)desc
                    qrCodeStr:(NSString *)qrCodeStr
                     complete:(void(^)(void))complete;

@end

NS_ASSUME_NONNULL_END
