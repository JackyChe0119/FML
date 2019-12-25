//
//  AnswerViewController.m
//  FML
//
//  Created by apple on 2018/8/2.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "AnswerViewController.h"
#import "AnswerTopView.h"
#import "AnswerView.h"
#import "AnswerBaseView.h"
#import "AnswerScrollView.h"
#import "Answer.h"
#import "AnswerResultViewController.h"

@interface AnswerViewController ()

@property (nonatomic, strong) AnswerTopView* topView;
@property (nonatomic, strong) UIScrollView*  scrollView;
@property (nonatomic, strong) AnswerScrollView* item2;
@property (nonatomic, strong) AnswerScrollView* item3;
@property (nonatomic, strong) AnswerScrollView* item4;
@property (nonatomic, strong) AnswerScrollView* item5;

@end

@implementation AnswerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layerView];
    [self NavigationItemTitle:@"合格投资者确认" Color:ColorWhite];
    [self setView];
}

- (void)dealloc {
    NSLog(@"%@", self);
    if (self.showPassHandler) {
        self.showPassHandler();
    }
}

- (void)layerView {
    CAGradientLayer *layer = [CAGradientLayer layer];
    layer.startPoint = CGPointMake(0, 1);//（0，0）表示从左上角开始变化。默认值是(0.5,0.0)表示从x轴为中间，y为顶端的开始变化
    layer.endPoint = CGPointMake(1, 1);//（1，1）表示到右下角变化结束。默认值是(0.5,1.0)  表示从x轴为中间，y为低端的结束变化
    layer.colors = @[
                     (id)[UIColor colorWithRed:49.0f/255.0f green:52.0f/255.0f blue:71.0f/255.0f alpha:1.0f].CGColor,
                     (id)[UIColor colorWithRed:68.0f/255.0f green:74.0f/255.0f blue:95.0f/255.0f alpha:1.0f].CGColor
                     ];
    layer.locations = @[@0.0, @1];
    layer.frame = self.customNavView.bounds;
    [self.customNavView.layer addSublayer:layer];
}


- (void)setView {
    _topView = [[AnswerTopView alloc] initWithFrame:CGRectMake(0, self.customNavView.bottom, ScreenWidth, 110)];
    [self.view addSubview:_topView];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _topView.bottom, ScreenWidth, ScreenHeight - _topView.bottom)];
    _scrollView.pagingEnabled = YES;
    _scrollView.contentSize = CGSizeMake(5 * ScreenWidth, 0);
    _scrollView.scrollEnabled = NO;
    [self.view addSubview:_scrollView];
    
    __weak typeof(self) weakSelf = self;
//    _item1 = [[AnswerBaseView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, _scrollView.height)];
//    [_scrollView addSubview:_item1];
//    _item1.baseAnswerHandler = ^{
//        [weakSelf.topView next];
//        [weakSelf scrollViewOffset:1];
//        [weakSelf.item1 closeW];
//    };
    
    _item2 = [[AnswerScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, _scrollView.height)];
    _item2.answerArray = [Answer firstAnswerArray];
    _item2.titles = [Answer firstTitleArray];
//    _item2.isHaveNext = YES;
    
    _item2.finishHandler = ^{
        [weakSelf.topView next];
        [weakSelf scrollViewOffset:1];
    };
//    _item2.nextHandler = ^{
//        [weakSelf.topView next];
//        [weakSelf scrollViewOffset:1];
//    };
//    _item2.backHandler = ^{
//        [weakSelf.topView back];
//        [weakSelf scrollViewOffset:0];
//    };
    [_item2 showView];
    [_item2.btn setTitle:@"下一页" forState:UIControlStateNormal];
    [_scrollView addSubview:_item2];
    
    _item3 = [[AnswerScrollView alloc] initWithFrame:CGRectMake(ScreenWidth, 0, ScreenWidth, _scrollView.height)];
    _item3.answerArray = [Answer secondAnswerArray];
    _item3.titles = [Answer secondTitleArray];
    _item3.isHaveNext = YES;
    _item3.nextHandler = ^{
        [weakSelf.topView next];
        [weakSelf scrollViewOffset:2];
    };
    _item3.backHandler = ^{
        [weakSelf.topView back];
        [weakSelf scrollViewOffset:0];
    };
    [_item3 showView];
    [_scrollView addSubview:_item3];
    
    _item4 = [[AnswerScrollView alloc] initWithFrame:CGRectMake(2 * ScreenWidth, 0, ScreenWidth, _scrollView.height)];
    _item4.answerArray = [Answer thirdAnswerArray];
    _item4.titles = [Answer thirdTitleArray];
    _item4.isHaveNext = YES;
    _item4.nextHandler = ^{
        [weakSelf.topView next];
        [weakSelf scrollViewOffset:3];
    };
    _item4.backHandler = ^{
        [weakSelf.topView back];
        [weakSelf scrollViewOffset:1];
    };
    [_item4 showView];
    [_scrollView addSubview:_item4];
    
    _item5 = [[AnswerScrollView alloc] initWithFrame:CGRectMake(3 * ScreenWidth, 0, ScreenWidth, _scrollView.height)];
    _item5.answerArray = [Answer fourthAnswerArray];
    _item5.titles = [Answer fourthTitleArray];
    _item5.finishHandler = ^{
        [weakSelf answerQuestion];
    };
    [_item5 showView];
    [_scrollView addSubview:_item5];
    
    
}

- (void)scrollViewOffset:(NSUInteger)index {
    [UIView animateWithDuration:0.3 animations:^{
        self.scrollView.contentOffset = CGPointMake(index * ScreenWidth, self.scrollView.contentOffset.y);
    }];
}

- (void)answerQuestion {
    [self showProgressHud];
    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    dict[@"answerWord"] = @"ok";
    
    RequestMessage* msg = [[RequestMessage alloc] initWithUrl:@"user/answer_question.htm".apifml method:POST args:dict];
    [RequestEngine doRqquestWithMessage:msg callbackBlock:^(ResponseMessage *responseMessage) {
        [self hiddenProgressHud];
        if (responseMessage.errorMessage) {
            [self showToastHUD:responseMessage.errorMessage];
        } else {
            NSLog(@"%@", responseMessage.bussinessData);
            AnswerResultViewController* vc = [AnswerResultViewController new];
            vc.score = _item2.score + _item3.score + _item4.score + _item5.score;
            [self.navigationController pushViewController:vc animated:YES];
        }

    }];
}

@end
