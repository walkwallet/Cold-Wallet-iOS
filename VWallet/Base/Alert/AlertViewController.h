//
//  AlertViewController.h
//  Wallet
//
//  All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AlertViewController : UIViewController

@property (nonatomic, assign) BOOL notDismiss;

- (instancetype)initWithTitle:(NSString *)title
                  secondTitle:(NSString *)secondTitle
                  contentView:(nullable void (^)(UIStackView *))configureView
                  cancelTitle:(NSString *)cancelTitle
                 confirmTitle:(NSString *)confirmTitle
                       cancel:(void(^)(void))cancel
                      confirm:(void(^)(void))confirm;

- (instancetype)initWithIconName:(NSString *)iconName
                           Title:(NSString *)title
                     secondTitle:(NSString *)secondTitle
                     contentView:(nullable void (^)(UIStackView *))configureView
                     cancelTitle:(NSString *)cancelTitle
                    confirmTitle:(NSString *)confirmTitle
                          cancel:(void(^)(void))cancel
                         confirm:(void(^)(void))confirm;
@end

NS_ASSUME_NONNULL_END
