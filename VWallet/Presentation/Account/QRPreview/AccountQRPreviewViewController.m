//
//  AccountQRPreviewViewController.m
//  Wallet
//
//  All rights reserved.
//

#import "AccountQRPreviewViewController.h"
#import "Language.h"
#import "UIImage+QRCode.h"
#import "UIColor+Hex.h"
#import "ThemeLabel.h"

@interface AccountQRPreviewViewController ()

@property (nonatomic, copy) NSDictionary *showInfo;

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIView *flagView;
@property (weak, nonatomic) IBOutlet UILabel *flagLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel1;
@property (weak, nonatomic) IBOutlet UIImageView *qrcodeImgView;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@end

@implementation AccountQRPreviewViewController

- (instancetype)initWithShowInfo:(NSDictionary *)showInfo {
    if (self = [super init]) {
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        self.modalPresentationStyle = UIModalPresentationCustom;
        self.showInfo = showInfo;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)initView {
    self.detailLabel.text = VLocalize(@"account_address_detail");
    self.flagView.backgroundColor = self.showInfo[@"flag_color"];
    self.flagLabel.text = self.showInfo[@"flag"];
    self.valueLabel.text = self.showInfo[@"title"];
    self.valueLabel1.text = self.showInfo[@"desc"];
    self.qrcodeImgView.image = [UIImage imageWithQrCodeStr:self.showInfo[@"qr_code_str"]];
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    CGPoint point = [touches.anyObject locationInView:self.contentView];
//    if (!CGRectContainsPoint(self.contentView.bounds, point)) {
//        [self close];
//    }
//}

- (IBAction)close {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
