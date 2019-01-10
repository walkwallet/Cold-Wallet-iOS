//
//  AccountTableViewController.m
//  Wallet
//
//  All rights reserved.
//

#import "AccountTableViewController.h"

#import "WalletMgr.h"

#import "Language.h"
#import "VColor.h"
#import "UIColor+Hex.h"
#import "AccountTableViewCell.h"
#import "AppState.h"
#import "AccountQRPreviewViewController.h"
#import "MediaManager.h"
#import "QRScannerViewController.h"
#import "UIViewController+Alert.h"
#import "TradeConfirmTableViewController.h"
#import "AlertViewController.h"

static NSString *const CellIdentifier = @"AccountTableViewCell";

@interface AccountTableViewController ()

@property (nonatomic, strong) NSArray<UIColor *> *cellColorHexStrArray;

@property (weak, nonatomic) IBOutlet UIButton *addAccountBtn;

@end

@implementation AccountTableViewController

- (NSArray<UIColor *> *)cellColorHexStrArray {
    if (!_cellColorHexStrArray) {
        _cellColorHexStrArray = @[[UIColor colorWithHex:0xFF8737],
                                  [UIColor colorWithHex:0xFFB300],
                                  [UIColor colorWithHex:0x5E35B1],
                                  [UIColor colorWithHex:0x3949AB],
                                  [UIColor colorWithHex:0x00897B],
                                  [UIColor colorWithHex:0x85239E],
                                  [UIColor colorWithHex:0x039BE5],
                                  [UIColor colorWithHex:0x7CB342]];
    }
    return _cellColorHexStrArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)initView {
    self.navigationItem.title = VLocalize(@"tabbar_page_title_0");
    if (@available(iOS 11.0, *)) {
        self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeAutomatic;
    }
    [WalletMgr.shareInstance loadWallet:WalletMgr.shareInstance.password];
    [self.addAccountBtn setTitle:VLocalize(@"add_more_account") forState:UIControlStateNormal];
    [self.addAccountBtn setTitleColor:VColor.textSecondColor forState:UIControlStateNormal];
    self.addAccountBtn.tintColor = VColor.textSecondColor;
    self.tableView.backgroundColor = VColor.rootViewBgColor;
    [self.tableView setRowHeight:127.f];
    [self.tableView registerNib:[UINib nibWithNibName:CellIdentifier bundle:nil] forCellReuseIdentifier:CellIdentifier];
}

- (IBAction)scanBtnClick {
    __weak typeof(self) weakSelf = self;
    [MediaManager checkCameraPermissionsWithCallVC:self result:^{
        QRScannerViewController *qrScannerVC = [[QRScannerViewController alloc] initWithQRRegexStr:nil noMatchTipText:nil result:^(NSString * _Nullable qrCode) {
            [weakSelf qrCodeScanResult:qrCode];
        }];
        [weakSelf presentViewController:qrScannerVC animated:YES completion:nil];
    }];
}

