//
//  TimeTableViewCell.m
//  FML
//
//  Created by apple on 2018/8/3.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "TimeTableViewCell.h"
#import "DateUtil.h"

@implementation TimeTableViewCell {
    
    __weak IBOutlet UILabel *timeLB;
    __weak IBOutlet UILabel *_numLB;
    __weak IBOutlet UILabel *_label;
    
    DashLineView*   _topLine;
    DashLineView*   _bottomLine;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _numLB.textColor = Color1D;
    timeLB.textColor = Color4D;
    _topLine = [[DashLineView alloc] initWithFrame:CGRectMake(24, 0, 1, 20) withLineLength:3 withLineSpacing:3 withLineColor:RGB_A(130, 133, 153, 1)];
    [self.contentView addSubview:_topLine];
    _bottomLine = [[DashLineView alloc] initWithFrame:CGRectMake(24, 36, 1, 25) withLineLength:3 withLineSpacing:3 withLineColor:RGB_A(130, 133, 153, 1)];
    [self.contentView addSubview:_bottomLine];
    
    [self.contentView sendSubviewToBack:_bottomLine];
    [self.contentView sendSubviewToBack:_topLine];
    
    _label.textColor = Color4D;
}

- (void)setModel:(ICOListModel *)model {
    _model = model;
    _numLB.text = [NSString stringWithFormat:@"%.2f", model.total];
    timeLB.text = [DateUtil getDateStringFormString:[NSString stringWithFormat:@"%ld", model.createTime / 1000] format:@"YYYY年M月d日"];
    _topLine.hidden = !model.isShowTop;
    _bottomLine.hidden = !model.isShowBottom;
}

@end

@implementation DashLineView {
    CGFloat     _lineLength;
    CGFloat     _lineSpacing;
    UIColor*    _lineColor;
    CGFloat     _height;
}

- (instancetype)initWithFrame:(CGRect)frame withLineLength:(NSInteger)lineLength withLineSpacing:(NSInteger)lineSpacing withLineColor:(UIColor *)lineColor{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _lineLength = lineLength;
        _lineSpacing = lineSpacing;
        _lineColor = lineColor;
        _height = frame.size.height;
    }
    return self;
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef context =UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGContextSetLineWidth(context,1);
    CGContextSetStrokeColorWithColor(context, _lineColor.CGColor);
    CGFloat lengths[] = {_lineLength,_lineSpacing};
    CGContextSetLineDash(context, 0, lengths,2);
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, 0,_height);
    CGContextStrokePath(context);
    CGContextClosePath(context);
}

@end
