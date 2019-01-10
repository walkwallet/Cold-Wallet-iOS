//
//  VInitViewController.m
//  Wallet
//
//  All rights reserved.
//

#import "VInitViewController.h"
#import "Language.h"
#import "VStoryboard.h"
#import <Masonry/Masonry.h>
#import "VColor.h"
#import "WalletMgr.h"
#import "WindowManager.h"
@import Vsys;
#import "UIViewController+Alert.h"
#import "VeePasswordSettingsViewController.h"
#import "VeeMnemonicWordImportViewController.h"
#import "VeeMnemonicWordBackupViewController.h"
#import "VeePasswordInputViewController.h"
#import "VeeResultViewController.h"
#import "VeeChooseNetworkViewController.h"
#import "VStoryBoard.h"
#import "VeeNavigationController.h"
#import "VeePasswordInputModel.h"
#import "VeePasswordAuthAlertViewController.h"
#import "VeeAlertViewController.h"

@interface VInitViewController ()

@property (weak, nonatomic) IBOutlet UILabel *pageTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *pageSubtitleLabel;

@property (weak, nonatomic) IBOutlet UIButton *createBtn;
@property (weak, nonatomic) IBOutlet UIButton *importBtn;
@property (strong, nonatomic) IBOutlet UIView *importSelectorView;
@property (weak, nonatomic) IBOutlet UIView *BtnContainerView;
@property (weak, nonatomic) IBOutlet UIButton *importWalletCloseBtn;
@property (weak, nonatomic) IBOutlet UIButton *importLocalBackupBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *importLocalBackupBtnHeightConstraint;
@property (weak, nonatomic) IBOutlet UIButton *importPhraseBtn;
@property (nonatomic, assign) BOOL hasShowAlert;
@end

