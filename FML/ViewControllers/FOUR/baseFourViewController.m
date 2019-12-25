#import "baseFourViewController.h"
#import "MineTopView.h"
#import "MineViewController.h"
#import "WebViewController.h"
#import "QuantizationViewController.h"
#define cellHeight 55

@interface baseFourViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSArray<NSArray *>*  cellTitles;
@property (nonatomic, strong) NSArray<NSArray *>*  cellImages;
@property (nonatomic, strong) NSArray<NSArray *>*  controllers;
@property (nonatomic, strong) UITableView*         tableView;
@property (nonatomic, strong) MineTopView*         tableHeaderView;

@end

@implementation baseFourViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UserSingle sharedUser] login:^{
        [self.tableHeaderView reloadData];
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.cellImages.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cellImages[section].count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"id"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"id"];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:16];
    cell.textLabel.textColor = Color1D;
    cell.textLabel.text = self.cellTitles[indexPath.section][indexPath.row];
    cell.imageView.image = [UIImage imageNamed:self.cellImages[indexPath.section][indexPath.row]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @" ";
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1f;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return @" ";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    if (indexPath.row==0&&indexPath.section==0) {
//        [self showToastHUD:@"敬请期待"];
//        return;
//    }
    if (indexPath.section == 2 && indexPath.row == 0) {
        WebViewController* vc = [WebViewController new];
        vc.webTitle = @"用户协议";
        vc.url = @"http://apifml.manggeek.com/agreement.html";
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    id vc = [NSClassFromString(self.controllers[indexPath.section][indexPath.row]) new];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -- lazy

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableHeaderView = self.tableHeaderView;
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = RGB_A(248, 248, 248, 1);
    }
    return _tableView;
}

- (MineTopView *)tableHeaderView {
    if (!_tableHeaderView) {
        _tableHeaderView = [[MineTopView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 150)];
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mineVC)];
        [_tableHeaderView addGestureRecognizer:tap];
    }
    return _tableHeaderView;
}

- (void)mineVC {
    MineViewController* mine = [MineViewController new];
    [self.navigationController pushViewController:mine animated:YES];
}

- (NSArray<NSArray *> *)cellImages {
    if (!_cellImages) {
        _cellImages = @[@[@"icon_lianghua"],@[ @"mineCellImage3"],
                        @[@"mineCellImage4", @"mineCellImage5"],
                        @[@"mineCellImage6"]];
    }
    return _cellImages;
}

- (NSArray<NSArray *> *)cellTitles {
    if (!_cellTitles) {
        _cellTitles = @[@[@"量化记录"],@[@"安全中心"],
                        @[@"用户协议", @"关于我们"],
                        @[@"系统设置"]];
    }
    return _cellTitles;
}

- (NSArray<NSArray *> *)controllers {
    if (!_controllers) {
        _controllers = @[@[@"QuantizationViewController"],@[@"SafeCenterViewController"],
                         @[@"AgreementViewController", @"AboutWeViewController"],
                         @[@"SystemSetViewController"]];
    }
    return _controllers;
}

@end
