//
//  Answer.m
//  FML
//
//  Created by apple on 2018/8/2.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "Answer.h"

@implementation Answer

+ (NSArray *)firstTitleArray {
    return @[@"1、您的家庭可支配年收入为（折合人民币）？", @"2、在您每年的家庭可支配收入中，可用于金融投资（储蓄存款除外）的比例为？"];
}

+ (NSArray<NSArray *> *)firstAnswerArray {
    return @[@[@"50万元以下（2分）",
               @"50—100万元（4分）",
               @"100—500万元（6分）",
               @"500—1000万元（8分）",
               @"1000万元以上（10分）"],
             @[@"小于10%（2分）",
               @"10%至25%（4分）",
               @"25%至50%（6分）",
               @"大于50%（8分）"]
             ];
}

+ (NSArray *)secondTitleArray {
    return @[@"1、 您的投资知识可描述为：", @"2、您的投资经验可描述为：", @"3、您有多少年投资基金、股票、信托、私募证券或金融衍生产品等风险投资品的经验？"];
}

+ (NSArray<NSArray *> *)secondAnswerArray {
    return  @[@[@"有限：基本没有金融产品方面的知识（2分）",
                @"一般：对金融产品及其相关风险具有基本的知识和理解（5分）",
                @"丰富：对金融产品及其相关风险具有丰富的知识和理解（10分）",
                ],
              @[@"除银行储蓄外，基本没有其他投资经验（2分）",
                @"购买过债券、保险等理财产品（4分）",
                @"参与过股票、基金等产品的交易（8分）",
                @"参与过权证、期货、期权等产品的交易（10分）"],
              @[@"没有经验（2分）",
                @"少于2年（4分）",
                @"2至5年（6分）",
                @"5至10年（8分）",
                @"10年以上（10分）"]
              ];
}

+ (NSArray *)thirdTitleArray {
    return @[@"1、您计划的投资期限是多久？", @"2、您的投资目的是？"];
}

+ (NSArray<NSArray *> *)thirdAnswerArray {
    return  @[@[@"1年以下（2分）",
                @"1至3年（4分）",
                @"3至5年（6分）",
                @"5年以上（8分）",
                ],
              @[@"资产保值（2分）",
                @"资产稳健增长（5分）",
                @"资产迅速增长（8分）",
                ]
              ];
}

+ (NSArray *)fourthTitleArray {
    return @[@"1、以下哪项描述最符合您的投资态度？", @"2、假设有两种投资：投资A预期获得10%的收益，可能承担的损失非常小；投资B预期获得30%的收益，但可能承担较大亏损。您会怎么支配您的投资：", @"3、您认为自己能承受的最大投资损失是多少？"];
}

+ (NSArray<NSArray *> *)fourthAnswerArray {
    return  @[@[@"厌恶风险，不希望本金损失，希望获得稳定回报（2分）",
                @"保守投资，不希望本金损失，愿意承担一定幅度的收益波动（4分）",
                @"寻求资金的较高收益和成长性，愿意为此承担有限本金损失（6分）",
                @"希望赚取高回报，愿意为此承担较大本金损失（8分）",
                ],
              @[@"全部投资于收益较小且风险较小的A（2分）",
                @"同时投资于A和B，但大部分资金投资于收益较小且风险较小的A（4分）",
                @"同时投资于A和B，但大部分资金投资于收益较大且风险较大的B（8分）",
                @"全部投资于收益较大且风险较大的B（10分）",
                ],
              @[@"10%以内（2分）",
                @"10%-30%（4分）",
                @"30%-50%（6分）",
                @"超过50%（8分）",
                ],
              ];
}
@end