@implementation VInitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)initView {
    self.pageTitleLabel.text = VLocalize(@"launch_page_title");
    self.pageSubtitleLabel.text = VLocalize(@"launch_page_subtitle");
    [self.createBtn setTitle:VLocalize(@"create_wallet") forState:UIControlStateNormal];
    [self.importBtn setTitle:VLocalize(@"import_wallet") forState:UIControlStateNormal];
    [self.importPhraseBtn setTitle:VLocalize(@"mnemonic_word_import") forState:UIControlStateNormal];
    
    self.BtnContainerView.layer.borderColor = VColor.borderColor.CGColor;
    self.importWalletCloseBtn.layer.borderColor = VColor.borderColor.CGColor;
    [self.view addSubview:self.importSelectorView];
    [self.importSelectorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.height.equalTo(@193);
    }];
    self.importSelectorView.transform = CGAffineTransformMakeTranslation(0, 250);
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = NSTextAlignmentCenter;
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString: VLocalize(@"local_backup_import") attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16 weight:UIFontWeightMedium], NSForegroundColorAttributeName:[UIColor whiteColor], NSParagraphStyleAttributeName: style}];
    if ([WalletMgr.shareInstance checkWalletBackup]) {
        NSAttributedString *str2 = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n%@", VLocalize(@"detect_local_wallet")] attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:11], NSForegroundColorAttributeName:[UIColor whiteColor], NSParagraphStyleAttributeName: style}];
        [str appendAttributedString:str2];
        self.importLocalBackupBtnHeightConstraint.constant = 64;
    }
    
    [self.importLocalBackupBtn setAttributedTitle:str forState:UIControlStateNormal];
    
    
    
    self.importBtn.alpha = 0.f;
    self.createBtn.alpha = 0.f;
    VeeAlertViewController *vc = [[VeeAlertViewController alloc] initWithTitle:VLocalize(@"tip_init_alert_title") secondTitle:VLocalize(@"tip_init_alert_detail") contentView:^(UIStackView * _Nonnull view) {
        
    } cancelTitle:@"" confirmTitle:VLocalize(@"tip_init_alert_btn") cancel:^{
        
    } confirm:^{
        self.importBtn.alpha = 1.f;
        self.createBtn.alpha = 1.f;
    }];
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (IBAction)createBtnClick {
    __weak typeof(self) weakSelf = self;
    VeeChooseNetworkViewController *vc = [VStoryboard.Network instantiateViewControllerWithIdentifier:@"VeeChooseNetworkViewController"];
    [vc setNextBlock:^{
        VeePasswordSettingsViewController *setPwdVC = [[VeePasswordSettingsViewController alloc] initWithTitle:VLocalize(@"create_wallet") success:^(NSString * _Nonnull password) {
            [weakSelf.navigationController popViewControllerAnimated:NO];
            WalletMgr.shareInstance.password = password;
            WalletMgr.shareInstance.seed = VsysGenerateSeed();
            WalletMgr.shareInstance.accountSeeds = @[];
            NSError *error = [WalletMgr.shareInstance saveToStorage];
            if (error) {
                NSLog(@" - im error = %@", error);
                return;
            }
            [weakSelf createWalletSuccess];
        }];
        [weakSelf.navigationController pushViewController:setPwdVC animated:YES];
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)createWalletSuccess {
    VeeResultParameter *parameter = [VeeResultParameter paramterWithImgResourceName:@"ico_success_tip" title:VLocalize(@"wallet_create_success_tip_title") message:VLocalize(@"wallet_create_success_tip_message")];
    [parameter setOperateBtnTitle:VLocalize(@"backup_wallet")];
    [parameter setSecondOperateBtnTitle:VLocalize(@"later_on_backup")];
    parameter.explicitDismiss = YES;
    VeeResultViewController *resultVC = [[VeeResultViewController alloc] initWithResultParameter:parameter];
    __weak typeof(resultVC) weakResultVC = resultVC;
    [parameter setOperateBlock:^{
        NSArray<NSString *> *mnemonicWordArray = [WalletMgr.shareInstance.seed componentsSeparatedByString:@" "];
        VeeMnemonicWordBackupViewController *backupVC = [[VeeMnemonicWordBackupViewController alloc] initWithMnemonicWordArray:mnemonicWordArray createWallet:YES];
        VeeNavigationController *naviVC = [[VeeNavigationController alloc] initWithRootViewController:backupVC];
        naviVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [weakResultVC presentViewController:naviVC animated:YES completion:nil];
    }];
    [parameter setSecondOperateBlock:^{
        [WindowManager changeToRootViewController:VStoryboard.Main.instantiateInitialViewController];
    }];
    [WindowManager changeToRootViewController:resultVC];
}

- (IBAction)importBtnClick {
    [UIView animateWithDuration:.2f animations:^{
        self.importSelectorView.transform = CGAffineTransformIdentity;
        self.importBtn.alpha = 0.01f;
        self.createBtn.alpha = 0.01f;
    }];
}

- (IBAction)closeImportBtnClick:(id)sender {
    [self closeImportView];
}

- (IBAction)phraseImportBtnClick:(id)sender {
    __weak typeof(self) weakSelf = self;
    VeeChooseNetworkViewController *vc = [VStoryboard.Network instantiateViewControllerWithIdentifier:@"VeeChooseNetworkViewController"];
    [vc setNextBlock:^{
        VeeMnemonicWordImportViewController *vc = [VStoryboard.Phrase instantiateViewControllerWithIdentifier:NSStringFromClass([VeeMnemonicWordImportViewController class])];
        [weakSelf.navigationController pushViewController:vc animated:YES];
    }];
    [self.navigationController pushViewController:vc animated:YES];
    [self closeImportView];
}

- (IBAction)importLocalBackupBtnClick:(id)sender {
    if (!WalletMgr.shareInstance.checkWalletBackup) {
        [self alertWithTitle:VLocalize(@"import_local_backup_err") confirmText:VLocalize(@"ok")];
        return;
    }
    [self closeImportView];
    __weak typeof(self) weakSelf = self;
    VeePasswordInputModel *model = [[VeePasswordInputModel alloc] init];
    model.title = VLocalize(@"local_backup_import");
    model.placeholder = VLocalize(@"password_auth_title_detail");
    VeePasswordAuthAlertViewController *vc = [[VeePasswordAuthAlertViewController alloc] initWithModel:model];
    [vc showPasswordAlert:weakSelf result:^(BOOL success) {
        if (success) {
            [WalletMgr.shareInstance saveToStorage];
            [WindowManager changeToRootViewController:VStoryboard.Main.instantiateInitialViewController];
        }
    }];
}

- (void)closeImportView {
    [UIView animateWithDuration:.2f animations:^{
        self.importSelectorView.transform = CGAffineTransformMakeTranslation(0, 250);
        self.importBtn.alpha = 1.f;
        self.createBtn.alpha = 1.f;
    }];
}
@end
