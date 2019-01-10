//
//  ResultViewController.m
//  Wallet
//
//  All rights reserved.
//

#import "ResultViewController.h"

@interface ResultViewController ()

@property (nonatomic, strong) ResultParameter *parameter;

@property (weak, nonatomic) IBOutlet UIImageView *resultTypeImgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

@property (weak, nonatomic) IBOutlet UIButton *operateBtn;
@property (weak, nonatomic) IBOutlet UIButton *secondOperateBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondOperateBtnBottomLC;

@end

@implementation ResultViewController

- (instancetype)initWithResultParameter:(ResultParameter *)parameter {
    if (self = [super init]) {
        self.parameter = parameter;
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)initView {
    UIImage *img;
    if (self.parameter.imgResourceName.length) {
        img = [UIImage imageNamed:self.parameter.imgResourceName];
    }
    self.resultTypeImgView.image = img;
    self.titleLabel.text = self.parameter.resultTitle;
    self.messageLabel.text = self.parameter.resultMessage;
    [self.operateBtn setTitle:self.parameter.operateBtnTitle forState:UIControlStateNormal];
    BOOL showSecond = self.parameter.secondOperateBtnTitle.length;
    self.secondOperateBtn.hidden = !showSecond;
    self.secondOperateBtnBottomLC.constant = showSecond ? 24.f : -48.f;
    [self.secondOperateBtn setTitle:self.parameter.secondOperateBtnTitle forState:UIControlStateNormal];
}

- (IBAction)operateBtnClick:(UIButton *)btn {
    switch (btn.tag) {
        case 0: {
            if (!self.parameter.explicitDismiss) {
                [self dismissViewControllerAnimated:(self.parameter.operateBlock==nil) completion:nil];
            }
            if (self.parameter.operateBlock) {
                self.parameter.operateBlock();
            }
        } break;
        case 1: {
            if (!self.parameter.explicitDismiss) {
                [self dismissViewControllerAnimated:(self.parameter.secondOperateBlock==nil) completion:nil];
            }
            if (self.parameter.secondOperateBlock) {
                self.parameter.secondOperateBlock();
            }
        } break;
    }
}

@end
