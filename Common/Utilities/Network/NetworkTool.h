//
//  NetworkTool.h
//  Wallet
//
//  All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NetworkTool : NSObject

+ (NSString *)getIPAddress:(BOOL)preferIPv4;

+ (NSDictionary *)getIPAddresses;

+ (NSString *)getWifiIPAddress:(BOOL)preferIPv4;

+ (NSString *)getCellularIPAddress:(BOOL)preferIPv4;

@end

NS_ASSUME_NONNULL_END
