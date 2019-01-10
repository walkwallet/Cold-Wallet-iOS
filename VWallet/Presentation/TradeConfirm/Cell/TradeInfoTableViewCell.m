//
//  TradeInfoTableViewCell.m
//  Wallet
//
//  All rights reserved.
//

#import "TradeInfoTableViewCell.h"

@interface TradeInfoTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;

@end

@implementation TradeInfoTableViewCell

- (void)setShowInfo:(NSDictionary *)showInfo {
    _showInfo = showInfo;
    _titleLabel.text = showInfo[@"title"];
    _valueLabel.text = showInfo[@"value"];
}

@end
