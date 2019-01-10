//
//  AppState.h
//  Wallet
//
//  All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AppState : NSObject

+ (instancetype) shareInstance;

@property (nonatomic, assign) BOOL hasWallet;

@property (nonatomic, assign) BOOL touchIDEnable;

@property (nonatomic, assign) BOOL autoBackupEnable;

@property (nonatomic, assign) BOOL connectionCheckEnable;

@end

NS_ASSUME_NONNULL_END
