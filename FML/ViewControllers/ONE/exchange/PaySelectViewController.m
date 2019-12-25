//
//  PaySelectViewController.m
//  FML
//
//  Created by apple on 2018/8/6.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "PaySelectViewController.h"


@interface PaySelectViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView* tableView;


@end

@implementation PaySelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel* label = [UILabel new];
    label.text = @"选择到账方式";
    label.textColor = Color1D;
    label.frame = CGRectMake(50, 0, ScreenWidth - 100, 50);
    label.font = [UIFont systemFontOfSize:19];
    label.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:label];
    
    
    
    [self setView];

}

- (void)setView {
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, ScreenWidth, 390)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = ColorWhite;
    _tableView.tableFooterView = [UIView new];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.contentInset = UIEdgeInsetsMake(0, 0, IPhoneX ? 34 : 0, 0);
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    for (BankCardModel* model in _models) {
        model.isShowCheck = NO;
    }
    _models[indexPath.row].isShowCheck = YES;
    [self.tableView reloadData];
    if (_payModelHanlder) {
        _payModelHanlder(_models[indexPath.row]);
    }
    [self navgationLeftButtonClick];
}

- (void)navgationLeftButtonClick {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

@end
