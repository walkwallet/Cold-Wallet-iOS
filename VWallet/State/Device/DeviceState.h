//
//  DeviceState.h
//  Wallet
//
//  All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DeviceState : NSObject

+ (instancetype) shareInstance;

- (void) startBluetoothMonitor;

- (BOOL)bluetoothEnable;

- (BOOL)wifiEnable;

- (BOOL)cellularEnable;
@end

NS_ASSUME_NONNULL_END
