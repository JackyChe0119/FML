//
//  IDCardListViewController.m
//  FML
//
//  Created by apple on 2018/8/6.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "BankCardListViewController.h"
#import "PaySelectTableViewCell.h"
#import "BankCardModel.h"
#import "AddBankCardViewController.h"

@interface BankCardListViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) NSMutableArray<BankCardModel *> *models;

@end

@implementation BankCardListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self NavigationItemTitle:@"银行卡管理" Color:Color1D];
    [self navgationLeftButtonImage:backUp];
    
    _models = [NSMutableArray array];
    [self setView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self myBankCard];
}

- (void)setView {
    
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = ColorBg;
    btn.frame = CGRectMake(0, 0, ScreenWidth, 55);
    btn.titleLabel.font = [UIFont systemFontOfSize:14];
    [btn addTarget:self action:@selector(addBankCard) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitleColor:Color1D forState:UIControlStateNormal];
    [btn setTitle:@"    添加银行卡" forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"icon_add"] forState:UIControlStateNormal];

    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NavHeight, ScreenWidth, ScreenHeight - NavHeight)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = ColorWhite;
    _tableView.tableFooterView = btn;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView registerNib:[UINib nibWithNibName:@"PaySelectTableViewCell" bundle:nil] forCellReuseIdentifier:@"id"];
    [self.view addSubview:_tableView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PaySelectTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"id" forIndexPath:indexPath];
    cell.model = _models[indexPath.row];
    return cell;
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
    
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return UITableViewCellEditingStyleDelete;
    
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";  //我这里需要设置成“取消收藏”而不是“删除”,文字可以自定义
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    BankCardModel *model = _models[indexPath.row];
    [self showProgressHud];
    NSMutableDictionary* dict = [[NSMutableDictionary alloc]initWithCapacity:0];
    [dict setValue:[NSNumber numberWithInteger:model.Id] forKey:@"bankId"];
    RequestMessage* msg = [[RequestMessage alloc] initWithUrl:@"bank/del_bank.htm".apifml method:POST args:dict];
    [RequestEngine doRqquestWithMessage:msg callbackBlock:^(ResponseMessage *responseMessage) {
        [self hiddenProgressHud];
        if (responseMessage.errorMessage) {
            [self showToastHUD:responseMessage.errorMessage];
        } else {
            [_models removeObjectAtIndex:indexPath.row];
        }
        [self.tableView reloadData];
        
    }];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    [self navgationLeftButtonClick];
}

- (void)myBankCard {
    [self showProgressHud];
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    RequestMessage* msg = [[RequestMessage alloc] initWithUrl:@"bank/bank_list.htm".apifml method:POST args:dict];
    [RequestEngine doRqquestWithMessage:msg callbackBlock:^(ResponseMessage *responseMessage) {
        [self hiddenProgressHud];
        if (responseMessage.errorMessage) {
            [self showToastHUD:responseMessage.errorMessage];
        } else {
            [_models removeAllObjects];
            [_models addObjectsFromArray:[BankCardModel arrayToModel:responseMessage.bussinessData]];
            
        }
        [self.tableView reloadData];
        
    }];
}

- (void)addBankCard {
    AddBankCardViewController* vc = [AddBankCardViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
