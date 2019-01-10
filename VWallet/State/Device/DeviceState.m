//
//  DeviceState.m
//  Wallet
//
//  All rights reserved.
//

#import "DeviceState.h"
#import "NetworkTool.h"
@import CoreBluetooth;

static DeviceState *VDeviceState;

@interface DeviceState() <CBCentralManagerDelegate>

@property (nonatomic, strong) CBCentralManager *bluetoothManager;

@property (nonatomic, assign) BOOL bluetoothEnable;

@end

@implementation DeviceState

+ (instancetype)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        VDeviceState = [[DeviceState alloc] init];
    });
    return VDeviceState;
}

- (void)startBluetoothMonitor {
    self.bluetoothManager = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) options:@{CBCentralManagerOptionShowPowerAlertKey: @(NO)}];
}


- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    switch (central.state) {
        case CBManagerStatePoweredOff:
        case CBManagerStateUnsupported:
        case CBManagerStateUnknown:
            self.bluetoothEnable = NO;
            break;
        default:
            self.bluetoothEnable = YES;
            break;
    }
}

- (BOOL)networkEnable {
    return ![[NetworkTool getIPAddress:YES] isEqualToString:@"0.0.0.0"];
}

- (BOOL)wifiEnable {
    return ![[NetworkTool getWifiIPAddress:YES] isEqualToString:@"0.0.0.0"];
}

- (BOOL)cellularEnable {
    return ![[NetworkTool getCellularIPAddress:YES] isEqualToString:@"0.0.0.0"];
}

@end
