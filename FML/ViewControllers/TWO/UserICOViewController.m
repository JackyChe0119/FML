//
//  UserICOViewController.m
//  FML
//
//  Created by apple on 2018/7/19.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "UserICOViewController.h"
#import "UserICOTableViewCell.h"
#import "CurrencyIncomeViewController.h"
#import "UserICOOrderViewController.h"
#import "MyBranchListModel.h"

static NSString* const ID = @"id";
@interface UserICOViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic, strong) NSMutableArray<MyBranchListModel *>*   models;

@end

@implementation UserICOViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    _models = [NSMutableArray array];
    [self layoutUI];
    [self mybranch];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    self.tabBarController.tabBar.hidden = YES;
}

- (void)layoutUI {
    [self NavigationItemTitle:@"我的ICO资产" Color:Color1D];
    [self navgationRightButtonImage:@"icon_ico_order"];
    [self navgationLeftButtonImage:backUp];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NavHeight, ScreenWidth, ScreenHeight - NavHeight) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.bounces = YES;
    _tableView.backgroundColor = ColorBg;
    [_tableView registerClass:[UserICOTableViewCell class] forCellReuseIdentifier:ID];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
}

- (void)navgationRightButtonClick {
    UserICOOrderViewController* vc = [UserICOOrderViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark -- delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _models.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserICOTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    cell.model = _models[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CurrencyIncomeViewController* vc = [CurrencyIncomeViewController new];
//    vc.walletCardId = _models[indexPath.row].walletCardId;
    vc.model = _models[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)mybranch {
    [self showProgressHud];
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    //    dict[@"pageNum"] = @(pageNum);
    RequestMessage* msg = [[RequestMessage alloc] initWithUrl:@"commission/group_commiss.htm".apifml method:POST args:dict];
    [RequestEngine doRqquestWithMessage:msg callbackBlock:^(ResponseMessage *responseMessage) {
        [self hiddenProgressHud];
        if (responseMessage.errorMessage) {
            [self showToastHUD:responseMessage.errorMessage];
        } else {
            [_models addObjectsFromArray:[MyBranchListModel arrayToModel:responseMessage.bussinessData]];
            [self.tableView reloadData];
        }
    }];
}

@end
