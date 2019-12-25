//
//  UITextField+usdt.m
//  FML
//
//  Created by apple on 2018/8/13.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "UITextField+usdt.h"
#import "SwizzlingDefine.h"
#import "ZMChineseConvert.h"
#import "UITextField+usdt.h"

static char kMaxLength;


@implementation UItextFieldMaxLengthObserver

- (void)textChange:(UITextField *)textField {
    NSString *destText = textField.text;
    NSUInteger maxLength = textField.maxLength;
    
    // 对中文的特殊处理，shouldChangeCharactersInRangeWithReplacementString 并不响应中文输入法的选择事件
    // 如拼音输入时，拼音字母处于选中状态，此时不判断是否超长
    UITextRange *selectedRange = [textField markedTextRange];
    if (!selectedRange || !selectedRange.start) {
        if (destText.length > maxLength) {
            textField.text = [destText substringToIndex:maxLength];
        }
    }
}

@end

@implementation UITextField (usdt)

static UItextFieldMaxLengthObserver *observer;

+ (void)load {
    observer = [[UItextFieldMaxLengthObserver alloc] init];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        swizzling_exchangeMethod(self, @selector(setText:), @selector(fml_setText:));
    });
}

- (void)fml_setText:(NSString *)text {
    if (![text containsString:@"≈"] && [text containsString:@"usdt"] && ![text isEqualToString:@"0 usdt"] && (text.length > 5)) {
        text = [@"≈" stringByAppendingString:text];
    }
    text = [ZMChineseConvert convertSimplifiedToTraditional:text];
    [self fml_setText:text];
}


- (void)setMaxLength:(NSUInteger)maxLength {
    objc_setAssociatedObject(self, &kMaxLength, @(maxLength), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (maxLength) {
        [self addTarget:observer
                 action:@selector(textChange:)
       forControlEvents:UIControlEventEditingChanged];
    }
}

-(NSUInteger)maxLength {
    NSNumber *number = objc_getAssociatedObject(self, &kMaxLength);
    return [number integerValue];
}

@end
