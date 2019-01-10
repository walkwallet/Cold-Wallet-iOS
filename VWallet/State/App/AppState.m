//
//  AppState.m
//  Wallet
//
//  All rights reserved.
//

#import "AppState.h"

static NSString *VTouchIDEnableKey = @"VTouchIDEnableKey";
static NSString *VAutoBackupEnableKey = @"VAutoBackupEnableKey";
static NSString *VConnectionCheckEnableKey = @"VConnectionCheckEnableKey";
static NSString *VHasWalletKey = @"VHasWalletKey";

static AppState *VAppState;

@implementation AppState

+ (instancetype) shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        VAppState = [[AppState alloc] init];
    });
    return VAppState;
}

- (BOOL)hasWallet {
    BOOL hasWallet = [[NSUserDefaults standardUserDefaults] boolForKey:VHasWalletKey];
    if (!hasWallet) {
        self.autoBackupEnable = YES;
        self.connectionCheckEnable = YES;
    }
    return hasWallet;
}

- (void)setHasWallet:(BOOL)hasWallet {
    [[NSUserDefaults standardUserDefaults] setBool:hasWallet forKey:VHasWalletKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)touchIDEnable {
    return [[NSUserDefaults standardUserDefaults] boolForKey:VTouchIDEnableKey];
}

- (void)setTouchIDEnable:(BOOL)touchIDEnable {
    [[NSUserDefaults standardUserDefaults] setBool:touchIDEnable forKey:VTouchIDEnableKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)autoBackupEnable {
    return [[NSUserDefaults standardUserDefaults] boolForKey:VAutoBackupEnableKey];
}

- (void)setAutoBackupEnable:(BOOL)autoBackupEnable {
    [[NSUserDefaults standardUserDefaults] setBool:autoBackupEnable forKey:VAutoBackupEnableKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)connectionCheckEnable {
    return [[NSUserDefaults standardUserDefaults] boolForKey:VConnectionCheckEnableKey];
}

- (void)setConnectionCheckEnable:(BOOL)connectionCheckEnable {
    [[NSUserDefaults standardUserDefaults] setBool:connectionCheckEnable forKey:VConnectionCheckEnableKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
