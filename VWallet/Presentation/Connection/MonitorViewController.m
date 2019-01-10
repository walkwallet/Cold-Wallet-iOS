//
//  MonitorTableViewController.m
//  Wallet
//
//  All rights reserved.
//

#import "MonitorViewController.h"
#import "CellItem.h"
#import "Language.h"
#import "SectionItem.h"
#import "NormalTableViewCell.h"
#import "DeviceState.h"
#import "ThemeButton.h"
#import "VColor.h"

static NSString *const VNormalTableViewCellIdentifier = @"NormalTableViewCell";

@interface MonitorViewController ()

@property (nonatomic, copy) NSArray<SectionItem *> *contentData;

@property (nonatomic, strong) void(^callback)(void);
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet ThemeButton *refreshBtn;

@end

@implementation MonitorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self updateContentData];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self.tableView registerNib:[UINib nibWithNibName:VNormalTableViewCellIdentifier bundle:nil] forCellReuseIdentifier:VNormalTableViewCellIdentifier];
    self.tableView.backgroundColor = VColor.rootViewBgColor;
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.descLabel.adjustsFontSizeToFitWidth = YES;
    self.titleLabel.text = VLocalize(@"connection_monitor_title");
    self.descLabel.text = VLocalize(@"connection_monitor_detail");
    [self.refreshBtn setTitle:VLocalize(@"connection_monitor_btn") forState:UIControlStateNormal];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.contentData.count;
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
    
    if (item.type == VNormalTableViewCellIdentifier) {
        [(NormalTableViewCell *)cell setupCellItem:item];
        return cell;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (IBAction)redetectionBtnClick:(id)sender {
    [self updateContentData];
    [self.tableView reloadData];
    self.callback();
}

- (void)redetectionCallback:(void(^)(void))callback {
    self.callback = callback;
}

- (void)updateContentData {
    
    NSArray <CellItem *> *cellItems1 = @[
        VCellItem(@"", VNormalTableViewCellIdentifier, @"WIFI", @"", [self getConnectionDescByStatus:[DeviceState shareInstance].wifiEnable], (@{@"titleColor": VColor.textColor, @"descColor": [self getConnectionColorByStatus:[DeviceState shareInstance].wifiEnable]})),
        VCellItem(@"", VNormalTableViewCellIdentifier, VLocalize(@"cellular"), @"", [self getConnectionDescByStatus:[DeviceState shareInstance].cellularEnable], (@{@"titleColor": VColor.textColor, @"descColor": [self getConnectionColorByStatus:[DeviceState shareInstance].cellularEnable]})),
        VCellItem(@"", VNormalTableViewCellIdentifier, VLocalize(@"bluetooth"), @"", [self getConnectionDescByStatus:[DeviceState shareInstance].bluetoothEnable], (@{@"titleColor": VColor.textColor, @"descColor": [self getConnectionColorByStatus:[DeviceState shareInstance].bluetoothEnable]})),
                                         ];
    NSArray *contentData = @[
                             VSectionItem(@"", cellItems1),
                             ];
    self.contentData = contentData;
}

- (NSString *)getConnectionDescByStatus:(BOOL)status {
    if (status) {
        return VLocalize(@"connected");
    }
    return VLocalize(@"unconnected");
}

- (UIColor *)getConnectionColorByStatus:(BOOL)status {
    if (status) {
        return VColor.redColor;
    } else {
        return VColor.greenColor;
    }
}
@end
