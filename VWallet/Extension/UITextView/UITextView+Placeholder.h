//
//  UITextView+Placeholder.h
//  Wallet
//
//  All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextView (Placeholder) <UITextViewDelegate>

@property (nonatomic, copy) NSString *placeholder;

@property (nonatomic, weak) UILabel *placeholderLabel;

- (void)updatePlaceholderState;

@end

NS_ASSUME_NONNULL_END
