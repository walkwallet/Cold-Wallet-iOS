//
//  PasswordSettingsViewController.m
//  Wallet
//
//  All rights reserved.
//

#import "PasswordSettingsViewController.h"

#import "Language.h"
#import "LevelBar.h"
#import "VColor.h"

#import "ResultViewController.h"

@interface PasswordSettingsViewController ()

@property (nonatomic, copy) NSString *pageTitle;
@property (nonatomic, strong) void(^successBlock)(NSString *);

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel1;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel2;

@property (weak, nonatomic) IBOutlet UITextField *pwdTextField;
@property (weak, nonatomic) IBOutlet UIView *pwdLengthTipLine;
@property (weak, nonatomic) IBOutlet UILabel *pwdLengthTipLabel;
@property (weak, nonatomic) IBOutlet LevelBar *secureLevelView;
@property (weak, nonatomic) IBOutlet UILabel *secureLevelLabel;
@property (weak, nonatomic) IBOutlet UITextField *confirmPwdTextField;
@property (weak, nonatomic) IBOutlet UILabel *pwdConsistencyTipLabel;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

@end

@implementation PasswordSettingsViewController

- (instancetype)initWithTitle:(NSString *)title success:(void (^)(NSString * _Nonnull))success {
    if (self = [super init]) {
        self.pageTitle = title;
        self.successBlock = success;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)initView {
    self.navigationItem.title = self.pageTitle;
    _titleLabel.text = VLocalize(@"wallet_password_settings_tip_text");
    _titleLabel1.text = VLocalize(@"create_wallet_password");
    _titleLabel2.text = VLocalize(@"confirm_wallet_password");
    _pwdTextField.placeholder = VLocalize(@"wallet_password_placeholder");
    _pwdLengthTipLabel.text = VLocalize(@"wallet_password_length_tip_text");
    _confirmPwdTextField.placeholder = VLocalize(@"confirm_wallet_password_placeholder");
    _pwdConsistencyTipLabel.text = VLocalize(@"confirm_wallet_password_consistency_tip_text");
    [_submitBtn setTitle:VLocalize(@"complete") forState:UIControlStateNormal];
    
    [_pwdTextField becomeFirstResponder];
    [self checkFormData];
}

- (IBAction)pwdtextFieldEditingChanged:(UITextField *)sender {
    if (sender == _pwdTextField) {
        [self.secureLevelView updateLevelWithPassword:sender.text];
        self.secureLevelLabel.textColor = self.secureLevelView.levelColor;
        self.secureLevelLabel.text = @[@"",
                                       VLocalize(@"secure_level_1"),
                                       VLocalize(@"secure_level_2"),
                                       VLocalize(@"secure_level_3"),
                                       VLocalize(@"secure_level_4"),
                                       VLocalize(@"secure_level_5")][self.secureLevelView.level];
        _pwdLengthTipLabel.hidden = sender.text.length >= 8;
        _pwdLengthTipLine.backgroundColor = _pwdLengthTipLabel.hidden ? VColor.separatorColor : VColor.redColor;
    }
    if (sender == _confirmPwdTextField || _confirmPwdTextField.text.length) {
        _pwdConsistencyTipLabel.hidden = [self.pwdTextField.text isEqualToString:self.confirmPwdTextField.text];
    }
    [self checkFormData];
}

- (IBAction)textFieldDidEndOnExit:(UITextField *)sender {
    if (sender == _pwdTextField) {
        [_confirmPwdTextField becomeFirstResponder];
    } else if (sender == _confirmPwdTextField) {
        if (self.submitBtn.enabled) {
            [self submitBtnClick];
        } else {
            [self.view endEditing:YES];
        }
    }
}

- (void)checkFormData {
    self.submitBtn.enabled = (self.pwdTextField.text.length >= 8 && [self.pwdTextField.text isEqualToString:self.confirmPwdTextField.text]);
}

- (IBAction)submitBtnClick {
    if (self.secureLevelView.level < 3) {
        ResultParameter *parameter = [ResultParameter paramterWithImgResourceName:@"ico_warning_tip" title:VLocalize(@"password_secure_level_weak_tip_title") message:VLocalize(@"password_secure_level_weak_tip_message")];
        [parameter setOperateBtnTitle:VLocalize(@"back_reset_password")];
        [parameter setSecondOperateBtnTitle:VLocalize(@"continue_complete_create")];
        __weak typeof(self) weakSelf = self;
        [parameter setSecondOperateBlock:^{
            [weakSelf normalSubmit];
        }];
        ResultViewController *resultVC = [[ResultViewController alloc] initWithResultParameter:parameter];
        [self presentViewController:resultVC animated:YES completion:nil];
    } else {
        [self normalSubmit];
    }
}

- (void)normalSubmit {
    if (_successBlock) {
        _successBlock(self.pwdTextField.text);
    }
}

@end
