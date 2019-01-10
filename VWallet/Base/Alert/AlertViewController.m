//
//  AlertViewController.m
//  Wallet
//
//  All rights reserved.
//

#import "AlertViewController.h"

@interface AlertViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondTitleLabel;
@property (weak, nonatomic) IBOutlet UIStackView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;
@property (copy, nonatomic) void(^cancelCallback)(void);
@property (copy, nonatomic) void(^confirmCallback)(void);
@property (nonatomic, copy) void(^configureBlock)(void);
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewCenterYConstraint;
@end

@implementation AlertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.configureBlock();
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillAppear) name:UIKeyboardWillShowNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)keyboardWillAppear {
    [UIView animateWithDuration:0.5f animations:^{
        self.contentViewCenterYConstraint.constant = -50.f;
    }];
}

- (instancetype)initWithIconName:(NSString *)iconName
                           Title:(NSString *)title
                     secondTitle:(NSString *)secondTitle
                     contentView:(nullable void (^)(UIStackView *))configureView
                     cancelTitle:(NSString *)cancelTitle
                    confirmTitle:(NSString *)confirmTitle
                          cancel:(void(^)(void))cancel
                         confirm:(void(^)(void))confirm {
    if (self = [super init]) {
        self.modalPresentationStyle = UIModalPresentationOverFullScreen;
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        self.titleLabel.adjustsFontSizeToFitWidth = YES;
        
        typeof(self) weakself = self;
        self.configureBlock = ^{
            weakself.titleLabel.text = title;
            if ([iconName isEqualToString:@""]) {
                weakself.iconImageView.hidden = YES;
            }
            if (!secondTitle || [secondTitle isEqualToString:@""]) {
                weakself.secondTitleLabel.hidden = YES;
            } else {
                NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
                style.lineSpacing = 5.f;
                style.alignment = NSTextAlignmentCenter;
                NSAttributedString *str = [[NSAttributedString alloc] initWithString:secondTitle attributes:@{
                    NSParagraphStyleAttributeName: style,
                                                                                                              }];
                weakself.secondTitleLabel.attributedText = str;
            }
            
            if (!configureView) {
                weakself.contentView.hidden = YES;
            } else {
                configureView(weakself.contentView);
            }
            if (!cancelTitle || [cancelTitle isEqualToString:@""]) {
                weakself.cancelBtn.hidden = YES;
            } else {
                [weakself.cancelBtn setTitle:cancelTitle forState:UIControlStateNormal];
            }
            [weakself.confirmBtn setTitle:confirmTitle forState:UIControlStateNormal];
            weakself.cancelCallback = cancel;
            weakself.confirmCallback = confirm;
        };
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title
                  secondTitle:(NSString *)secondTitle
                  contentView:(nullable void (^)(UIStackView *))configureView
                  cancelTitle:(NSString *)cancelTitle
                 confirmTitle:(NSString *)confirmTitle
                       cancel:(void(^)(void))cancel
                      confirm:(void(^)(void))confirm {
    return [self initWithIconName:@"ico_note_tip" Title:title secondTitle:secondTitle contentView:configureView cancelTitle:cancelTitle confirmTitle:confirmTitle cancel:cancel confirm:confirm];
}

- (IBAction)cancelBtnClick:(id)sender {
    if (!self.notDismiss) {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
    if (self.cancelCallback) {
        self.cancelCallback();
    }
}

- (IBAction)confirmBtnClick:(id)sender {
    if (!self.notDismiss) {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
    if (self.confirmCallback) {
        self.confirmCallback();
    }
}

@end
