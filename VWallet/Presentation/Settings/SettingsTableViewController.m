//
//  SettingsTableViewController.m
//  Wallet
//
//  All rights reserved.
//

#import "SettingsTableViewController.h"
#import "CellItem.h"
#import "Language.h"
#import "SectionItem.h"
#import "ArrowTableViewCell.h"
#import "SwitchTableViewCell.h"
#import "NormalTableViewCell.h"
#import "SectionHeaderView.h"
#import "AppState.h"
#import "TouchIDTool.h"
#import "UIViewController+Alert.h"
#import "WalletMgr.h"
#import "VColor.h"
#import "WindowManager.h"
#import "MnemonicWordBackupViewController.h"
#import "VStoryboard.h"
#import "PasswordInputViewController.h"
#import "AlertViewController.h"
#import "PasswordInputModel.h"
#import "PasswordAuthAlertViewController.h"

static NSString *const VSwitchTableViewCellIdentifier = @"SwitchTableViewCell";
static NSString *const VArrowTableViewCellIdentifier = @"ArrowTableViewCell";
static NSString *const VSectionHeaderViewIdentifier = @"SectionHeaderView";
static NSString *const VNormalTableViewCellIdentifier = @"NormalTableViewCell";

@interface SettingsTableViewController () <TableViewCellDelegate>

@property (nonatomic, copy) NSArray<SectionItem *> *contentData;
@end

