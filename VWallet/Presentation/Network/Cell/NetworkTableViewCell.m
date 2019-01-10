//
//  NetworkTableViewCell.m
//  Wallet
//
//  All rights reserved.
//

#import "NetworkTableViewCell.h"
#import "VColor.h"

@interface NetworkTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UIView *cardBgView;

@end
@implementation NetworkTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
    if (selected) {
        self.iconImageView.backgroundColor = VColor.orangeColor;
        self.iconImageView.image = [UIImage imageNamed:@"ico_select"];
        self.cardBgView.backgroundColor = VColor.viewBgColor;
    } else {
        self.iconImageView.backgroundColor = VColor.grayColor;
        self.iconImageView.image = [UIImage new];
        self.cardBgView.backgroundColor = UIColor.clearColor;
    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    
}

- (void)setupCellItem:(CellItem *)item {
    self.iconImageView.image = [UIImage imageNamed:item.icon];
    self.titleLabel.text = item.title;
    self.descLabel.text = item.desc;
}


@end
