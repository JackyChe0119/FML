//
//  RecordViewController.m
//  FML
//
//  Created by apple on 2018/8/14.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "RecordViewController.h"
#import "MJRefresh.h"
#import "TransactionTableViewCell.h"

static NSString* const ID = @"id";

@interface RecordViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic, strong) NSMutableArray*   models;
@property (nonatomic, assign) int               pageNum;

@end

@implementation RecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _models = [NSMutableArray array];
    [self layoutUI];
    _pageNum = 0;
    [self myRecord:_pageNum];
}

- (void)layoutUI {
    [self NavigationItemTitle:_isIncome ? @"充值记录" : @"提现记录" Color:Color1D];
//    [self navgationRightButtonImage:@"icon_ico_order"];
    [self navgationLeftButtonImage:backUp];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NavHeight, ScreenWidth, ScreenHeight - NavHeight) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.bounces = YES;
    _tableView.backgroundColor = ColorBg;
    [_tableView registerClass:[TransactionTableViewCell class] forCellReuseIdentifier:ID];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    __weak typeof(self) weakSelf = self;
    [_tableView addHeaderWithCallback:^{
        weakSelf.pageNum = 0;
        [weakSelf myRecord:weakSelf.pageNum];
    }];
    [_tableView addFooterWithCallback:^{
        if (weakSelf.pageNum == -1) {
            [weakSelf showToastHUD:@"没有更多数据了"];
            [weakSelf.tableView.footer endRefreshing];
        } else {
            [weakSelf myRecord:weakSelf.pageNum];
        }
    }];
}

#pragma mark -- delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _models.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TransactionTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    if (_isIncome) {
        cell.recordModel = _models[indexPath.row];
    } else {
        cell.recordgetModel = _models[indexPath.row];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIView* line;
    if (!line) {
        line = [[UIView alloc] initWithFrame:CGRectMake(20, 79.5, ScreenWidth - 15, 0.5f)];
        line.tag = 10001111;
        line.backgroundColor = ColorLine;
        [cell.contentView addSubview:line];
    }
    line.hidden = ((indexPath.row + 1) == self.models.count);
    return cell;
    return cell;
}

- (void)myRecord:(NSInteger)pageNum {
    [self showProgressHud];
    NSString* str = _isIncome ? @"recharge/recharge_list.htm" : @"tocash/tocash_list.htm";
    
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    dict[@"pageNum"] = @(pageNum);
    
    RequestMessage* msg = [[RequestMessage alloc] initWithUrl:str.apifml method:POST args:dict];
    [RequestEngine doRqquestWithMessage:msg callbackBlock:^(ResponseMessage *responseMessage) {
        [self hiddenProgressHud];
        if (responseMessage.errorMessage) {
            [self showToastHUD:responseMessage.errorMessage];
        } else {
            if (pageNum == 0) {
                [_models removeAllObjects];
            }
            _pageNum = pageNum + 1;
            NSArray* array;
            if (_isIncome) {
                array = [RecordIncomeModel arrayToModel:responseMessage.bussinessData];
            } else {
                array = [RecordGetModel arrayToModel:responseMessage.bussinessData];
            }
            if (array.count == 0) {
                _pageNum = -1;
            }
            [_models addObjectsFromArray:array];
            if (_models.count==0) {
                [CommonToastHUD showTips:@"暂无数据"];
                UILabel *label = [UILabel new];
                if (_isIncome) {
                    [label rect:RECT(ScreenWidth/2.0-100, 100, 200, 20) aligment:Center font:14 isBold:NO text:@"暂无充值记录" textColor:ColorGrayText superView:nil];
                }else {
                       [label rect:RECT(ScreenWidth/2.0-100, 100, 200, 20) aligment:Center font:14 isBold:NO text:@"暂无提现记录" textColor:ColorGrayText superView:nil];
                }
                self.tableView.backgroundView =label;
            }else {
                self.tableView.backgroundView =[UIView new];
            }
            [self.tableView reloadData];
            [self.tableView.footer endRefreshing];
            [self.tableView.header endRefreshing];
        }
    }];
}

@end