@implementation SettingsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = VLocalize(@"tabbar_page_title_1");
    if (@available(iOS 11.0, *)) {
        self.navigationItem.largeTitleDisplayMode = UINavigationItemLargeTitleDisplayModeAlways;
    }
    self.tableView.backgroundColor = VColor.rootViewBgColor;
    self.tableView.separatorColor = VColor.rootViewBgColor;
    
    [self initContentData];

    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerNib:[UINib nibWithNibName:VSwitchTableViewCellIdentifier bundle:nil] forCellReuseIdentifier:VSwitchTableViewCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:VArrowTableViewCellIdentifier bundle:nil] forCellReuseIdentifier:VArrowTableViewCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:VNormalTableViewCellIdentifier bundle:nil] forCellReuseIdentifier:VNormalTableViewCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:VSectionHeaderViewIdentifier bundle:nil] forHeaderFooterViewReuseIdentifier:VSectionHeaderViewIdentifier];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contentData[section].cellItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.contentData.count <= indexPath.section || self.contentData[indexPath.section].cellItems.count <= indexPath.row) {
        return nil;
    }

    CellItem *item = self.contentData[indexPath.section].cellItems[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:item.type forIndexPath:indexPath];

    if (item.type == VArrowTableViewCellIdentifier) {
        [(ArrowTableViewCell *)cell setupCellItem:item];
        ((ArrowTableViewCell *)cell).delegate = self;
        return cell;
    }
    
    if (item.type == VSwitchTableViewCellIdentifier) {
        [(SwitchTableViewCell *)cell setupCellItem:item];
        ((SwitchTableViewCell *)cell).delegate = self;
        return cell;
    }
    
    if (item.type == VNormalTableViewCellIdentifier) {
        [(NormalTableViewCell *)cell setupCellItem:item];
        return cell;
    }
    
    return nil;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    SectionItem *item = self.contentData[section];
    if (item.title.length > 0) {
        SectionHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:VSectionHeaderViewIdentifier];
        view.titleLabel.text = item.title;
        return view;
    }
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 52;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CellItem *item = self.contentData[indexPath.section].cellItems[indexPath.row];
    if ([item.identifier isEqualToString:@"auto_backup"] || [item.identifier isEqualToString:@"connection"]) {
        return 64;
    } else {
        return 48;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CellItem *item = self.contentData[indexPath.section].cellItems[indexPath.row];
    if ([item.identifier isEqualToString:@"backup_phrase"]) {
        __weak typeof(self) weakSelf = self;
        PasswordInputModel *model = [[PasswordInputModel alloc] init];
        model.title = VLocalize(@"settings_backup");
        model.placeholder = VLocalize(@"password_auth_placeholder");
        PasswordAuthAlertViewController *vc = [[PasswordAuthAlertViewController alloc] initWithModel:model];
        [vc showPasswordAlert:self result:^(BOOL success) {
            if (success) {
                [weakSelf dismissViewControllerAnimated:NO completion:nil];
                NSArray<NSString *> *mnemonicWordArray = [WalletMgr.shareInstance.seed componentsSeparatedByString:@" "];
                MnemonicWordBackupViewController *backupVC = [[MnemonicWordBackupViewController alloc] initWithMnemonicWordArray:mnemonicWordArray createWallet:NO];
                [weakSelf.navigationController pushViewController:backupVC animated:YES];
            }
        }];
        return;
    }
    
    if ([item.identifier isEqualToString:@"logout"]) {
        AlertViewController *vc = [[AlertViewController alloc] initWithTitle:VLocalize(@"logout_tip_title") secondTitle:VLocalize(@"logout_tip_detail") contentView:nil cancelTitle:VLocalize(@"cancel") confirmTitle:VLocalize(@"logout_confirm") cancel:^{
            
        } confirm:^{
            AppState.shareInstance.hasWallet = NO;
            AppState.shareInstance.autoBackupEnable = YES;
            AppState.shareInstance.connectionCheckEnable = YES;
            [WalletMgr.shareInstance clearPropertyValue];
            //            NSError *error = [[WalletMgr shareInstance] logoutWallet];
            //            if (error) {
            //                NSLog(@"logout wallet error: %@", error);
            //            }
            [WindowManager changeToRootViewController:VStoryboard.Generate.instantiateInitialViewController];
        }];
        [self presentViewController:vc animated:YES completion:nil];
        return;
    }
    
    if ([item.identifier isEqualToString:@"about"]) {
        UIViewController *vc = [[UIStoryboard storyboardWithName:@"About" bundle:nil] instantiateInitialViewController];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    if ((indexPath.section == 0 && indexPath.row == 0)
        || (indexPath.section == 2 && indexPath.row == 1)
        || (indexPath.section == 2 && indexPath.row == 2)) {
        return YES;
    }
    return NO;
}


- (void)cellActionWithType:(NSInteger)type item:(CellItem *)item {
    if ([item.identifier isEqualToString:@"auto_backup"]) {
        [[AppState shareInstance] setAutoBackupEnable:[item.dict[@"switcher"] boolValue]];
        if ([item.dict[@"switcher"] boolValue]) {
            [WalletMgr.shareInstance saveToStorage];
        }
        return;
    }
    if ([item.identifier isEqualToString:@"connection"]) {
        [[AppState shareInstance] setConnectionCheckEnable:[item.dict[@"switcher"] boolValue]];
        return;
    }
}

- (void)initContentData {
    NSArray <CellItem *> *cellItems1 = @[
      VCellItem(@"backup_phrase", VArrowTableViewCellIdentifier, VLocalize(@"settings_backup"), @"ico_backup_word", VLocalize(@"settings_backup_directly"), @{}),
      VCellItem(@"auto_backup", VSwitchTableViewCellIdentifier, VLocalize(@"settings_auto_backup_title"), @"ico_backup_auto", VLocalize(@"settings_auto_backup_desc"), @{@"switcher":@([[AppState shareInstance] autoBackupEnable])})
      ];
    
    NSArray <CellItem *> *cellItems2 = @[
     VCellItem(@"connection", VSwitchTableViewCellIdentifier, VLocalize(@"settings_connection_monitor_title"), @"ico_monitor", VLocalize(@"settings_connection_monitor_desc"), @{@"switcher":@([[AppState shareInstance] connectionCheckEnable])})
     ];
    
    
    NSArray <CellItem *> *cellItems3 = @[
     VCellItem(@"", VArrowTableViewCellIdentifier, VLocalize(@"settings_network"), @"ico_web", [WalletMgr.shareInstance networkDescription], (@{@"no_arrow":@(YES), @"descColor": VColor.textSecondColor})),
     VCellItem(@"about", VArrowTableViewCellIdentifier, VLocalize(@"settings_about_us"), @"ico_about", @"", @{}),
     VCellItem(@"logout", VNormalTableViewCellIdentifier, VLocalize(@"settings_logout_wallet"), @"ico_cancel", @"", @{})
     ];
    
    NSArray *contentData = @[
         VSectionItem(VLocalize(@"settings_wallet_manager"), cellItems1),
         VSectionItem(VLocalize(@"settings_secure_manager"), cellItems2),
         VSectionItem(VLocalize(@"settings_other"), cellItems3),
    ];
    self.contentData = contentData;
}

@end
