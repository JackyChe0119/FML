//
//  MyBranchViewController.m
//  FML
//
//  Created by apple on 2018/7/24.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "MyBranchViewController.h"
#import "MyBranchTableViewCell.h"
#import "ReleaseViewController.h"
#import "TeamBranchViewController.h"
#import "MJRefresh.h"
#import "MyBranchListModel.h"

static NSString* const ID = @"id";

@interface MyBranchViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView*         tableView;
@property (nonatomic, strong) NSMutableArray<MyBranchListModel *>*   models;
@property (nonatomic, assign) int               pageNum;

@end

@implementation MyBranchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self NavigationItemTitle:@"节点收益" Color:Color1D];
    [self navgationLeftButtonImage:backUp];
//    [self navgationRightButtonImage:@"team_branch"];
    
    [self.view addSubview:self.tableView];
    _models = [NSMutableArray array];
//    [self layoutUI];
    _pageNum = 0;
//    [self mybranch:_pageNum];
    [self mybranch];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    self.tabBarController.tabBar.hidden = YES;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MyBranchTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    cell.model = _models[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    ReleaseViewController* vc = [ReleaseViewController new];
    vc.currencyId = _models[indexPath.row].currencyId;
    [self.navigationController pushViewController:vc animated:YES];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NavHeight, ScreenWidth, ScreenHeight - NavHeight) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [UIView new];
        _tableView.backgroundColor = RGB_A(248, 248, 248, 1);
        [_tableView registerClass:[MyBranchTableViewCell class] forCellReuseIdentifier:ID];
//        __weak typeof(self) weakSelf = self;
//        [_tableView addHeaderWithCallback:^{
//            weakSelf.pageNum = 0;
//            [weakSelf mybranch:weakSelf.pageNum];
//        }];
//        [_tableView addFooterWithCallback:^{
//            if (weakSelf.pageNum == -1) {
//                [weakSelf showToastHUD:@"没有更多数据了"];
//                [weakSelf.tableView.footer endRefreshing];
//            } else {
//                [weakSelf mybranch:weakSelf.pageNum];
//            }
//        }];
    }
    return _tableView;
}

#pragma mark -- click

- (void)navgationRightButtonClick {
    TeamBranchViewController* vc = [TeamBranchViewController new];
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
            
            if (_models.count != 0) {
                if (![_models[0].currencyName isEqualToString:@"ETH"]) {
                    [_models enumerateObjectsUsingBlock:^(MyBranchListModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if ([obj.currencyName isEqualToString:@"ETH"]) {
                            [_models removeObject:obj];
                            *stop = YES;
                        }
                    }];
                }
            }
            [self.tableView reloadData];
        }
    }];
}

@end
