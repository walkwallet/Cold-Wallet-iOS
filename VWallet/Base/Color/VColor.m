//
//  Color.m
//  Wallet
//
//  All rights reserved.
//

#import "VColor.h"
#import "UIColor+Hex.h"

@implementation VColor

+ (UIColor *)tabbarBgColor {
    return [UIColor colorWithHex:0x1E1E24];
}

+ (UIColor *)tabbarTintColor {
    return [UIColor colorWithHex:0xFFFFFF];
}

+ (UIColor *)navigationBgColor {
    return [UIColor colorWithHex:0x1E1E24];
}

+ (UIColor *)navigationTintColor {
    return [UIColor colorWithHex:0x81818A];
}

+ (UIColor *)rootViewBgColor {
    return [UIColor colorWithHex:0x1E1E24];
}

+ (UIColor *)viewBgColor {
    return [UIColor colorWithHex:0x2B2B33];
}

+ (UIColor *)textColor {
    return [UIColor colorWithHex:0xFFFFFF];
}

+ (UIColor *)textSecondColor {
    return [UIColor colorWithHex:0x81818A];
}

+ (UIColor *)placeholderColor {
//    return [UIColor colorWithHex:0x81818A];
    return [UIColor colorWithHex:0x4B4B52];
}

+ (UIColor *)separatorColor {
    return [UIColor colorWithHex:0x36363D];
}

+ (UIColor *)borderColor {
    return [UIColor colorWithHex:0x36363D];
}

+ (UIColor *)orangeColor {
    return [UIColor colorWithHex:0xFF8737];
}

+ (UIColor *)redColor {
    return [UIColor colorWithHex:0xD13245];
}

+ (UIColor *)greenColor {
    return [UIColor colorWithHex:0x23A28C];
}

+ (UIColor *)grayColor {
    return [UIColor colorWithHex:0x81818A];
}

@end
