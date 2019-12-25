//
//  TimeCountView.m
//  FML
//
//  Created by 车杰 on 2018/8/18.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "TimeCountView.h"

@implementation TimeCountView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        UIImageView *imageView = [UIImageView createImageViewWithFrame:RECT(WIDTH(self)/2.0-25, 0, 50, 50) imageName:@"iocn_time_red"];
        imageView.contentMode = UIViewContentModeCenter;
        [self addSubview:imageView];
        
        [self addSubview:self.timeLabel];
        
        UILabel *statusLabel = [UILabel new];
        [statusLabel rect:RECT(0, 80, WIDTH(self), 20) aligment:Center font:15 isBold:NO text:@"待付款" textColor:Color1D superView:self];
        
    }
    return self;
}
- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [UILabel new];
        [_timeLabel rect:RECT(0, 50, WIDTH(self), 20) aligment:Center font:13 isBold:YES text:@"" textColor:colorWithHexString(@"#fd5353") superView:nil];
    }
    return _timeLabel;
}
- (void)setCount:(NSInteger)count {
    _count = count;
    if (count<=0) {
        count = 0;
    }
    [_timeLabel DatecountdownOrder:count str:@"" final:@"订单已结束" :^{
        
    } :^{
        
    }];
}
@end
