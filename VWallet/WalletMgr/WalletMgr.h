//
//  Wallet.h
//  Wallet
//
//  All rights reserved.
//

#import <Foundation/Foundation.h>
@import Vsys;

NS_ASSUME_NONNULL_BEGIN

@interface WalletMgr : NSObject

@property (nonatomic, strong, nullable) VsysWallet *wallet;

@property (nonatomic, copy, nullable) NSString *seed;

@property (nonatomic, copy, nullable) NSString *salt;

@property (nonatomic, copy, nullable) NSString *network;

@property (nonatomic, copy, nullable) NSArray *accountSeeds;

@property (nonatomic, copy, nullable) NSArray *accounts;

@property (nonatomic, assign) NSInteger nonce;

@property (nonatomic, copy, nullable) NSString *password;

@property (nonatomic, copy, nullable) NSData *securePassword;


+ (instancetype)shareInstance;

- (BOOL)checkWalletBackup;

- (NSError *)loadWallet:(NSString *)password;

- (NSError *)generateSalt:(NSString *)password;

- (NSError *)saveToStorage;

- (NSError *)logoutWallet;

- (NSString *)networkDescription;

- (void)clearPropertyValue;

- (void)logoutWithoutDeleteWallet;
@end

NS_ASSUME_NONNULL_END
