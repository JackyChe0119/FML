//
//  CurrencyChartView.m
//  XjBaseProject
//
//  Created by apple on 2018/7/18.
//  Copyright © 2018年 xjhuang. All rights reserved.
//

#import "CurrencyChartView.h"
#import "FML-Bridging-Header.h"

@interface CurrencyChartView()<ChartViewDelegate, IChartAxisValueFormatter>

@property (nonatomic, strong) LineChartView* barChartView;
@property (nonatomic, strong) LineChartData* data;
@property (nonatomic, strong) UILabel* leftTime;
@property (nonatomic, strong) UILabel* rightTime;

@property (nonatomic, strong) UILabel* topLabel;

@end

@implementation CurrencyChartView

-(instancetype)initWithFrame:(CGRect)frame currencyName:(NSString *)currencyName{
    if (self = [super initWithFrame:frame]) {
        _currencyName = currencyName;
        [self addSubview:self.skChooseView];
    }
    return self;
}

- (void)setDataArray:(NSArray *)dataArray {
    _dataArray = dataArray;

    [self creatView];
}

- (void)creatView {
    //添加barChartView
    
    if (!self.barChartView) {
        self.barChartView = [[LineChartView alloc] init];
        self.barChartView.delegate = self;//设置代理
        self.barChartView.backgroundColor = [UIColor whiteColor];
        self.barChartView.frame = CGRectMake(10, BOTTOM(self.skChooseView) + 10, ScreenWidth - 20, 200);;
        [self addSubview:self.barChartView];
        self.barChartView.extraLeftOffset = 10;
        
        //交互设置
        self.barChartView.scaleXEnabled = NO;
        self.barChartView.scaleYEnabled = NO;//取消Y轴缩放
        self.barChartView.doubleTapToZoomEnabled = NO;//取消双击缩放
        self.barChartView.dragEnabled = NO;//启用拖拽图表
        self.barChartView.dragDecelerationEnabled = NO;//拖拽后是否有惯性效果
        self.barChartView.dragDecelerationFrictionCoef = 0.9;//拖拽后惯性效果的摩擦系数(0~1)，数值越小，惯性越不明显
        
    }
    [self addSubview:self.titleLabel];
    //X轴样式
    ChartXAxis *xAxis = self.barChartView.xAxis;
    xAxis.valueFormatter = self;  //重写代理方法  设置x轴数据
    xAxis.axisLineWidth = 1;//设置X轴线宽
    xAxis.labelPosition = XAxisLabelPositionBottom;//X轴的显示位置，默认是显示在上面的
    xAxis.drawGridLinesEnabled = NO;//不绘制网格线
    xAxis.labelWidth = 4;//设置label间隔，若设置为1，则如果能全部显示，则每个柱形下面都会显示label
    //    xAxis.labelTextColor = [UIColor brownColor];//label文字颜色
    xAxis.axisLineColor = [UIColor grayColor];//X轴颜色
    
    //Y轴样式
    self.barChartView.rightAxis.enabled = NO;//不绘制右边轴线
    //左边Y轴样式
    ChartYAxis *leftAxis = self.barChartView.leftAxis;//获取左边Y轴
    leftAxis.forceLabelsEnabled = NO;//不强制绘制制定数量的label
    
    double maxValue = [[_dataArray valueForKeyPath:@"@max.floatValue"] doubleValue];
    double minValue = [[_dataArray valueForKeyPath:@"@min.floatValue"] doubleValue];
    if (maxValue-minValue<10) {
        minValue = minValue;
        maxValue = maxValue;
    } else if (maxValue - minValue < 50) {
        minValue = (minValue / 10) * 10;
        maxValue = (maxValue / 10 + 1) * 10;
    } else if (maxValue - minValue < 500) {
        minValue = (minValue / 100) * 100;
        maxValue = (maxValue / 100 + 1) * 100;
    } else {
        minValue = (minValue / 1000) * 1000;
        maxValue = (maxValue / 1000 + 1) * 1000;
    }
    
    //根据最大值、最小值、和等分数量 设置Y值数据
    leftAxis.axisMinimum = minValue;//设置Y轴的最小值
    leftAxis.axisMaximum = maxValue;//设置Y轴的最大值
    leftAxis.inverted = NO;//是否将Y轴进行上下翻转
    leftAxis.axisLineWidth = 0.5;//Y轴线宽
    leftAxis.axisLineColor = [UIColor grayColor];//Y轴颜色
    leftAxis.labelPosition = YAxisLabelPositionOutsideChart;//label位置
    leftAxis.labelTextColor = [UIColor grayColor];//文字颜色
    leftAxis.labelFont = [UIFont systemFontOfSize:10.0f];//文字字体
    leftAxis.axisLineWidth = 0;
    
    //设置虚线样式的网格线
    leftAxis.gridLineDashLengths = @[@3.0f, @0.0f];
    leftAxis.gridColor = colorWithHexString(@"f4f6f5");//网格线颜色
    leftAxis.gridAntialiasEnabled = YES;//开启抗锯齿
    
    self.data = [self setData];
    
    //为柱形图提供数据
    self.barChartView.data = self.data;
    
    //设置动画效果，可以设置X轴和Y轴的动画效果
    [self.barChartView animateWithYAxisDuration:1.0f];
    
    UIView* view = [self viewWithTag:321];
    if (!view) {
        UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 170, ScreenWidth, 30)];
        view.tag = 321;
        view.backgroundColor = [UIColor whiteColor];
        [self.barChartView addSubview:view];
    }
    [self addSubview:self.rightTime];
    [self addSubview:self.leftTime];
}

