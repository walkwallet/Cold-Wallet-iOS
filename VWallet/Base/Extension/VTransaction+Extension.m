
//
//  sysTransaction+Extension.m
//  Wallet
//
//  All rights reserved.
//

#import "VTransaction+Extension.h"
#import "Language.h"

@implementation VsysTransaction (Extension)

- (NSString *)typeDesc {
    if (self.txType == VsysTxTypePayment) {
        return VLocalize(@"const_transaction_type_payment");
    }
    if (self.txType == VsysTxTypeLease) {
        return VLocalize(@"const_transaction_type_lease");
    }
    if (self.txType == VsysTxTypeCancelLease) {
        return VLocalize(@"const_transaction_type_lease_cancel");
    }
    return @"";
}

@end