- (void)qrCodeScanResult:(NSString *)qrCode {
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[qrCode dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
    if (!error) {
        if ([json isKindOfClass:NSDictionary.class]) {
            if ([json[@"api"] integerValue] > VsysApi) {
                [self alertWithTitle:VLocalize(@"qr_code_version_is_too_high_tip_text") confirmText:nil];
                return;
            }
            if (![json[@"opc"] isEqualToString:VsysOpcTypeTransction]) {
                [self alertWithTitle:VLocalize(@"qr_code_unsupported_types_tip_text") confirmText:nil handler:nil];
                return;
            }
            if ([json.allKeys containsObject:@"transactionType"]) {
                NSString *senderPublicKey = json[@"senderPublicKey"];
                VsysAccount *myAccount;
                for (VsysAccount *account in WalletMgr.shareInstance.accounts) {
                    if ([senderPublicKey isEqualToString:account.publicKey]) {
                        myAccount = account;
                        break;
                    }
                }
                if (myAccount) {
                    TradeConfirmTableViewController *tradeConfirmVC = [[TradeConfirmTableViewController alloc] initWithTradeInfo:qrCode account:myAccount];
                    [self presentViewController:tradeConfirmVC.naviVC animated:YES completion:nil];
                } else {
                    [self alertWithTitle:VLocalize(@"qr_code_transaction_account_error_tip_text") confirmText:nil];
                }
                return;
            }
        }
    }
    [self alertWithTitle:VLocalize(@"qr_code_unsupported_types_tip_text") message:qrCode confirmText:nil handler:nil];
}

- (IBAction)addAccountBtnClick {
    NSInteger addAccountCount = 1;
    if (addAccountCount <= 0) return;
    AlertViewController *vc = [[AlertViewController alloc] initWithTitle:VLocalize(@"add_account_tip_title") secondTitle:VLocalize(@"add_account_tip_detail") contentView:nil cancelTitle:VLocalize(@"cancel") confirmTitle:VLocalize(@"add_account_confirm") cancel:^{
        
    } confirm:^{
        NSMutableArray *newAccountArray = [NSMutableArray arrayWithCapacity:addAccountCount];
        NSMutableArray *newAccountSeedArray = [NSMutableArray arrayWithCapacity:addAccountCount];
        NSInteger accountCount = WalletMgr.shareInstance.nonce + 1;
        for (NSInteger i = accountCount; i < accountCount + addAccountCount; i++) {
            VsysAccount *account = [WalletMgr.shareInstance.wallet generateAccount:i];
            [newAccountArray addObject:account];
            [newAccountSeedArray addObject:account.accountSeed];
        }
        NSArray *originAccountArray = WalletMgr.shareInstance.accounts ?: @[];
        NSArray *originAccountSeedArray = WalletMgr.shareInstance.accountSeeds ?: @[];
        WalletMgr.shareInstance.accounts = [originAccountArray arrayByAddingObjectsFromArray:newAccountArray];
        WalletMgr.shareInstance.accountSeeds = [originAccountSeedArray arrayByAddingObjectsFromArray:newAccountSeedArray];
        WalletMgr.shareInstance.nonce += addAccountCount;
        NSError *error;
        if (AppState.shareInstance.autoBackupEnable) {
            error = [WalletMgr.shareInstance saveToStorage];
        }
        if (error) {
            WalletMgr.shareInstance.accounts = originAccountArray;
            WalletMgr.shareInstance.accountSeeds = originAccountSeedArray;
            WalletMgr.shareInstance.nonce = WalletMgr.shareInstance.accounts.count - 1;
            NSLog(@" - create account fail - error = %@", error);
        } else {
            [self.tableView reloadData];
        }
    }];
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - UITableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return WalletMgr.shareInstance.accounts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AccountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    VsysAccount *account = WalletMgr.shareInstance.accounts[indexPath.row];
    cell.accountAddress = account.address;
    [cell setFlag:(int)(indexPath.row + 1) flagColor:[self flagColorWithIndexPath:indexPath]];
    return cell;
}

#pragma mark - UITableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    VsysAccount *account = WalletMgr.shareInstance.accounts[indexPath.row];
    int sort = (int)indexPath.row + 1;
    NSDictionary *dict = @{@"protocol": VsysProtocol,
                           @"api": @(VsysApi),
                           @"opc": VsysOpcTypeAccount,
                           @"address": account.address,
                           @"publicKey": account.publicKey,
                           };
    NSString *qrcodeStr = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
    NSDictionary *showInfo = @{@"flag_color" : [self flagColorWithIndexPath:indexPath],
                               @"flag" : [NSString stringWithFormat:@"%d", sort],
                               @"title" : [NSString stringWithFormat:@"%@ %d", VLocalize(@"account"), sort],
                               @"desc" : account.address,
//                               @"qr_code_str" : [NSString stringWithFormat:@"http://localhost:8080/#cold/export?address=%@&publicKey=%@", account.address, account.publicKey],
                               @"qr_code_str" :qrcodeStr,
                               };

    AccountQRPreviewViewController *qrPreviewVC = [[AccountQRPreviewViewController alloc] initWithShowInfo:showInfo];
    [self presentViewController:qrPreviewVC animated:YES completion:nil];
}

- (UIColor *)flagColorWithIndexPath:(NSIndexPath *)indexPath {
    return self.cellColorHexStrArray[(indexPath.row % self.cellColorHexStrArray.count)];
}

@end
