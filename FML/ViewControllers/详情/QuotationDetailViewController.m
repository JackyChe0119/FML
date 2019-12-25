//
//  CurrencyDetailViewController.m
//  XjBaseProject
//
//  Created by apple on 2018/7/18.
//  Copyright © 2018年 xjhuang. All rights reserved.
//

#import "QuotationDetailViewController.h"
#import "TransactionTableViewCell.h"
#import "CurrencyDetailView.h"
//#import "SKtopView.h"


static NSString* const ID = @"TransactionTableViewCell";

@interface QuotationDetailViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) CurrencyDetailView* topView;


@end

@implementation QuotationDetailViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.startPoint = CGPointMake(0, 0.5);//（0，0）表示从左上角开始变化。默认值是(0.5,0.0)表示从x轴为中间，y为顶端的开始变化
    layer.endPoint = CGPointMake(1, 0.5);//（1，1）表示到右下角变化结束。默认值是(0.5,1.0)  表示从x轴为中间，y为低端的结束变化
    layer.colors = [NSArray arrayWithObjects:(id)colorWithHexString(@"#5172fa").CGColor, (id)colorWithHexString(@"#569dfa").CGColor, nil];
    layer.locations = @[@0.0, @0.5];
    layer.frame = self.customNavView.bounds;
    [self.customNavView.layer addSublayer:layer];
    
    [self NavigationItemTitle:@"ICO资产优选" Color:ColorWhite];
    [self navgationLeftButtonImage:backUp_wihte];
    
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:[self bottomView]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    self.tabBarController.tabBar.hidden = YES;
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
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, NavHeight, ScreenWidth, ScreenHeight - NavHeight - 50) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
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
    view.backgroundColor = [UIColor whiteColor];
    
    _topView = [[CurrencyDetailView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 0)];
    [view addSubview:_topView];
    
    view.frame = CGRectMake(0, 0, ScreenWidth, BOTTOM(_topView));
    return view;
}

- (UIView *)bottomView {
    CGFloat viewHeight = 50 ;
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight - viewHeight, ScreenWidth, viewHeight)];
    view.backgroundColor = [UIColor whiteColor];
    
    UIButton* accountsBtn = [[UIButton alloc] initWithFrame:CGRectMake(2, 2, ScreenWidth / 2 - 4, 45)];
    [accountsBtn setTitle:@"转账" forState:UIControlStateNormal];
    [accountsBtn setTitleColor:ColorBlue forState:UIControlStateNormal];
    accountsBtn.layer.cornerRadius = 4;
    accountsBtn.layer.borderWidth = 1;
    accountsBtn.layer.borderColor = ColorBlue.CGColor;
    [view addSubview:accountsBtn];
    
    UIButton* receivablesBtn = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth / 2 + 2, 2, ScreenWidth / 2 - 4, 45)];
    [receivablesBtn setTitle:@"收款" forState:UIControlStateNormal];
    receivablesBtn.backgroundColor = ColorBlue;
    receivablesBtn.layer.cornerRadius = 4;
    [view addSubview:receivablesBtn];
   
    return view;
}
@end
