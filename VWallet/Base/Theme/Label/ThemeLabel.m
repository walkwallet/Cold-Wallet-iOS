//
//  ThemeLabel.m
//  Wallet
//
//  All rights reserved.
//

#import "ThemeLabel.h"

#import "VColor.h"

@implementation ThemeLabel

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self themeInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self themeInit];
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        [self themeInit];
    }
    return self;
}

- (void)themeInit {
    self.secondTheme = _secondTheme;
}

- (void)setSecondTheme:(BOOL)secondTheme {
    _secondTheme = secondTheme;
    self.textColor = _secondTheme ? VColor.textSecondColor : VColor.textColor;
}

@end
