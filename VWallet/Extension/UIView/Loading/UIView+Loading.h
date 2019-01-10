//
//  UIView+Loading.h
//  Wallet
//
//  All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LoadingView : UIView
@end

@interface UIView (Loading)

- (void)startLoading;

- (void)stopLoading;

@end

NS_ASSUME_NONNULL_END
