//
//  TradeConfirmTableViewController.m
//  Wallet
//
//  All rights reserved.
//

#import "TradeConfirmTableViewController.h"
#import "Language.h"
#import "VStoryboard.h"
#import "VColor.h"
#import "TradeInfoTableViewCell.h"
#import "TradeVerifyQRPreviewViewController.h"
#import "NavigationController.h"
#import "UIViewController+Alert.h"
#import "NSString+Decimal.h"
#import "VTransaction+Extension.h"

static NSString *const CellIdentifier = @"TradeInfoTableViewCell";

@interface TradeConfirmTableViewController ()

@property (nonatomic, copy) NSString *tradeInfo;
@property (nonatomic, strong) NSArray *showData;
@property (nonatomic, weak) VsysAccount *account;
/** transaction type：2.Payment 3.Lease 4.CancelLease */
//@property (nonatomic, assign) NSInteger transactionType;
@property (nonatomic, strong) VsysTransaction *vTransaction;

@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;

@end

@implementation TradeConfirmTableViewController

- (UINavigationController *)naviVC {
    return [[NavigationController alloc] initWithRootViewController:self];
}

- (instancetype)initWithTradeInfo:(NSString *)tradeInfo account:(nonnull VsysAccount *)account {
    self = [VStoryboard.Wallet instantiateViewControllerWithIdentifier:@"TradeConfirmTableViewController"];
    self.tradeInfo = tradeInfo;
    self.account = account;
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)initView {
    self.navigationItem.title = VLocalize(@"trade_confirm");
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ico_close"] style:UIBarButtonItemStylePlain target:self action:@selector(closeBtnClick)];
    
    self.tipLabel.text = VLocalize(@"trade_confirm_tip_text");
    [self.confirmBtn setTitle:VLocalize(@"confirm_transaction") forState:UIControlStateNormal];
    self.navigationItem.title = VLocalize(@"trade_confirm");
    self.tableView.backgroundColor = VColor.rootViewBgColor;
    [self.tableView setRowHeight:UITableViewAutomaticDimension];
    [self.tableView registerNib:[UINib nibWithNibName:CellIdentifier bundle:nil] forCellReuseIdentifier:CellIdentifier];
    
    if (self.tradeInfo.length) {
        NSError *error;
        NSDictionary *showInfoDict = [NSJSONSerialization JSONObjectWithData:[_tradeInfo dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:&error];
        if (error) {
            _showData = @[];
        } else {
            NSMutableArray *showData = [NSMutableArray array];
            
            if (self.account) {
                [showData addObject:@{@"title":VLocalize(@"trade_confirm_my_address"),
                                      @"value":[NSString stringWithFormat:@"%@", self.account.address]}];
            }
            
            NSString *recipientAddress = showInfoDict[@"recipient"];
            if (recipientAddress.length) {
                [showData addObject:@{@"title":VLocalize(@"trade_confirm_recipient_address"),
                                      @"value":recipientAddress?:@"-"}];
            }
            ino64_t amount = [showInfoDict[@"amount"] integerValue];
            
            NSInteger transactionType = [showInfoDict[@"transactionType"] integerValue];
            if (transactionType >= 2 && transactionType <= 4) {
                NSString *transactionId = showInfoDict[@"txId"];
                if (transactionType == 2 && recipientAddress.length) {
                    _vTransaction = VsysNewPaymentTransaction(recipientAddress, amount);
                } else if (transactionType == 3 && recipientAddress.length) {
                    _vTransaction = VsysNewLeaseTransaction(recipientAddress, amount);
                } else if (transactionType == 4 && transactionId.length) {
                    _vTransaction = VsysNewCancelLeaseTransaction(transactionId);
                }
                
                [showData addObject:@{@"title":VLocalize(@"trade_confirm_transaction_type"),
                                      @"value":[_vTransaction typeDesc]}];
            }
            
            if (amount > 0) {
                NSString *amountStr = [NSString stringWithDecimal:(amount * 1.0 / VsysVSYS) maxFractionDigits:8 minFractionDigits:2 trimTrailing:YES];
                [showData addObject:@{@"title":VLocalize(@"trade_confirm_amount"),
                                      @"value":[NSString stringWithFormat:@"%@ VCoin", amountStr]}];
            }
            
            ino64_t fee = [showInfoDict[@"fee"] integerValue];
            if (fee > 0) {
                NSString *feeStr = [NSString stringWithDecimal:(fee * 1.0 / VsysVSYS) maxFractionDigits:8 minFractionDigits:2 trimTrailing:YES];
                [showData addObject:@{@"title":VLocalize(@"trade_confirm_poundage"),
                                      @"value":[NSString stringWithFormat:@"%@ VCoin", feeStr]}];
                self.vTransaction.fee = fee;
                self.vTransaction.feeScale = [showInfoDict[@"feeScale"] integerValue];
            }
            
            long timestamp = [showInfoDict[@"timestamp"] longValue];
            if (timestamp > 0) {
                if (timestamp > (long)10000000000000) {
                    timestamp /= 1000000;
                }
                NSDateFormatter *df = [[NSDateFormatter alloc] init];
                df.dateFormat = @"yyyy-MM-dd HH:mm:ss";
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:timestamp / 1000.0];
                [showData addObject:@{@"title":VLocalize(@"trade_confirm_time"),
                                      @"value":[NSString stringWithFormat:@"%@ (%@)", [df stringFromDate:date], VLocalize(@"trade_confirm_china_standard_time")]}];
                self.vTransaction.timestamp = timestamp * 1000000;
            }
            
            NSString *attachment = [[NSString alloc] initWithData:VsysBase58Decode([showInfoDict[@"attachment"] dataUsingEncoding:NSUTF8StringEncoding]) encoding:NSUTF8StringEncoding];
            if (attachment.length) {
                [showData addObject:@{@"title":VLocalize(@"trade_confirm_remark"),
                                      @"value":attachment}];
                self.vTransaction.attachment = [attachment dataUsingEncoding:NSUTF8StringEncoding];
            }
            _showData = showData.copy;
        }
    } else {
        _showData = @[];
    }
    [self.tableView reloadData];
}

- (void)closeBtnClick {
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.showData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TradeInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.showInfo = self.showData[indexPath.row];
    return cell;
}

#pragma mark - Comfirm
- (IBAction)confirmBtnClick {
    if (!self.account) {
        return;
    }
    if (!self.vTransaction) {
        [self alertWithTitle:VLocalize(@"trade_confirm_unsupported_transaction_type_tip_text") confirmText:nil];
        return;
    }
    NSString *signature = [self.account signData:self.vTransaction.buildTxData];
    NSDictionary *dict = @{@"protocol": VsysProtocol,
                           @"api": @(VsysApi),
                           @"opc": VsysOpcTypeSignature,
                           @"signature": signature
                           };
    NSString *qrcodeStr = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
    __weak typeof(self) weakSelf = self;
    TradeVerifyQRPreviewViewController *qrPreviewVC = [[TradeVerifyQRPreviewViewController alloc] initWithTitle:VLocalize(@"trade_verify_title") desc:VLocalize(@"trade_verify_desc") qrCodeStr:qrcodeStr complete:^{
        [weakSelf closeBtnClick];
    }];
    [self presentViewController:qrPreviewVC animated:YES completion:nil];
}

@end
