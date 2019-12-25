//
//  ReleaseViewController.m
//  FML
//
//  Created by apple on 2018/7/24.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "ReleaseViewController.h"
#import "ReleaseTableViewCell.h"
#import "AgreementViewController.h"
#import "MJRefresh.h"
#import "ReleaseListModel.h"
#import "DateUtil.h"
#import "MaidTableViewCell.h"

static NSString* const ID = @"id";

@interface ReleaseViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView*         tableView;
@property (nonatomic, strong) NSMutableArray<ReleaseListModel *>*   models;
@property (nonatomic, assign) int               pageNum;


@end

@implementation ReleaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self NavigationItemTitle:@"分佣详情" Color:Color1D];
    [self navgationLeftButtonImage:backUp];
    [self navgationRightButtonImage:@"icon_iiii"];
    
    _models = [NSMutableArray array];
    //    [self layoutUI];
    _pageNum = -1;
    //    [self mybranch:_pageNum];
    [self mybranch:_pageNum];
    
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    self.tabBarController.tabBar.hidden = YES;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _models.count;
//    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MaidTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    cell.model = _models[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NavHeight, ScreenWidth, ScreenHeight - NavHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = RGB_A(248, 248, 248, 1);
        _tableView.estimatedRowHeight = 100;
        [_tableView registerNib:[UINib nibWithNibName:@"MaidTableViewCell" bundle:nil] forCellReuseIdentifier:ID];

        __weak typeof(self) weakSelf = self;
        [_tableView addHeaderWithCallback:^{
            weakSelf.pageNum = 0;
            [weakSelf mybranch:weakSelf.pageNum];
        }];
        [_tableView addFooterWithCallback:^{
            if (weakSelf.pageNum == -1) {
                [weakSelf showToastHUD:@"没有更多数据了"];
                [weakSelf.tableView.footer endRefreshing];
            } else {
                [weakSelf mybranch:weakSelf.pageNum];
            }
        }];
    }
    return _tableView;
}

#pragma mark -- click

- (void)navgationRightButtonClick {
    AgreementViewController* vc = [AgreementViewController new];
    vc.type = FMLAgreementTypeFYXS;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)mybranch:(int)pageNum {
    if (pageNum == -1) {
        [self showProgressHud];
        _pageNum = pageNum = 0;
    }
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    dict[@"pageNum"] = @(pageNum);
    dict[@"sysCurrencyId"] = @(_currencyId);
    
    RequestMessage* msg = [[RequestMessage alloc] initWithUrl:@"commission/commiss_list.htm".apifml method:POST args:dict];
    [RequestEngine doRqquestWithMessage:msg callbackBlock:^(ResponseMessage *responseMessage) {
        [self hiddenProgressHud];
        if (responseMessage.errorMessage) {
            [self showToastHUD:responseMessage.errorMessage];
        } else {
            if (pageNum == 0) {
                [_models removeAllObjects];
            }
            _pageNum = pageNum + 1;
            NSArray* array = [ReleaseListModel arrayToModel:responseMessage.bussinessData];
            if (array.count == 0) {
                _pageNum = -1;
            }
            [_models addObjectsFromArray:[ReleaseListModel arrayToModel:responseMessage.bussinessData]];
            [self.tableView reloadData];
            [self.tableView.footer endRefreshing];
            [self.tableView.header endRefreshing];
        }
    }];
}


@end
