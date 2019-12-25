//
//  CoinMiddleView.m
//  XjBaseProject
//
//  Created by xjhuang on 2018/6/1.
//  Copyright © 2018年 xjhuang. All rights reserved.
//

#import "CoinMiddleView.h"
#define viewHeight (180)
@implementation CoinMiddleView
-(void)_refreshUI:(NSDictionary *)dic{
    if (dic) {
//        self.leftLabel0.text = [NSString stringWithFormat:@"$%.2f",[dic[@"high"] doubleValue]];
        self.leftLabel1.text = [NSString stringWithFormat:@"$%.2f",[dic[@"marketValue"] doubleValue]];
        self.leftLabel2.text = [NSString stringWithFormat:@"%.2f",[dic[@"totalNumber"] doubleValue]];
        
//        self.rightLabel0.text = [NSString stringWithFormat:@"$%.2f",[dic[@"low"] doubleValue]];
        self.rightLabel1.text = [NSString stringWithFormat:@"$%.2f",[dic[@"vol"] doubleValue]];
        self.rightLabel2.text = [NSString stringWithFormat:@"%.2f",[dic[@"circulation"] doubleValue]];
    }
}
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
//        [self addSubview:self.baseImageView];
        NSArray *arr0 = @[@"流通市值",@"24H成交额"];
        NSArray *arr1 = @[@"总发行量",@"交易额"];
        NSArray *arr2 = @[@22,@76];
        [arr0 enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UILabel *label = [UILabel new];
            [label rect:CGRectMake(0, [arr2[idx] floatValue], WIDTH(self)/2.0, 14) aligment:Center font:12 isBold:false text:obj textColor:colorWithHexString(@"#828599") superView:self];
        }];
        [arr1 enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UILabel *label = [UILabel new];
            [label rect:CGRectMake(WIDTH(self)/2.0, [arr2[idx] floatValue], WIDTH(self)/2.0, 14) aligment:Center font:12 isBold:false text:obj textColor:colorWithHexString(@"#828599") superView:self];
        }];
        if (!self.leftLabel0) {
//            self.leftLabel0 = [UILabel new];
            self.leftLabel1 = [UILabel new];
            self.leftLabel2 = [UILabel new];
//            self.rightLabel0 = [UILabel new];
            self.rightLabel1 = [UILabel new];
            self.rightLabel2 = [UILabel new];
            
            NSArray *labelArr0 = @[self.leftLabel1,self.leftLabel2];
            NSArray *labelArr1 = @[self.rightLabel1,self.rightLabel2];
            [labelArr0 enumerateObjectsUsingBlock:^(UILabel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [obj rect:CGRectMake(0, [arr2[idx] floatValue]+14, WIDTH(self)/2.0, 24) aligment:Center font:16 isBold:false text:@"" textColor:colorWithHexString(@"#333333") superView:self];
            }];
            [labelArr1 enumerateObjectsUsingBlock:^(UILabel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [obj rect:CGRectMake(WIDTH(self)/2.0, [arr2[idx] floatValue]+14, WIDTH(self)/2.0, 24) aligment:Center font:16 isBold:false text:@"" textColor:colorWithHexString(@"#333333") superView:self];
            }];
        }
        
        self.layer.shadowColor = colorWithHexString(@"dbe0f8").CGColor;
        self.layer.shadowOffset = CGSizeMake(1, 4);
        self.layer.shadowOpacity = 4;
        self.layer.shadowRadius = 2;
        self.layer.cornerRadius = 5;
    }
    return self;
}
@end
