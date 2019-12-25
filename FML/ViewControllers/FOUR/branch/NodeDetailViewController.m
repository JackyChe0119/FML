//
//  NodeDetailViewController.m
//  FML
//
//  Created by 车杰 on 2018/9/6.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "NodeDetailViewController.h"
#import "SonNodeListCell.h"
@interface NodeDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *listArray1,*listArray2,*listArray3;

@end

@implementation NodeDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutUI];
    [self getIntertellarInfo:YES];
}
- (void)getIntertellarInfo:(BOOL)first {
    [self showProgressHud];
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    [dict setValue:[NSNumber numberWithInteger:_userId] forKey:@"userId"];
    RequestMessage* msg = [[RequestMessage alloc] initWithUrl:@"node/nodeCurDate.htm".apifml method:POST args:dict];
    [RequestEngine doRqquestWithMessage:msg callbackBlock:^(ResponseMessage *responseMessage) {
        if (responseMessage.errorMessage) {
            [self hiddenProgressHud];
            [self showToastHUD:responseMessage.errorMessage];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            NSArray *array = responseMessage.bussinessData;
            [array enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [self.listArray1 addObject:obj];
            }];
            dispatch_async(dispatch_get_main_queue(), ^{
                [_tableView reloadData];
                [self requestListTwo];
            });
        }
    }];
}
- (void)requestListTwo {
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    [dict setValue:[NSNumber numberWithInteger:_userId] forKey:@"userId"];
    RequestMessage* msg = [[RequestMessage alloc] initWithUrl:@"node/nodeFdDate.htm".apifml method:POST args:dict];
    [RequestEngine doRqquestWithMessage:msg callbackBlock:^(ResponseMessage *responseMessage) {
        [self hiddenProgressHud];
        if (responseMessage.errorMessage) {
            [self showToastHUD:responseMessage.errorMessage];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            NSArray *array = responseMessage.bussinessData;
            [array enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [self.listArray2 addObject:obj];
            }];
            [_tableView reloadData];
        }
    }];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent ;
}

