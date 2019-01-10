//
//  UIViewController+Alert.h
//  Wallet
//
//  All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (Alert)

- (void)confirmAlertWithTitle:(NSString *_Nullable)msg
                      handler:(void (^ __nullable)(void))handler;

- (void)confirmAlertWithTitle:(NSString *_Nullable)msg
                  confirmText:(NSString *_Nullable)confirmText
                      handler:(void (^ __nullable)(void))handler;

- (void)confirmAlertWithTitle:(NSString *_Nullable)title
               confirmHandler:(void (^ __nullable)(void))confirmHandler
                cancelHandler:(void (^ __nullable)(void))cancelHandler;

- (void)confirmAlertWithTitle:(NSString *_Nullable)title
                      message:(NSString *_Nullable)message
                  confirmText:(NSString *_Nullable)comfirmText
                   cancelText:(NSString *_Nullable)cancelText
               confirmHandler:(void (^ __nullable)(void))confirmHandler
                cancelHandler:(void (^ __nullable)(void))cancelHandler;

- (void)alertWithTitle:(NSString *_Nullable)title
           confirmText:(NSString *_Nullable)confirmText;

- (void)alertWithTitle:(NSString *_Nullable)title
           confirmText:(NSString *_Nullable)confirmText
               handler:(void (^ __nullable)(void))handler;

- (void)alertWithTitle:(NSString *_Nullable)title
               message:(NSString *_Nullable)message
           confirmText:(NSString *_Nullable)confirmText
               handler:(void (^ _Nullable)(void))handler;
@end

NS_ASSUME_NONNULL_END
