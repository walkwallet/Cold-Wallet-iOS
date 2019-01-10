//
//  ChooseNetworkTableViewController.m
//  Wallet
//
//  All rights reserved.
//

#import "ChooseNetworkViewController.h"
#import "VColor.h"
#import "NetworkTableViewCell.h"
#import "CellItem.h"
#import "Language.h"
#import "SectionItem.h"
#import "VStoryboard.h"
#import "WalletMgr.h"
#import "AlertViewController.h"
#import "VColor.h"

@interface ChooseNetworkViewController ()


@property (nonatomic, copy) void(^next)(void);

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, copy) NSArray<SectionItem *> *contentData;

@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondTitleLabel;
@property (weak, nonatomic) IBOutlet UIButton *changeNetworkBtn;
@property (nonatomic, assign) BOOL isTestnet;
@property (weak, nonatomic) IBOutlet UIView *networkView;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@end

@implementation ChooseNetworkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)initView {
    self.title = VLocalize(@"network_title");
    self.descLabel.text = VLocalize(@"network_choose_tip");
    self.titleLabel.text = VLocalize(@"network_mainnet");
    self.secondTitleLabel.text = VLocalize(@"network_mainnet_desc");
    self.view.backgroundColor = VColor.rootViewBgColor;
    [self.nextBtn setTitle:VLocalize(@"next") forState:UIControlStateNormal];
    [self updateChangeNetwork];
}

- (IBAction)changeNetworkBtnClick:(id)sender {
    if (!self.isTestnet) {
        AlertViewController *vc = [[AlertViewController alloc] initWithTitle:VLocalize(@"network_change_tip") secondTitle:@"" contentView:^(UIStackView * _Nonnull view) {
            
        } cancelTitle:VLocalize(@"cancel") confirmTitle:VLocalize(@"confirm") cancel:^{
            
        } confirm:^{
            self.isTestnet = !self.isTestnet;
            [self updateChangeNetwork];
        }];
        [self presentViewController:vc animated:YES completion:nil];
    } else {
        self.isTestnet = !self.isTestnet;
        [self updateChangeNetwork];
    }
}

- (void)updateChangeNetwork {
    CATransition *ts = [CATransition animation];
    ts.type = @"oglFlip";
    ts.subtype = self.isTestnet ? kCATransitionFromTop : kCATransitionFromBottom;
    ts.duration = 0.5f;
    [self.networkView.layer addAnimation:ts forKey:@"transtion"];
    NSString *title = @"";
    if (self.isTestnet) {
        title = VLocalize(@"network_choose_btn_title1");
        self.titleLabel.text = VLocalize(@"network_testnet");
        self.secondTitleLabel.text = VLocalize(@"network_testnet_desc");
        self.iconImageView.image = [UIImage imageNamed:@"ico_web"];
    } else {
        title = VLocalize(@"network_choose_btn_title2");
        self.titleLabel.text = VLocalize(@"network_mainnet");
        self.secondTitleLabel.text = VLocalize(@"network_mainnet_desc");
        self.iconImageView.image = [UIImage imageNamed:@"ico_network_choose"];
    }
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:title attributes:@{
        NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),
        NSForegroundColorAttributeName: VColor.textSecondColor
        
    }];
    [self.changeNetworkBtn setAttributedTitle:str forState:UIControlStateNormal];
}

- (void)setNextBlock:(void(^)(void))next {
    _next = next;
}

- (IBAction)nextBtnClick:(id)sender {
    WalletMgr.shareInstance.network = !self.isTestnet ? VsysNetworkMainnet : VsysNetworkTestnet;
    
    if (self.next) {
        self.next();
    }
}
@end