//为柱形图设置数据
- (LineChartData *)setData{
    
    
    NSInteger xVals_count = _dataArray.count;//X轴上要显示多少条数据
    
    //对应Y轴上面需要显示的数据
    NSMutableArray *yVals = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < xVals_count; i++) {
        
        double val = [_dataArray[i] doubleValue];
        BarChartDataEntry *entry = [[BarChartDataEntry alloc] initWithX:i y:val];
        
        [yVals addObject:entry];
    }
    
    //创建BarChartDataSet对象，其中包含有Y轴数据信息，以及可以设置柱形样式
    LineChartDataSet *set1 = [[LineChartDataSet alloc] initWithValues:yVals label:nil];
//    set1.barBorderWidth =0.0;//边学宽
    set1.drawValuesEnabled = NO;//是否在柱形图上面显示数值
    set1.highlightEnabled = NO;//点击选中柱形图是否有高亮效果，（双击空白处取消选中）
//    set1.highlightAlpha = 1;
    [set1 setColors:@[ColorBlue]];
    set1.drawCirclesEnabled = NO;
    set1.drawFilledEnabled = YES;
    [set1 setFillColor:colorWithHexString(@"#a0aefc")];
    [set1 setFillAlpha:1];
//    [set1 setHighlightColor:ColorBlue];
    //将BarChartDataSet对象放入数组中
    NSMutableArray *dataSets = [[NSMutableArray alloc] init];
    [dataSets addObject:set1];
    
    //创建BarChartData对象, 此对象就是barChartView需要最终数据对象
    LineChartData *data = [[LineChartData alloc] initWithDataSets:dataSets];
    //设置宽度   柱形之间的间隙占整个柱形(柱形+间隙)的比例
//    [data setBarWidth:0.3];
    [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:10.f]];//文字字体
    [data setValueTextColor:[UIColor orangeColor]];//文字颜色
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    //自定义数据显示格式  小数点形式
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    
    //    [formatter setPositiveFormat:@"#0.0"];
    ChartDefaultValueFormatter  *forma = [[ChartDefaultValueFormatter alloc] initWithFormatter:formatter];
    [data setValueFormatter:forma];
    
    return data;
}

#pragma mark - ChartViewDelegate

