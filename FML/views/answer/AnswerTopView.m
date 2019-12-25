//
//  AnswerTopView.m
//  FML
//
//  Created by apple on 2018/8/2.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "AnswerTopView.h"

@implementation AnswerTopView {
    NSMutableArray<AnswerItem *>* _items;
    NSInteger       _currentSelect;
    UIView*         _line;
    UIView*         _drawLine;
}

- (NSArray *)titles {
    return @[@"财务状况", @"投资知识", @"投资目标", @"风险偏好"];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _currentSelect = 1;
        _items = [NSMutableArray array];
        [self layerView];
        [self setView];
    }
    return self;
}

- (void)setView {
    
    UIImageView* imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"anwser_icon_background"]];
    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.top).offset(22);
    }];

    _line = [UIView new];
    _line.backgroundColor = colorWithHexString(@"#374dad");
    [self addSubview:_line];
    
    CGFloat width = 83.1;
    
    AnswerItem* lastItem;
    for (int i = 0; i < self.titles.count; i++) {
        AnswerItem* item = [AnswerItem new];
        item.title = self.titles[i];
        item.btn.backgroundColor = (i == 0) ? colorWithHexString(@"#506afa") : [UIColor clearColor];

        [self addSubview:item];
        [item mas_makeConstraints:^(MASConstraintMaker *make) {
            if (i == 0) {
                make.left.equalTo(imageView).offset(-26.3);
            } else {
                make.left.equalTo(lastItem.mas_right);
            }
            make.width.mas_offset(width);
            make.top.equalTo(imageView).offset(5);
        }];
        lastItem = item;
        [_items addObject:item];
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
    layer.frame = self.bounds;
    [self.layer addSublayer:layer];
}

- (void)next {
    _currentSelect += 1;
    [self reloadData];
}

- (void)back {
    _currentSelect -= 1;
    [self reloadData];
}

- (void)reloadData {
    for (AnswerItem* item in _items) {
        item.btn.backgroundColor = [UIColor clearColor];
        item.btn.selected = NO;
    }
    
    for (int i = 0; i < _currentSelect; i++) {
        AnswerItem* item = _items[i];
        item.btn.backgroundColor = colorWithHexString(@"#506afa");
        if (i + 1 != _currentSelect) {
            item.btn.selected = YES;
        }
    }
}

@end


@implementation AnswerItem {
    
    UILabel*  _titleLB;
}

- (instancetype)init {
    if (self = [super init]) {
        [self setView];
    }
    return self;
}

- (void)setView {
    _btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_btn setImage:[UIImage imageNamed:@"answer_meiyou"] forState:UIControlStateNormal];
    [_btn setImage:[UIImage imageNamed:@"answer_check"] forState:UIControlStateSelected];
    _btn.userInteractionEnabled = NO;
    _btn.layer.cornerRadius = 10;
    [self addSubview:_btn];
    [_btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.centerX.equalTo(self);
        make.width.height.mas_equalTo(20);
    }];
    
    _titleLB = [UILabel new];
    _titleLB.font = [UIFont systemFontOfSize:14];
    _titleLB.textColor = ColorWhite;
    [self addSubview:_titleLB];
    [_titleLB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_btn);
        make.top.equalTo(_btn.mas_bottom).offset(10);
        make.bottom.equalTo(self);
    }];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    _titleLB.text = title;
}

- (void)setIsSelect:(BOOL)isSelect {
    _isSelect = isSelect;
    _btn.selected = isSelect;
}
@end
