//
//  SonNodeViewController.m
//  FML
//
//  Created by 车杰 on 2018/9/6.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "SonNodeViewController.h"
#import "SonNodeListCell.h"
#import "NodeDetailViewController.h"
@interface SonNodeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *listArray;

@end

@implementation SonNodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutUI];
    self.currentPage = 0;
    [self getIntertellarInfo:YES];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent ;
}
- (void)getIntertellarInfo:(BOOL)first {
    if (first) {
        [self showProgressHud];
    }
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    [dict setValue:[NSNumber numberWithInteger:self.currentPage] forKey:@"pageNum"];
    RequestMessage* msg = [[RequestMessage alloc] initWithUrl:@"node/sonList.htm".apifml method:POST args:dict];
    [RequestEngine doRqquestWithMessage:msg callbackBlock:^(ResponseMessage *responseMessage) {
        if (first) {
            [self hiddenProgressHud];
        }else {
            [self endRefreshControlLoading];
        }
        if (responseMessage.errorMessage) {
            [self showToastHUD:responseMessage.errorMessage];
        } else {
            NSArray *array = responseMessage.bussinessData;
            if (array.count==0) {
                [self setCurrentPageEqualTotalPage];
            }else {
                [self setCurrentPageLessTotalPage];
            }
            [array enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [self.listArray addObject:obj];
            }];
            [_tableView reloadData];
            if (self.listArray.count==0) {
                _tableView.tableFooterView = [self tableViewFootView];
            }else {
                _tableView.tableFooterView = [UIView createViewWithFrame:CGRectZero color:[UIColor clearColor]];
            }
        }
    }];
}
- (void)loadMoreData:(NSInteger)page {
    [self getIntertellarInfo:NO];
}
- (void)layoutUI {
    UIImageView *BGImageView = [UIImageView createImageViewWithFrame:RECT(0, 0, ScreenWidth, ScreenHeight) imageName:@"iocn_-interstellar_bg"];
    [self.view addSubview:BGImageView];
    
    UIImageView *middleImageView = [UIImageView createImageViewWithFrame:RECT(ScreenWidth/2.0-80, (ScreenHeight)/2.0-80, 160, 160) imageName:@"iocn_-interstellar"];
    [self.view addSubview:middleImageView];
    
    UILabel *titleLabel = [UILabel new];
    [titleLabel rect:RECT(60, StatusBarHeight, ScreenWidth-120, 44) aligment:Center font:17 isBold:YES text:@"子节点" textColor:[UIColor whiteColor] superView:self.view];
    
    UIButton *_leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *leftImage = [UIImage imageNamed:backUp_wihte];
    _leftButton.frame = CGRectMake(0, StatusBarHeight, 44, 44);
    [_leftButton setImage:leftImage forState:UIControlStateNormal];
    [_leftButton addTarget:self action:@selector(navgationLeftButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_leftButton];
    
    _tableView = [[UITableView alloc]initWithFrame:RECT(0, NavHeight, ScreenWidth, ScreenHeight-NavHeight-SafeAreaBottomHeight) style:0];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    [_tableView setSeparatorColor:[[UIColor whiteColor] colorWithAlphaComponent:.3] ];
    [_tableView setSeparatorInset:UIEdgeInsetsMake(0, 30, 0, 30)];
    [_tableView registerClass:[SonNodeListCell class] forCellReuseIdentifier:@"SonNodeListCell"];
    [self addRefreshFooter:_tableView];
    [self.view addSubview:_tableView];
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return .01;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}
- (UIView *)tableViewFootView {
    UIView *baseView = [UIView createViewWithFrame:RECT(0, 0, ScreenWidth, 50) color:[[UIColor clearColor] colorWithAlphaComponent:0]];
    
    CAGradientLayer *gradientLayer2 = [CAGradientLayer layer];
    gradientLayer2.colors = @[(__bridge id)[colorWithHexString(@"#182363") colorWithAlphaComponent:.5].CGColor, (__bridge id)[colorWithHexString(@"#350a4d") colorWithAlphaComponent:.5].CGColor];
    gradientLayer2.startPoint = CGPointMake(0, 0);
    gradientLayer2.endPoint = CGPointMake(1.0, 0);
    gradientLayer2.cornerRadius  = 3;
    gradientLayer2.frame = CGRectMake(20, 0, baseView.frame.size.width-40, 50);
    [baseView.layer addSublayer:gradientLayer2];
    
    UILabel *tipLabel = [UILabel new];
    [tipLabel rect:RECT(0, 0, WIDTH(baseView), 50) aligment:Center font:14 isBold:YES text:@"暂无字节点" textColor:colorWithHexString(@"#c7c7c7") superView:baseView];
    
    return baseView;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *baseView = [UIView createViewWithFrame:RECT(0, 0, ScreenWidth, 50) color:[[UIColor clearColor] colorWithAlphaComponent:0]];
    
    CAGradientLayer *gradientLayer2 = [CAGradientLayer layer];
    gradientLayer2.colors = @[(__bridge id)[colorWithHexString(@"#182363") colorWithAlphaComponent:.5].CGColor, (__bridge id)[colorWithHexString(@"#350a4d") colorWithAlphaComponent:.5].CGColor];
    gradientLayer2.startPoint = CGPointMake(0, 0);
    gradientLayer2.endPoint = CGPointMake(1.0, 0);
    gradientLayer2.cornerRadius  = 3;
    gradientLayer2.frame = CGRectMake(20, 0, baseView.frame.size.width-40, 50);
    [baseView.layer addSublayer:gradientLayer2];
    
    UILabel  *Label = [UILabel new];
    [Label rect:RECT(30,10,(ScreenWidth-60)/3.0, 30) aligment:Left font:12 isBold:YES text:@"来源" textColor:colorWithHexString(@"#979797") superView:baseView];
    
    UILabel  *Label3 = [UILabel new];
    [Label3 rect:RECT(30+(ScreenWidth-60)/3.*2,10,(ScreenWidth-60)/3., 30) aligment:Right font:12 isBold:YES text:@"级别" textColor:colorWithHexString(@"#979797") superView:baseView];
    
    UIView *lineView = [UIView createViewWithFrame:RECT(30, 49.5, ScreenWidth-60, .5) color:[[UIColor whiteColor] colorWithAlphaComponent:.3]];
    [baseView addSubview:lineView];
    return baseView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SonNodeListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SonNodeListCell"];
    if (!cell) {
        cell = [[SonNodeListCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"SonNodeListCell"];
    }
    NSDictionary *result = self.listArray[indexPath.row];
    cell.nameLabel.text = result[@"nickName"];
    if ([result[@"level"] integerValue]==1) {
        cell.typeLabel.text = @"初始节点";
    }else if ([result[@"level"] integerValue]==2) {
        cell.typeLabel.text = @"普通节点";
    }else if ([result[@"level"] integerValue]==3) {
        cell.typeLabel.text = @"高级节点";
    }else if ([result[@"level"] integerValue]==4) {
        cell.typeLabel.text = @"超级节点";
    }else if ([result[@"level"] integerValue]==5) {
        cell.typeLabel.text = @"创世节点";
    }
    cell.iconImageView.hidden = YES;
    cell.accetypeIamgeview.image = IMAGE(@"icon_accesstype_star");
    cell.nameLabel.frame= RECT(30, 20, (ScreenWidth-60)/2.0, 30);
    cell.typeLabel.frame = RECT(ScreenWidth/2.0, 20, (ScreenWidth-60)/2.0-20, 30);
    cell.accetypeIamgeview.frame = RECT(ScreenWidth-40, 22, 12, 26);
    
    cell.gradientLayer.frame = CGRectMake(20, 0, ScreenWidth-40, 70);

    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NodeDetailViewController *vc = [[NodeDetailViewController alloc]init];
    NSDictionary *result = self.listArray[indexPath.row];
    vc.userId = [result[@"userId"] integerValue];
    vc.nameTitle = result[@"nickName"];
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)navgationLeftButtonClick {
    [self.navigationController popViewControllerAnimated:YES];
}
- (NSMutableArray *)listArray {
    if (!_listArray) {
        _listArray = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return _listArray;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
