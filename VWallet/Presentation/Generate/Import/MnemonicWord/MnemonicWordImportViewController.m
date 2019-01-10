//
//  MnemonicWordImportViewController.m
//  Wallet
//
//  All rights reserved.
//

#import "MnemonicWordImportViewController.h"
#import "Language.h"
#import "MediaManager.h"
#import "QRScannerViewController.h"
#import "UIViewController+Alert.h"
#import "VColor.h"
#import "WalletMgr.h"
#import "PasswordSettingsViewController.h"
#import "AlertViewController.h"
#import <Masonry/Masonry.h>
#import "WindowManager.h"
#import "VStoryboard.h"
#import "UITextView+Placeholder.h"
@import Vsys;

@interface MnemonicWordImportViewController () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

@end

@implementation MnemonicWordImportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}
    
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)initView {
    self.navigationItem.title = VLocalize(@"import_phrase_title");
    self.tipLabel.text = VLocalize(@"import_mnemonic_word_tip");
    self.textView.superview.layer.borderColor = VColor.borderColor.CGColor;
    self.view.backgroundColor = VColor.rootViewBgColor;
    [self.nextBtn setTitle:VLocalize(@"next") forState:UIControlStateNormal];
    self.textView.placeholder = VLocalize(@"confirm_wallet_password_placeholder");
    self.textView.keyboardAppearance = UIKeyboardAppearanceDark;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [self nextBtnClick];
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    NSString *regex = @"^([A-Za-z]+\\s){14}[A-Za-z]+$";
    NSPredicate *mnemonicWordTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL enabled = [mnemonicWordTest evaluateWithObject:textView.text];
    self.nextBtn.alpha = enabled ? 1.f : 0.5f;
    self.nextBtn.tag = enabled;
    [self.textView updatePlaceholderState];
}

- (IBAction)scanBtnClick:(id)sender {
    __weak typeof(self) weakSelf = self;
    [self.textView resignFirstResponder];
    [MediaManager checkCameraPermissionsWithCallVC:self result:^{
        QRScannerViewController *qrScannerVC = [[QRScannerViewController alloc] initWithQRRegexStr:@"/#cold/export?seed=[^\\s]*" noMatchTipText:@"" result:^(NSString * _Nullable qrCode) {
            //                NSLog(@" - im - qrCode = %@", qrCode);
            NSArray *arr = [qrCode componentsSeparatedByString:@"/#cold/export?seed="];
            if (arr.count != 2) {
                [weakSelf alertWithTitle:VLocalize(@"qr_code_unsupported_types_tip_text") confirmText:nil];
                return ;
            }
            weakSelf.textView.text = arr[1];
            [weakSelf textViewDidChange:weakSelf.textView];
        }];
        [weakSelf presentViewController:qrScannerVC animated:YES completion:nil];
    }];
}

- (IBAction)nextBtnClick {
    if (self.textView.text.length == 0) {
        [self alertWithTitle:VLocalize(@"import_phrase_validate_err") confirmText:VLocalize(@"ok")];
        return;
    }
    if (self.nextBtn.tag) {
        if (!VsysValidatePhrase(self.textView.text)) {
            [self showUnofficialAlert];
//            [self alertWithTitle:VLocalize(@"import_phrase_validate_err") confirmText:VLocalize(@"ok")];
        } else {
            [self generateWalletWithSeed:self.textView.text];
        }
    } else {
        [self showUnofficialAlert];
    }
}

- (void)showUnofficialAlert {
    UIGraphicsBeginImageContextWithOptions(self.textView.bounds.size, NO, [UIScreen mainScreen].scale);
    [self.textView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.image = image;
    imgView.contentMode = UIViewContentModeTopLeft;
    imgView.layer.borderColor = VColor.borderColor.CGColor;
    imgView.layer.cornerRadius = 6.f;
    imgView.layer.borderWidth = 1.f;
    AlertViewController *vc = [[AlertViewController alloc] initWithTitle:VLocalize(@"unofficial_tip_title") secondTitle:VLocalize(@"unofficial_tip_detail") contentView:^(UIStackView * _Nonnull parentView) {
        [parentView addArrangedSubview:imgView];
        [imgView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(parentView);
            make.height.equalTo(@(120));
        }];
    } cancelTitle: VLocalize(@"cancel") confirmTitle:VLocalize(@"confirm") cancel:^{
        
    } confirm:^{
        [self generateWalletWithSeed:self.textView.text];
    }];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)generateWalletWithSeed:(NSString *)seed {
    WalletMgr.shareInstance.seed = seed;
    VsysWallet *wallet = VsysNewWallet(seed, WalletMgr.shareInstance.network);
    WalletMgr.shareInstance.wallet = wallet;
    WalletMgr.shareInstance.accountSeeds = @[];
    PasswordSettingsViewController *setPwdVC = [[PasswordSettingsViewController alloc] initWithTitle:VLocalize(@"setup_password") success:^(NSString * _Nonnull password) {
        WalletMgr.shareInstance.password = password;
        NSError *error = [WalletMgr.shareInstance generateSalt:password];
        if (error) {
            NSLog(@"generateSalt error: %@", error);
            return;
        }
        error = [WalletMgr.shareInstance saveToStorage];
        if (error) {
            NSLog(@"save storage error: %@", error);
            return;
        }
        [WindowManager changeToRootViewController:VStoryboard.Main.instantiateInitialViewController];
    }];
    [self.navigationController pushViewController:setPwdVC animated:YES];
}


#pragma mark - Regex
- (NSArray *)matchString:(NSString *)string regexStr:(NSString *)regexStr {
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regexStr options:NSRegularExpressionIgnoreMetacharacters error:nil];
    NSArray * matches = [regex matchesInString:string options:0 range:NSMakeRange(0, [string length])];
    NSMutableArray *array = [NSMutableArray array];
    for (NSTextCheckingResult *match in matches) {
        for (int i = 0; i < [match numberOfRanges]; i++) {
            NSString *component = [string substringWithRange:[match rangeAtIndex:i]];
            [array addObject:component];
        }
    }
    return array;
}


@end
