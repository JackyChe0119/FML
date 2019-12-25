//
//  allAssetViewController.m
//  FML
//
//  Created by 车杰 on 2018/7/18.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "allAssetViewController.h"
#import "touZiListCell.h"
#import "InvestModel.h"
#import "MJRefresh.h"
#import "CurrencyDetailViewController.h"

@interface allAssetViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView*      tableView;
@property (nonatomic, strong) NSMutableArray<InvestModel *>*   models;
@property (nonatomic, assign) int               pageNum;

@end

@implementation allAssetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _models = [NSMutableArray array];
    [self layoutUI];
    _pageNum = -1;
    [self recIOC:_pageNum];
    
}

- (void)layoutUI {
    [self NavigationItemTitle:@"资产优选" Color:Color1D];
    [self navgationLeftButtonImage:backUp];
    
    _tableView = [[UITableView alloc]initWithFrame:RECT(0, NavHeight, ScreenWidth, ScreenHeight-NavHeight) style:1];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.bounces = YES;
    _tableView.backgroundColor = ColorBg;
    [_tableView registerNib:[UINib nibWithNibName:@"touZiListCell" bundle:nil] forCellReuseIdentifier:@"touZiListCell"];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    __weak typeof(self) weakSelf = self;
    [_tableView addHeaderWithCallback:^{
        weakSelf.pageNum = 0;
        [weakSelf recIOC:weakSelf.pageNum];
    }];
    [_tableView addFooterWithCallback:^{
        if (weakSelf.pageNum == -1) {
            [weakSelf showToastHUD:@"没有更多数据了"];
            [weakSelf.tableView.footer endRefreshing];
        } else {
            [weakSelf recIOC:weakSelf.pageNum];
        }
    }];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _models.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 145;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *baseView = [UIView createViewWithFrame:RECT(0, 0, ScreenWidth, 0.1) color:ColorGray];
    return baseView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    touZiListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"touZiListCell"];
    cell.model = _models[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    CurrencyDetailViewController* vc = [CurrencyDetailViewController new];
    vc.icoId = _models[indexPath.row].icoId;
    vc.currencyName = _models[indexPath.row].currenctyName;
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)recIOC:(int)pageNum {
    if (pageNum == -1) {
        [self showProgressHud];
        _pageNum = pageNum = 0;
    }
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    dict[@"pageNum"] = @(pageNum);
    RequestMessage* msg = [[RequestMessage alloc] initWithUrl:@"currency_invest/top_list.htm".apifml method:POST args:dict];
    [RequestEngine doRqquestWithMessage:msg callbackBlock:^(ResponseMessage *responseMessage) {
        [self hiddenProgressHud];
        if (responseMessage.errorMessage) {
            [self showToastHUD:responseMessage.errorMessage];
        } else {
            if (pageNum == 0) {
                [_models removeAllObjects];
            }
 
            _pageNum = pageNum + 1;
            //            _pageNum = (pageNum + 1 < responseMessage.totalPage) ? pageNum + 1 : -1;
            //            if (_pageNum == -1) {
            //            }
            NSArray* array = [InvestModel arrayToModel:responseMessage.bussinessData];
            if (array.count == 0) {
                _pageNum = -1;
            }
            [_models addObjectsFromArray:[InvestModel arrayToModel:responseMessage.bussinessData]];
            [self.tableView reloadData];
            [self.tableView.footer endRefreshing];
            [self.tableView.header endRefreshing];
        }
    }];
}

@end
