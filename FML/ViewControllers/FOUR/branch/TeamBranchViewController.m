//
//  TeamBranchViewController.m
//  FML
//
//  Created by apple on 2018/7/25.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "TeamBranchViewController.h"
#import "XYSliderView.h"
#import "BranchListView.h"
#import "TeamBranchTopView.h"
#import "NoTeamView.h"
#import "RealNameViewController.h"
#import "FMLAlertView.h"
#import "BranchTableViewCell.h"
#import "AgreementViewController.h"
#import "TeamViewController.h"
#import "BindPhoneViewController.h"
@interface TeamBranchViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) XYSliderView*     sliderView;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic, strong) UIScrollView*     scrollView;
@property (nonatomic,strong)NSMutableArray *data;
@property (nonatomic,assign) BOOL isLoadxiashu,isLoadTeam;
@property (nonatomic,strong)NSDictionary *resultDic;
@end

@implementation TeamBranchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self NavigationItemTitle:@"星际节点" Color:Color1D];
//    [self navgationLeftButtonImage:backUp];
    self.view.backgroundColor = RGB_A(248, 248, 248, 1);
    [self setView];
    [self getTeamList:0 first:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
//    [self checkisHaveTeam];
}

- (void)setView {
    __weak typeof(self) weakSelf = self;
    [self.view addSubview:self.sliderView];
    self.sliderView.currentClickIndex = ^(NSUInteger currentIndex) {
        if (currentIndex==0) {
//            if (!weakSelf.isLoadxiashu) {
                [weakSelf getTeamList:0 first:YES];
//            }
            weakSelf.tableView.hidden = NO;
            weakSelf.scrollView.hidden = YES;
        }else {
//            if (!weakSelf.isLoadTeam) {
                [weakSelf checkisHaveTeam];
//            }
            weakSelf.tableView.hidden = YES;
            weakSelf.scrollView.hidden = NO;
        }
        NSLog(@"点击==%ld",currentIndex);
    };
    [self.view addSubview:self.tableView];
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,NavHeight + 45, ScreenWidth, ScreenHeight - NavHeight - 45) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = [UIView new];
        _tableView.alwaysBounceVertical = YES;
        [_tableView setSeparatorColor:ColorLine];
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0, 60, 0, 0  )];
        [_tableView registerNib:[UINib nibWithNibName:@"BranchTableViewCell" bundle:nil] forCellReuseIdentifier:@"BranchTableViewCell"];
        [self addRefreshHeader:_tableView];
        [self addRefreshFooter:_tableView];
    }
    return _tableView;
}
- (void)refreshNewData {
    self.currentPage = 0;
    [self getTeamList:0 first:NO] ;
}
- (void)loadMoreData:(NSInteger)page {
    [self getTeamList:page first:NO];
}
- (void)getTeamList:(int)pageNum first:(BOOL)first {
    if (first) {
        [self showProgressHud];
    }
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    dict[@"pageNum"] = @(pageNum);
    RequestMessage* msg = [[RequestMessage alloc] initWithUrl:@"item/first_layer.htm".apifml method:POST args:dict];
    [RequestEngine doRqquestWithMessage:msg callbackBlock:^(ResponseMessage *responseMessage) {
        if (first) {
            [self hiddenProgressHud];
        }else {
            [self endRefreshControlLoading];
        }
        if (responseMessage.errorMessage) {
            [self showToastHUD:responseMessage.errorMessage];
        } else {
            if (pageNum == 0) {
                [self.data  removeAllObjects];
            }
            NSArray *array = responseMessage.bussinessData;
            [array enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                TeamUserModel *model = [[TeamUserModel alloc]initWithDictionary:obj];
                    [self.data  addObject:model];
            }];
            if (array.count == 0) {
                [self setCurrentPageEqualTotalPage];
            }else {
                [self setCurrentPageLessTotalPage];
            }
            if (self.data .count==0) {
                UILabel *label = [UILabel new];
                [label rect:RECT(ScreenWidth/2.0-100, 100, 200, 20) aligment:Center font:14 isBold:NO text:@"暂无节点信息" textColor:ColorGrayText superView:nil];
                self.tableView.backgroundView =label;
            }else {
                self.tableView.backgroundView =[UIView new];
            }
            [self.tableView reloadData];
        }
    }];
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
- (void)checkisHaveTeam {
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    RequestMessage* msg = [[RequestMessage alloc] initWithUrl:@"item/item.htm".apifml method:POST args:dict];
    [RequestEngine doRqquestWithMessage:msg callbackBlock:^(ResponseMessage *responseMessage) {
        if (responseMessage.errorMessage) {
            if (![responseMessage.errorMessage isEqualToString:@"您还未加入任何团队"]) {
                [self showToastHUD:responseMessage.errorMessage];
            }
        } else {
//            self.isLoadTeam = YES;
//            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//            [dic setValue:@"y" forKey:@"teamLear"];
//            [dic setValue:@"y" forKey:@"teamPersion"];
//            [dic setValue:@"0" forKey:@"persontNumber"];
//            [dic setValue:@"0" forKey:@"itemNumber"];
            _resultDic = responseMessage.bussinessData;
            [self changeState:responseMessage.bussinessData];
        }
    }];
}
- (void)changeState:(NSDictionary *)result {
    
    [_scrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    
    if ([result[@"teamLear"] isEqualToString:@"n"]&&[result[@"teamPersion"] isEqualToString:@"n"]) {
        // 无加入团队  无组建团队
        UIButton *btn = [UIButton createimageButtonWithFrame:RECT(ScreenWidth/2.0-100, 50, 200, 200) imageName:@"icon_noteam"];
        [btn addTarget:self action:@selector(createTeam) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn];
        
        UILabel *tipLabel = [UILabel new];
        [tipLabel rect:RECT(0,GETY(btn.frame)+10, ScreenWidth, 20) aligment:Center font:13 isBold:NO text:@"您还未加入团队，赶快组建团队吧" textColor:Color4D superView:_scrollView];

    }else if ([result[@"teamLear"] isEqualToString:@"n"]&&[result[@"teamPersion"] isEqualToString:@"y"]) {
        //组建团队  无加入团队
        UIButton *btn = [UIButton createimageButtonWithFrame:RECT(ScreenWidth/2.0-100, 20, 200, 200) imageName:@"icon_teamNumber"];
        [btn addTarget:self action:@selector(TeamDeatil:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 100;
        [_scrollView addSubview:btn];
        
        UILabel *tipLabel = [UILabel new];
        [tipLabel rect:RECT(0,HEIGHT(btn)-62, WIDTH(btn), 20) aligment:Center font:12 isBold:NO text:[NSString stringWithFormat:@"%ld人",[result[@"persontNumber"] integerValue]] textColor:Color4D superView:btn];
        
        UIButton *btn2 = [UIButton createimageButtonWithFrame:RECT(ScreenWidth/2.0-100, GETY(btn.frame)+50, 200, 200) imageName:@"icon_noteam"];
        [btn2 addTarget:self action:@selector(createTeam) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:btn2];
    }else if ([result[@"teamLear"] isEqualToString:@"y"]&&[result[@"teamPersion"] isEqualToString:@"n"]) {
      
        UIButton *btn = [UIButton createimageButtonWithFrame:RECT(ScreenWidth/2.0-100, 50, 200, 200) imageName:@"icon_teamleader"];
        [btn addTarget:self action:@selector(TeamDeatil:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 200;
        [_scrollView addSubview:btn];
        
        UILabel *tipLabel = [UILabel new];
        [tipLabel rect:RECT(0,HEIGHT(btn)-62, WIDTH(btn), 20) aligment:Center font:12 isBold:NO text:[NSString stringWithFormat:@"%ld人",[result[@"itemNumber"] integerValue]] textColor:Color4D superView:btn];
        
    }else {
       
        UIButton *btn = [UIButton createimageButtonWithFrame:RECT(ScreenWidth/2.0-100, 20, 200, 200) imageName:@"icon_teamNumber"];
        [btn addTarget:self action:@selector(TeamDeatil:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag = 300;
        [_scrollView addSubview:btn];
        
        UILabel *numberLabel = [UILabel new];
        [numberLabel rect:RECT(0,HEIGHT(btn)-62, WIDTH(btn), 20) aligment:Center font:12 isBold:NO text:[NSString stringWithFormat:@"%ld人",[result[@"itemNumber"] integerValue]] textColor:Color4D superView:btn];
        
        UIButton *btn2 = [UIButton createimageButtonWithFrame:RECT(ScreenWidth/2.0-100, GETY(btn.frame)+50, 200, 200) imageName:@"icon_teamleader"];
        [btn2 addTarget:self action:@selector(TeamDeatil:) forControlEvents:UIControlEventTouchUpInside];
        btn2.tag = 400;
        [_scrollView addSubview:btn2];
        
        UILabel *numberLabel2 = [UILabel new];
        [numberLabel2 rect:RECT(0,HEIGHT(btn2)-62, WIDTH(btn2), 20) aligment:Center font:12 isBold:NO text:[NSString stringWithFormat:@"%ld人",[result[@"persontNumber"] integerValue]] textColor:Color4D superView:btn2];
        
    }
}
- (XYSliderView *)sliderView {
    if (!_sliderView) {
        _sliderView = [[XYSliderView alloc] initWithFrame:CGRectMake(0, self.customNavView.bottom, ScreenWidth, 45)];
        _sliderView.backgroundColor = ColorWhite;
        XYSliderModel* model = [XYSliderModel new];
        model.titles = @[@"节点", @"团队"];
        model.selColor = Color1D;
        model.unSelColor = ColorGrayText;
        model.lineColor = Color1D;
        model.itemBottomOffset = 13;
        model.viewType = XYSliderViewTypeDivideWindow;
        model.offsetTopTitle = 13;
//        model.bottomScrollView = self.scrollView;
        _sliderView.typeModel = model;
    }
    return _sliderView;
}
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, NavHeight + 45, ScreenWidth, ScreenHeight - NavHeight - 45)];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.alwaysBounceVertical = YES;
        _scrollView.backgroundColor = RGB_A(248, 248, 248, 1);
        [self.view addSubview:_scrollView];
    }
    return _scrollView;
}

- (void)createTeam {
    [self doresuestAuth];

}
- (void)TeamDeatil:(UIButton *)sender {
    TeamViewController *vc = [[TeamViewController alloc]init];
    if (sender.tag==200||sender.tag==400) {
        vc.isMyTeam = YES;
        vc.shouyi = [NSString stringWithFormat:@"%.2f",[_resultDic[@"commissionAmount"] doubleValue]];
        vc.num = [NSString stringWithFormat:@"%ld",[_resultDic[@"itemNumber"] integerValue] ];
    }else {
        vc.isMyTeam = NO;
        vc.email = _resultDic[@"loaderName"];
        vc.num = [NSString stringWithFormat:@"%ld",[_resultDic[@"persontNumber"] integerValue]];
    }
    [self.navigationController pushViewController:vc animated:YES];
}
- (void)showAuthAlert {
    if ([UserSingle sharedUser].email.length==0) {
        [self showShadowViewWithColor:YES];
        FMLAlertView* alertView = [[FMLAlertView alloc] initWithTitle:@"邮箱未绑定" msg:@"为了保证您的交易正常进行，请先去绑定邮箱"];
        
            [alertView addBtn:@"确定" titleColor:ColorBlue action:^{
                BindPhoneViewController* vc = [BindPhoneViewController new];
                vc.isEmail = YES;
                [self.navigationController pushViewController:vc animated:YES];
                [self hiddenShadowView];
            }];
        
        [alertView addBtn:@"取消" titleColor:ColorGrayText action:^{
            [self hiddenShadowView];
        }];
        [self.shadowView addSubview:alertView];
        [alertView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.shadowView);
            make.width.mas_equalTo(ScreenWidth * 0.8);
        }];
        return;
    }

    NSString *str;
    switch ([UserSingle sharedUser].isAuth) {
        case 0:
            str = @"您还未实名认证，请前往认证！";
            break;
        case 1:
            str = @"您的身份还在认证中！";
            break;
        case 2:
            str = @"实名认证被拒绝，请前往重新认证！";
            break;
        default:
            break;
    }
    [self showShadowViewWithColor:YES];
    FMLAlertView* alertView = [[FMLAlertView alloc] initWithTitle:@"实名认证" msg:str];
    
    if ([UserSingle sharedUser].isAuth != 1) {
        [alertView addBtn:@"确定" titleColor:ColorBlue action:^{
            RealNameViewController* vc = [RealNameViewController new];
            vc.noPush = YES;
            [self presentViewController:vc animated:YES completion:^{
            }];
            [self hiddenShadowView];
        }];
    }
    [alertView addBtn:@"取消" titleColor:ColorGrayText action:^{
        [self hiddenShadowView];
    }];
    [self.shadowView addSubview:alertView];
    [alertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.shadowView);
        make.width.mas_equalTo(ScreenWidth * 0.8);
    }];
}
- (void)doresuestAuth{
    if ([UserSingle sharedUser].isAuth==3&&[[UserSingle sharedUser].email containsString:@"@"]) {
        AgreementViewController* vc = [AgreementViewController new];
        vc.type = FMLAgreementTypeFYuncheck;
        [self.navigationController pushViewController:vc animated:YES];
    }else {
        [self showProgressHud];
        NSMutableDictionary* dict = [NSMutableDictionary dictionary];
        RequestMessage* msg = [[RequestMessage alloc] initWithUrl:@"user/user_info.htm".apifml method:POST args:dict];
        [RequestEngine doRqquestWithMessage:msg callbackBlock:^(ResponseMessage *responseMessage) {
            [self hiddenProgressHud];
            if (responseMessage.errorMessage) {
                [CommonToastHUD showTips:responseMessage.errorMessage];
            } else {
                [[UserSingle sharedUser] setLoginInfo:responseMessage.bussinessData];
                if ([UserSingle sharedUser].isAuth!=3||![[UserSingle sharedUser].email containsString:@"@"]) {
                    [self showAuthAlert];
                }else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        AgreementViewController* vc = [AgreementViewController new];
                        vc.type = FMLAgreementTypeFYuncheck;
                        [self.navigationController pushViewController:vc animated:YES];
                    });
                }
            }
        }];
    }
}
- (NSMutableArray *)data {
    if (!_data) {
        _data = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return _data;
}
@end