- (void)layoutUI {
    UIImageView *BGImageView = [UIImageView createImageViewWithFrame:RECT(0, 0, ScreenWidth, ScreenHeight) imageName:@"iocn_-interstellar_bg"];
    [self.view addSubview:BGImageView];
    
    UIImageView *middleImageView = [UIImageView createImageViewWithFrame:RECT(ScreenWidth/2.0-80, (ScreenHeight)/2.0-80, 160, 160) imageName:@"iocn_-interstellar"];
    [self.view addSubview:middleImageView];
    
    UILabel *titleLabel = [UILabel new];
    [titleLabel rect:RECT(60, StatusBarHeight, ScreenWidth-120, 44) aligment:Center font:17 isBold:YES text:self.nameTitle textColor:[UIColor whiteColor] superView:self.view];
    
    UIButton *_leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *leftImage = [UIImage imageNamed:backUp_wihte];
    _leftButton.frame = CGRectMake(0, StatusBarHeight, 44, 44);
    [_leftButton setImage:leftImage forState:UIControlStateNormal];
    [_leftButton addTarget:self action:@selector(navgationLeftButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_leftButton];
    
    _tableView = [[UITableView alloc]initWithFrame:RECT(0, NavHeight, ScreenWidth, ScreenHeight-NavHeight) style:0];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    [_tableView setSeparatorColor:[[UIColor whiteColor] colorWithAlphaComponent:.3] ];
    [_tableView setSeparatorInset:UIEdgeInsetsMake(0, 30, 0, 30)];
    [_tableView registerClass:[SonNodeListCell class] forCellReuseIdentifier:@"SonNodeListCell"];
    [self.view addSubview:_tableView];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return self.listArray1.count;
    }else if (section==1) {
        return self.listArray2.count;
    }else {
        return self.listArray2.count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 60;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (section==0) {
        if (self.listArray1.count==0) {
            return 50;
        }
    }else if (section==1) {
        if (self.listArray2.count==0) {
            return 50;
        }
    }else {
        if (self.listArray2.count==0) {
            return 50;
        }
    }
    return 0.01;

}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if (section==0) {
        if (_listArray1!=nil&&self.listArray1.count!=0) {
            return [UIView createViewWithFrame:RECT(0, 0, ScreenWidth, .01) color:[UIColor clearColor]];
        }
    }else if (section==1) {
        if (_listArray2!=nil&&self.listArray2.count!=0) {
             return [UIView createViewWithFrame:RECT(0, 0, ScreenWidth, .01) color:[UIColor clearColor]];
        }
    }else {
        if (_listArray2!=nil&&self.listArray2.count!=0) {
             return [UIView createViewWithFrame:RECT(0, 0, ScreenWidth, .01) color:[UIColor clearColor]];
        }
    }
    UIView *baseView = [UIView createViewWithFrame:RECT(0, 0, ScreenWidth, 50) color:[[UIColor clearColor] colorWithAlphaComponent:0]];
    CAGradientLayer *gradientLayer2 = [CAGradientLayer layer];
    gradientLayer2.colors = @[(__bridge id)[colorWithHexString(@"#182363") colorWithAlphaComponent:.5].CGColor, (__bridge id)[colorWithHexString(@"#350a4d") colorWithAlphaComponent:.5].CGColor];
    gradientLayer2.startPoint = CGPointMake(0, 0);
    gradientLayer2.endPoint = CGPointMake(1.0, 0);
    gradientLayer2.cornerRadius  = 3;
    gradientLayer2.frame = CGRectMake(20, 0, baseView.frame.size.width-40, 50);
    [baseView.layer addSublayer:gradientLayer2];
    
    UILabel *tipLabel = [UILabel new];
    [tipLabel rect:RECT(0, 0, WIDTH(baseView), 50) aligment:Center font:14 isBold:YES text:@"暂无数据" textColor:colorWithHexString(@"#c7c7c7") superView:baseView];
    
    return baseView;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *baseView = [UIView createViewWithFrame:RECT(0, 0, ScreenWidth, 60) color:[[UIColor clearColor] colorWithAlphaComponent:0]];
    
    CAGradientLayer *gradientLayer2 = [CAGradientLayer layer];
    gradientLayer2.colors = @[(__bridge id)[colorWithHexString(@"#182363") colorWithAlphaComponent:.5].CGColor, (__bridge id)[colorWithHexString(@"#350a4d") colorWithAlphaComponent:.5].CGColor];
    gradientLayer2.startPoint = CGPointMake(0, 0);
    gradientLayer2.endPoint = CGPointMake(1.0, 0);
    gradientLayer2.cornerRadius  = 3;
    gradientLayer2.frame = CGRectMake(20, 10, baseView.frame.size.width-40, 50);
    [baseView.layer addSublayer:gradientLayer2];
    
    UILabel  *Label = [UILabel new];
    [Label rect:RECT(30,20,(ScreenWidth-60)/3.0, 30) aligment:Left font:12 isBold:YES text:@"" textColor:colorWithHexString(@"#979797") superView:baseView];
    if (section==0) {
        Label.text = @"优选资产";
    }else if (section==1) {
        Label.text = @"量化投资";
    }else {
        Label.text = @"预期月贡献";
    }
    
    UIView *lineView = [UIView createViewWithFrame:RECT(30, 59.5, ScreenWidth-60, .5) color:[[UIColor whiteColor] colorWithAlphaComponent:.3]];
    [baseView addSubview:lineView];
    return baseView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SonNodeListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SonNodeListCell"];
    if (!cell) {
        cell = [[SonNodeListCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"SonNodeListCell"];
    }
    if (indexPath.section!=0) {
        NSDictionary *result = self.listArray2[indexPath.row];
        cell.nameLabel.text = result[@"currencyName"];
        if (indexPath.section==1) {
            cell.typeLabel.text = [NSString stringWithFormat:@"%.2f",[result[@"amount"] doubleValue]];
        }else {
            cell.typeLabel.text = [NSString stringWithFormat:@"%.2f",[result[@"monthAmount"] doubleValue]];
        }
        [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:result[@"logo"]]];
    }else {
        NSDictionary *result = self.listArray1[indexPath.row];
        cell.nameLabel.text = result[@"currencyName"];
        cell.typeLabel.text = [NSString stringWithFormat:@"%.2f",[result[@"amount"] doubleValue]];
        [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:result[@"logo"]]];
    }
    cell.typeLabel.frame = RECT(ScreenWidth/2.0, 20, (ScreenWidth-60)/2.0, 30);
    cell.accetypeIamgeview.hidden = YES;
    return cell;
}
- (NSMutableArray *)listArray1 {
    if (!_listArray1) {
        _listArray1 = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return _listArray1;
}
- (NSMutableArray *)listArray2 {
    if (!_listArray2) {
        _listArray2 = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return _listArray2;
}
-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
