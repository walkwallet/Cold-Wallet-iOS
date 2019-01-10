//
//  NormalTableViewCell.m
//  Wallet
//
//  All rights reserved.
//

#import "NormalTableViewCell.h"

@interface NormalTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@end

@implementation NormalTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
//    [super setHighlighted:highlighted animated:animated];
}

- (void)setupCellItem:(CellItem *)item {
    if (item.icon.length == 0) {
        self.iconImageView.hidden = YES;
    } else {
        self.iconImageView.image = [UIImage imageNamed:item.icon];
    }
    self.titleLabel.text = item.title;
    self.descLabel.text = item.desc;
    
    if (item.dict[@"titleColor"]) {
        self.titleLabel.textColor = item.dict[@"titleColor"];
    }
    
    if (item.dict[@"descColor"]) {
        self.descLabel.textColor = item.dict[@"descColor"];
    }
}

@end
