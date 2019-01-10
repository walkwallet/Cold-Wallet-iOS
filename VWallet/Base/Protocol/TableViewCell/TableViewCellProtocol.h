//
//  TableViewCellProtocol.h
//  Wallet
//
//  All rights reserved.
//

#ifndef TableViewCellProtocol_h
#define TableViewCellProtocol_h

typedef NS_ENUM(NSInteger, CellActionType) {
    SwitchStateChange
};

@protocol TableViewCellDelegate <NSObject>

- (void)cellActionWithType: (NSInteger)type item:(CellItem *)item;

@end

#endif /* TableViewCellProtocol_h */
