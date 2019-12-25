//
//  CoinMiddleView.h
//  XjBaseProject
//
//  Created by xjhuang on 2018/6/1.
//  Copyright © 2018年 xjhuang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CoinMiddleView : UIView

@property (nonatomic,strong) UILabel            *leftLabel0;
@property (nonatomic,strong) UILabel            *leftLabel1;
@property (nonatomic,strong) UILabel            *leftLabel2;
@property (nonatomic,strong) UILabel            *rightLabel0;
@property (nonatomic,strong) UILabel            *rightLabel1;
@property (nonatomic,strong) UILabel            *rightLabel2;

- (void)_refreshUI:(NSDictionary*)dic;
@end
