//
//  UIViewController+Alert.m
//  Wallet
//
//  All rights reserved.
//

#import "UIViewController+Alert.h"
#import "Language.h"
#import "VColor.h"
#import "UIColor+Hex.h"

@implementation UIViewController (Alert)

- (NSAttributedString *)getAttredString:(NSString *)str {
    NSMutableAttributedString *alertControllerMessageStr = [[NSMutableAttributedString alloc] initWithString:str?:@"" attributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0x363647]}];
    return alertControllerMessageStr;
}

- (void)confirmAlertWithTitle:(NSString *_Nullable)msg
                      handler:(void (^ __nullable)(void))handler {
    return [self confirmAlertWithTitle:msg confirmText:@"" handler:handler];
}

- (void)confirmAlertWithTitle:(NSString *_Nullable)msg
                  confirmText:(NSString *)confirmText
                      handler:(void (^ __nullable)(void))handler {
    return [self confirmAlertWithTitle:nil message:msg confirmText:confirmText handler:handler];
}

- (void)confirmAlertWithTitle:(NSString *_Nullable)title
                      message:(NSString *_Nullable)message
                  confirmText:(NSString *_Nullable)confirmText
                      handler:(void (^ __nullable)(void))handler {
    [self confirmAlertWithTitle:title message:message confirmText:confirmText cancelText:nil confirmHandler:handler cancelHandler:nil];
}

- (void)confirmAlertWithTitle:(NSString *)title
                      message:(NSString *)msg
                  confirmText:(NSString *)confirmText
                   cancelText:(NSString *)cancelText
               confirmHandler:(void (^)(void))confirmHandler
                cancelHandler:(void (^)(void))cancelHandler {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    if ([title length] > 0) {
        NSAttributedString *attr = [[NSAttributedString alloc] initWithString:title attributes:@{
                                                                                              NSForegroundColorAttributeName:[UIColor blackColor],
                                                                                              NSFontAttributeName: [UIFont systemFontOfSize:18]
                                                                                              }];
        [alert setValue:attr forKey:@"attributedTitle"];
    }
    if ([msg length] > 0) {
        NSAttributedString *attr = [[NSAttributedString alloc] initWithString:msg attributes:@{
                                                                                                 NSForegroundColorAttributeName:[UIColor colorWithHex:0x363647],
                                                                                                 NSFontAttributeName: [UIFont systemFontOfSize:14]
                                                                                                 }];
        [alert setValue:attr forKey:@"attributedMessage"];
    }
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:(cancelText?:VLocalize(@"cancel")) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (cancelHandler) {
            cancelHandler();
        }
    }];
    [alert addAction:action1];
    [action1 setValue:VColor.textSecondColor forKey:@"_titleTextColor"];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:(confirmText?:VLocalize(@"confirm")) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (confirmHandler) {
            confirmHandler();
        }
    }];
    [action setValue:VColor.orangeColor forKey:@"_titleTextColor"];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)confirmAlertWithTitle:(NSString *)title
               confirmHandler:(void (^)(void))confirmHandler
                cancelHandler:(void (^)(void))cancelHandler {
    [self confirmAlertWithTitle:title message:nil confirmText:nil cancelText:nil confirmHandler:confirmHandler cancelHandler:cancelHandler];
}

- (void)alertWithTitle:(NSString *)title confirmText:(NSString *)confirmText {
    [self alertWithTitle:title message:nil confirmText:confirmText handler:nil];
}

- (void)alertWithTitle:(NSString *)title confirmText:(NSString *)confirmText handler:(void (^ _Nullable)(void))handler {
    [self alertWithTitle:title message:nil confirmText:confirmText handler:handler];
}

- (void)alertWithTitle:(NSString *)title message:(NSString *)message confirmText:(NSString *)confirmText handler:(void (^ _Nullable)(void))handler {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:confirmText?:VLocalize(@"confirm") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (handler) {
            handler();
        }
    }];
    [action setValue:VColor.orangeColor forKey:@"_titleTextColor"];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

@end
