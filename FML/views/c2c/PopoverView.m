//
//  PopoverView.m
//  FML
//
//  Created by apple on 2018/8/16.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "PopoverView.h"

@implementation PopoverView {
    NSArray*    _titles;
    int         _selectIndex;
    NSMutableArray* _itmes;
    NSArray*    _currencyIds;
}

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles selectIndex:(int)index {
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        _titles = titles;
        _selectIndex = index;
        _itmes = [NSMutableArray array];
//        _currencyIds = @[@"19", @"30", @"18", @"23"];
        [self setView];
    }
    return self;
}

- (void)setView {
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.width / 2 - 7.5, 0, 15, 15)];
    imageView.image = [UIImage imageNamed:@"sanjiao"];
    [self addSubview:imageView];
    
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 7.5, self.width, 152.5)];
    view.backgroundColor = ColorWhite;
    view.layer.cornerRadius = 4;
    [self addSubview:view];
    
    for (int i = 0; i < 4; i ++) {
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = (i == _selectIndex) ? colorWithHexString(@"#bcc3eb") : ColorWhite;
        btn.selected = i == _selectIndex;
        [btn setTitle:_titles[i][@"currencyName"] forState:UIControlStateNormal];
        [btn setTitleColor:ColorWhite forState:UIControlStateSelected];
        [btn setTitleColor:Color4D forState:UIControlStateNormal];
        [view addSubview:btn];
        btn.frame = CGRectMake(0, i * 35 + 7.5, self.width, 35);
        [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        
        [_itmes addObject:btn];
    }
}

- (void)click:(UIButton *)btn {
    for (UIButton* item in _itmes) {
        item.backgroundColor = ColorWhite;
        item.selected =NO;
    }
    btn.backgroundColor = colorWithHexString(@"#bcc3eb");
    btn.selected = YES;
    if (_popoverHandler) {
        NSInteger index = [_itmes indexOfObject:btn];
        _popoverHandler([NSString stringWithFormat:@"%ld",[_titles[index][@"id"] integerValue]], [_titles[index][@"currencyName"] stringByAppendingString:@"  "]);
    }
    
}

@end


