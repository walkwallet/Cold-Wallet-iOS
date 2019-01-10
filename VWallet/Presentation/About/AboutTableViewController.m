//
//  AboutTableViewController.m
//  Wallet
//
//  All rights reserved.
//

#import "AboutTableViewController.h"
#import "VColor.h"
#import "Language.h"

@interface AboutTableViewController ()
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;

@end

@implementation AboutTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
}

- (void)initView {
    self.title = VLocalize(@"settings_about_us");
    self.tableView.backgroundColor = VColor.rootViewBgColor;
    self.versionLabel.text = [NSString stringWithFormat:@"%@ %@", VLocalize(@"version_title"), [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    self.descLabel.text = VLocalize(@"version_desc");
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (@available(iOS 11, *)) {
        NSMutableDictionary *dict = [self.navigationController.navigationBar.largeTitleTextAttributes mutableCopy];
        dict[NSForegroundColorAttributeName] = [UIColor colorWithWhite:1.f alpha:0.f];
        self.navigationController.navigationBar.largeTitleTextAttributes = dict;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (@available(iOS 11, *)) {
        NSMutableDictionary *dict = [self.navigationController.navigationBar.largeTitleTextAttributes mutableCopy];
        dict[NSForegroundColorAttributeName] = [UIColor colorWithWhite:1.f alpha:1.f];
        self.navigationController.navigationBar.largeTitleTextAttributes = dict;
    }
}

@end
