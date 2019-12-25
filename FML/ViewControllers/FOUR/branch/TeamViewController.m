//
//  TeamViewController.m
//  FML
//
//  Created by 车杰 on 2018/8/24.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "TeamViewController.h"
#import "BranchTableViewCell.h"
#import "TeamBranchTopView.h"
@interface TeamViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *data;
@end

@implementation TeamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self NavigationItemTitle:@"团队信息" Color:Color1D];
    [self navgationLeftButtonImage:backUp];
    [self.view addSubview:self.tableView];
    self.currentPage = 0;
    if (self.isMyTeam) {
        [self getTeamList:0];
    }else {
        [self getOtherTeamList:0];
    }
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:RECT(0, NavHeight, ScreenWidth, ScreenHeight-NavHeight) style:0];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = ColorBg;
        [_tableView setSeparatorColor:ColorLine];
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0, 60, 0, 0  )];
        [_tableView registerNib:[UINib nibWithNibName:@"BranchTableViewCell" bundle:nil] forCellReuseIdentifier:@"BranchTableViewCell"];
        _tableView.tableHeaderView = [self tableViewHeaderView];
        _tableView.tableFooterView = [UIView new];

        [self addRefreshFooter:_tableView];

    }
    return _tableView;
}
- (void)loadMoreData:(NSInteger)page {
    if (self.isMyTeam) {
        [self getTeamList:page];
    }else {
        [self getOtherTeamList:page];
    }
    
}
- (void)getTeamList:(int)pageNum {
    if (pageNum==0) {
        [self showProgressHud];
    }
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    dict[@"pageNum"] = @(pageNum);
    RequestMessage* msg = [[RequestMessage alloc] initWithUrl:@"item/item_numbers.htm".apifml method:POST args:dict];
    [RequestEngine doRqquestWithMessage:msg callbackBlock:^(ResponseMessage *responseMessage) {
        if (pageNum==0) {
            [self hiddenProgressHud];
        }else {
            [self endRefreshControlLoading];
        }
        if (responseMessage.errorMessage) {
            [self showToastHUD:responseMessage.errorMessage];
        } else {
            if (pageNum == 0) {
                [self.data removeAllObjects];
            }
            NSArray* array = [TeamUserModel arrayToModel:responseMessage.bussinessData];
            if (array.count == 0) {
                [self setCurrentPageEqualTotalPage];
            }else {
                [self setCurrentPageLessTotalPage];
            }
            [self.data addObjectsFromArray:array];
            if (self.data .count==0) {
                UILabel *label = [UILabel new];
                [label rect:RECT(ScreenWidth/2.0-100, 100, 200, 20) aligment:Center font:14 isBold:NO text:@"暂无团队成员信息" textColor:ColorGrayText superView:nil];
                self.tableView.backgroundView =label;
            }else {
                self.tableView.backgroundView =[UIView new];
            }
            [self.tableView reloadData];
        }
    }];
}
- (void)getOtherTeamList:(int)pageNum {
    if (pageNum==0) {
        [self showProgressHud];
    }
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    dict[@"pageNum"] = @(pageNum);
    RequestMessage* msg = [[RequestMessage alloc] initWithUrl:@"item/persion_numbers.htm".apifml method:POST args:dict];
    [RequestEngine doRqquestWithMessage:msg callbackBlock:^(ResponseMessage *responseMessage) {
        if (pageNum==0) {
            [self hiddenProgressHud];
        }else {
            [self endRefreshControlLoading];
        }
        if (responseMessage.errorMessage) {
            [self showToastHUD:responseMessage.errorMessage];
        } else {
            if (pageNum == 0) {
                [self.data removeAllObjects];
            }
            NSArray* array = [TeamUserModel arrayToModel:responseMessage.bussinessData];
            if (array.count == 0) {
                [self setCurrentPageEqualTotalPage];
            }else {
                [self setCurrentPageLessTotalPage];
            }
            [self.data  addObjectsFromArray:array];
            if (self.data .count==0) {
                UILabel *label = [UILabel new];
                [label rect:RECT(ScreenWidth/2.0-100, 100, 200, 20) aligment:Center font:14 isBold:NO text:@"暂无团队成员信息" textColor:ColorGrayText superView:nil];
                self.tableView.backgroundView =label;
            }else {
                self.tableView.backgroundView =[UIView new];
            }
            [self.tableView reloadData];
        }
    }];
}
- (UIView *)tableViewHeaderView {
    UIView *baseView = [[UIView alloc]init];
    TeamBranchTopView *view;
    if (self.isMyTeam) {
        baseView.frame = RECT(0, 0, ScreenWidth, 120);
        view  = [[TeamBranchTopView alloc]initWithFrame:RECT(0, 20, ScreenWidth, 100) type:1];
        view.shouyi = self.shouyi;
        view.num = self.num;
    }else {
        baseView.frame = RECT(0, 0, ScreenWidth, 160);
        view  = [[TeamBranchTopView alloc]initWithFrame:RECT(0, 20, ScreenWidth, 140) type:2];
        view.email = self.email;
        view.num = self.num;
    }
    [baseView addSubview:view];
    return baseView;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BranchTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"BranchTableViewCell" forIndexPath:indexPath];
    TeamUserModel *model = _data[indexPath.row];
    cell.model = model;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65;
}
- (NSMutableArray *)data {
    if (!_data) {
        _data = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return _data;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
