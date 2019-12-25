//
//  CurrencyDetailViewController.m
//  XjBaseProject
//
//  Created by apple on 2018/7/18.
//  Copyright © 2018年 xjhuang. All rights reserved.
//

#import "CurrencyDetailViewController.h"
#import "TransactionTableViewCell.h"
#import "CurrencyDetailView.h"
#import "RechargeViewController.h"
#import "ExportViewController.h"
#import "exChangeViewController.h"
static NSString* const ID = @"TransactionTableViewCell";

@interface CurrencyDetailViewControllernew ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) CurrencyDetailView* topView;


@end

@implementation CurrencyDetailViewControllernew

- (void)viewDidLoad {
    [super viewDidLoad];
    self.customNavView.backgroundColor = colorWithHexString(@"#548efa");
    [self NavigationItemTitle:@"ETH" Color:[UIColor whiteColor]];
    [self navgationLeftButtonImage:@"icon_backup_white"];
    [self navgationRightButtonTitle:@"兑换" color:ColorWhite];
    [self.view addSubview:self.tableView];
    [self.view addSubview:[self bottomView]];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}
- (void)navgationRightButtonClick {
    //兑换
    exChangeViewController *vc = [[exChangeViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark -- delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TransactionTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
     return [self sectionView:@"交易记录"];
}

- (UIView *)sectionView:(NSString *)title {
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
    view.backgroundColor = [UIColor whiteColor];
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, ScreenWidth, 40)];
    label.text = title;
    label.font = [UIFont systemFontOfSize:20];
    [view addSubview:label];
    
    return view;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NavHeight, ScreenWidth, ScreenHeight-NavHeight-50) style:UITableViewStylePlain];
        _tableView.backgroundColor = ColorWhite;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.rowHeight = 100;
        [_tableView registerClass:[TransactionTableViewCell class] forCellReuseIdentifier:ID];
        _tableView.tableHeaderView = [self tableHeaderView];
    }
    return _tableView;
}

- (UIView *)tableHeaderView {
    UIView* view = [UIView new];
    view.backgroundColor = colorWithHexString(@"#548efa");    
    _topView = [[CurrencyDetailView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0)];
    [view addSubview:_topView];
    view.frame = CGRectMake(0, -20, ScreenWidth, BOTTOM(_topView));
    return view;
}

- (UIView *)bottomView {
    CGFloat viewHeight = 50 ;
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight - viewHeight, ScreenWidth, viewHeight)];
    view.backgroundColor = [UIColor whiteColor];
    
    UIButton* accountsBtn = [[UIButton alloc] initWithFrame:CGRectMake(7, 0, (ScreenWidth-21) / 2.0, 43)];
    [accountsBtn setTitle:@"转入" forState:UIControlStateNormal];
    [accountsBtn setTitleColor:ColorBlue forState:UIControlStateNormal];
    [accountsBtn addTarget:self action:@selector(chongzhiButtonClick) forControlEvents:UIControlEventTouchUpInside];
    accountsBtn.layer.cornerRadius = 5;
    accountsBtn.layer.masksToBounds = YES;
    accountsBtn.layer.borderWidth = .5;
    accountsBtn.layer.borderColor = ColorBlue.CGColor;
    accountsBtn.titleLabel.font = FONT(15);
    [view addSubview:accountsBtn];
    
    UIButton* receivablesBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth / 2.0+3.5, 0, (ScreenWidth-21) / 2.02, 43)];
    [receivablesBtn setTitle:@"转出" forState:UIControlStateNormal];
    receivablesBtn.backgroundColor = ColorBlue;
    [receivablesBtn addTarget:self action:@selector(zhuanzhangButtonClick) forControlEvents:UIControlEventTouchUpInside];
    receivablesBtn.titleLabel.font = FONT(15);
    receivablesBtn.layer.cornerRadius = 5;
    receivablesBtn.layer.masksToBounds = YES;
    [view addSubview:receivablesBtn];
    return view;
}
- (void)zhuanzhangButtonClick {
    //转出
    ExportViewController *vc = [[ExportViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
    [vc setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [self presentViewController:nav animated:YES completion:nil];
    
}
- (void)chongzhiButtonClick {
    //转入
    RechargeViewController *vc = [[RechargeViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:vc];
    [vc setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [self presentViewController:nav animated:YES completion:nil];
    
}
@end
