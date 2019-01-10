//
//  ThemeTextField.m
//  Wallet
//
//  All rights reserved.
//

#import "ThemeTextField.h"

#import "VColor.h"

@implementation ThemeTextField

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
    self.textColor = VColor.textColor;
    self.tintColor = VColor.textColor;
    self.keyboardAppearance = UIKeyboardAppearanceDark;
}

- (void)setPlaceholder:(NSString *)placeholder {
    [super setPlaceholder:placeholder];
    if (placeholder.length) {
        self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholder
                                                                     attributes:@{NSFontAttributeName : self.font,
                                                                                  NSForegroundColorAttributeName : VColor.placeholderColor}];;
    }
}

@end
