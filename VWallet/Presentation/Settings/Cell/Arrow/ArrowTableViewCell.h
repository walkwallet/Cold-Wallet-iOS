//
//  ArrowTableViewCell.h
//  Wallet
//
//  All rights reserved.
//

@import UIKit;
#import "CellItem.h"
#import "TableViewCellProtocol.h"


NS_ASSUME_NONNULL_BEGIN

@interface ArrowTableViewCell : UITableViewCell

@property (nonatomic, weak) id<TableViewCellDelegate> delegate;

- (void)setupCellItem:(CellItem *)item;
@end

NS_ASSUME_NONNULL_END
