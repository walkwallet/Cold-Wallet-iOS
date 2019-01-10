//
//  TradeVerifyQRPreviewViewController.m
//  Wallet
//
//  All rights reserved.
//

#import "TradeVerifyQRPreviewViewController.h"
#import "Language.h"
#import "UIImage+QRCode.h"

@interface TradeVerifyQRPreviewViewController ()

@property (nonatomic, strong) void(^completeBlock)(void);

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *qrCodeImgView;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UIButton *completeBtn;

@property (nonatomic, copy) NSString *pageTitle;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *qrCodeStr;

@end

@implementation TradeVerifyQRPreviewViewController

- (instancetype)initWithTitle:(NSString *)title desc:(NSString *)desc qrCodeStr:(NSString *)qrCodeStr complete:(nonnull void (^)(void))complete {
    if (self = [super init]) {
        self.pageTitle = title;
        self.desc = desc;
        self.qrCodeStr = qrCodeStr;
        self.completeBlock = complete;
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        self.modalPresentationStyle = UIModalPresentationCustom;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = self.pageTitle;
    self.descLabel.text = self.desc;
    self.qrCodeImgView.image = [UIImage imageWithQrCodeStr:self.qrCodeStr];
    [self.completeBtn setTitle:VLocalize(@"complete") forState:UIControlStateNormal];
}

//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    CGPoint point = [touches.anyObject locationInView:self.contentView];
//    if (!CGRectContainsPoint(self.contentView.bounds, point)) {
//        [self close];
//    }
//}

- (IBAction)completeBtnClick {
    [self dismissViewControllerAnimated:NO completion:nil];
    if (self.completeBlock) {
        self.completeBlock();
    }
}

- (IBAction)close {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
