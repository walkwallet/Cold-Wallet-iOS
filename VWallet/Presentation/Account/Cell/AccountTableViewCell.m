//
//  AccountTableViewCell.m
//  Wallet
//
//  All rights reserved.
//

#import "AccountTableViewCell.h"

#import "Language.h"
#import "VColor.h"
#import "NSString+Asterisk.h"

@interface AccountTableViewCell ()

@property (weak, nonatomic) IBOutlet UIView *flagView;
@property (weak, nonatomic) IBOutlet UILabel *flagLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel1;
@property (weak, nonatomic) IBOutlet UIImageView *qrcodeImgView;

@end

@implementation AccountTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectedBackgroundView = [UIView new];
    _valueLabel.textColor = VColor.textColor;
    _valueLabel1.textColor = VColor.textSecondColor;
    _qrcodeImgView.tintColor = VColor.textSecondColor;
}

- (void)setAccountAddress:(NSString *)accountAddress {
    _valueLabel1.text = [accountAddress explicitCount:12 maxAsteriskCount:6];
}

- (void)setFlag:(int)flag flagColor:(UIColor *)flagColor {
    _valueLabel.text = [NSString stringWithFormat:@"%@ %d", VLocalize(@"account"), flag];
    _flagLabel.text = [NSString stringWithFormat:@"%d", flag];
    _flagView.backgroundColor = flagColor;
}

@end