//点击选中柱形时回调
- (void)chartValueSelected:(ChartViewBase * _Nonnull)chartView entry:(ChartDataEntry * _Nonnull)entry highlight:(ChartHighlight * _Nonnull)highlight{
}
//没有选中柱形图时回调，当选中一个柱形图后，在空白处双击，就可以取消选择，此时会回调此方法
- (void)chartValueNothingSelected:(ChartViewBase * _Nonnull)chartView{

}
//x标题
- (NSString *)stringForValue:(double)value axis:(ChartAxisBase *)axis
{
    //    NSLog(@"%@",)
    //    return  self.xVals[(int)value];
    return @"";
}

- (UILabel *)rightTime {
    if (!_rightTime) {
        _rightTime = [UILabel new];
        [_rightTime rect:CGRectMake(ScreenWidth - 120, BOTTOM(self.barChartView) - 40, 100, 15) aligment:Right font:14 isBold:false text:@"" textColor:colorWithHexString(@"#afb9b6") superView:nil];
        //        _rightTime.backgroundColor = [UIColor whiteColor];
        
    }
    return _rightTime;
}

- (UILabel *)leftTime {
    if (!_leftTime) {
        _leftTime = [UILabel new];
        [_leftTime rect:CGRectMake(70 , BOTTOM(self.barChartView) - 40, 100, 20) aligment:Left font:14 isBold:false text:@"" textColor:colorWithHexString(@"#afb9b6") superView:nil];
        //        _leftTime.backgroundColor = [UIColor whiteColor];
    }
    return _leftTime;
}

- (void)setTimeArray:(NSArray *)timeArray {
    _timeArray = timeArray;
    if (self.skChooseView.currentIndex == 0 || self.skChooseView.currentIndex == 1) {
        _rightTime.text = [[_timeArray lastObject] substringWithRange:NSMakeRange(11, 8)];
        _leftTime.text = [[_timeArray firstObject] substringWithRange:NSMakeRange(11, 8)];
    } else {
        _rightTime.text = [[_timeArray lastObject] substringToIndex:11];
        _leftTime.text = [[_timeArray firstObject] substringToIndex:11];
    }
}
-(SKChooseView *)skChooseView{
    if (!_skChooseView) {
        if (![_currencyName isEqualToString:@"FML"]) {
            _skChooseView = [[SKChooseView alloc]initWithFrame:CGRectMake(26, 10, ScreenWidth - 40, 45) nameAry:@[@"60分",@"1天",@"1周",@"1月",@"1年"] unselect:colorWithHexString(@"#4a4a4a") select:ColorWhite More:false font:12 selectFont:18 isBlod:false lineColor:ColorBlue];
        }else {
            _skChooseView = [[SKChooseView alloc]initWithFrame:CGRectMake(26, 10, ScreenWidth - 40, 45) nameAry:@[@"1小时",@"6小时",@"12小时",@"1天",@"1周"] unselect:colorWithHexString(@"#4a4a4a") select:ColorWhite More:false font:12 selectFont:18 isBlod:false lineColor:ColorBlue];
        }
    }
    return _skChooseView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        [_titleLabel rect:CGRectMake(25, 55, 100, 15) aligment:Left font:12 isBold:NO text:@"单位:USDT" textColor:ColorGrayText superView:nil];
        if ([_currencyName isEqualToString:@"FML"]) {
            _titleLabel.text = @"单位:ETH";
        }
//        _titleLabel.hidden = YES;
    }
    return _titleLabel;
}
- (UILabel *)persentLabel{
    if (!_persentLabel) {
        _persentLabel = [UILabel new];
        [_persentLabel rect:CGRectMake(ScreenWidth-20-150, TOP(self.titleLabel), 150, 25) aligment:Center font:13 isBold:false text:@"-345.00(-0.48%)" textColor:[UIColor whiteColor] superView:nil];
        _persentLabel.backgroundColor = colorWithHexString(@"#ff6647");
        _persentLabel.layer.masksToBounds = YES;
        _persentLabel.layer.cornerRadius = 3;
    }
    return _persentLabel;
}

@end
