//
//  UIView+Loading.m
//  Wallet
//
//  All rights reserved.
//

#import "UIView+Loading.h"

@implementation LoadingView

- (instancetype)init {
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, 64.f, 64.f);
        self.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.7f];
        self.layer.cornerRadius = 6.f;
        
        UIImageView *imgview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 36.f, 36.f)];
        imgview.center = self.center;
        imgview.image = [UIImage imageNamed:@"ico_loading"];
        CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI * 2];
        rotationAnimation.duration = 0.7f;
        rotationAnimation.cumulative = YES;
        rotationAnimation.repeatCount = INFINITY;
        [imgview.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
        [self addSubview:imgview];
    }
    return self;
}

@end

@implementation UIView (Loading)

- (void)startLoading {
    LoadingView *loadingView = [self loadingView];
    if (loadingView) return;
    loadingView = [[LoadingView alloc] init];
    loadingView.center = CGPointMake(CGRectGetWidth(self.bounds) * 0.5, CGRectGetHeight(self.bounds) * 0.5);
    [self addSubview:loadingView];
}

- (void)stopLoading {
    LoadingView *loadingView = [self loadingView];
    if (!loadingView) return;
    [loadingView removeFromSuperview];
}

- (LoadingView *)loadingView {
    for (UIView *subV in self.subviews) {
        if ([subV isMemberOfClass:LoadingView.class]) {
            return (LoadingView *)subV;
        }
    }
    return nil;
}

@end
