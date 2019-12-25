//
//  AlipayManager.m
//  FML
//
//  Created by apple on 2018/8/16.
//  Copyright © 2018年 Jacky. All rights reserved.
//

#import "AlipayManager.h"
#import "ZXingObjC.h"

@implementation AlipayManager

+ (void)getAlipayQRCode:(void (^)(NSString* str, BOOL isGetCodeStr))payBlock {

    NSMutableDictionary* dict = [NSMutableDictionary dictionary];
    
    RequestMessage* msg = [[RequestMessage alloc] initWithUrl:@"sysParam/alipay_code.htm".apifml method:POST args:dict];
    [RequestEngine doRqquestWithMessage:msg callbackBlock:^(ResponseMessage *responseMessage) {
        if (responseMessage.errorMessage) {
            payBlock(responseMessage.errorMessage, NO);
        } else {
            NSURL *url=[NSURL URLWithString:String(responseMessage.bussinessData[@"alipayPicture"])];
            NSData *data=[NSData dataWithContentsOfURL:url];
            //将网络数据初始化为UIImage对象
            UIImage *image=[UIImage imageWithData:data];
            NSString* codeStr = [self resultQRCode:image];
            if ([codeStr isEqualToString:@"获取支付链接失败"]) {
                payBlock(codeStr, NO);
            } else {
                NSArray* arr = [codeStr componentsSeparatedByString:@"//QR.ALIPAY.COM/"];
                if (arr.count == 2) {
                    payBlock(arr[1], YES);
                } else {
                    NSArray* arr = [codeStr componentsSeparatedByString:@"qr.alipay.com/"];
                    if (arr.count == 2) {
                        payBlock(arr[1], YES);
                    } else {
                        payBlock(@"获取支付链接失败", NO);
                    }
                }
            }
        }
    }];
}

+ (NSString *)resultQRCode:(UIImage *)image {
    CGImageRef imageRef = image.CGImage;
    ZXCGImageLuminanceSource * source = [[ZXCGImageLuminanceSource alloc] initWithCGImage:imageRef];
    ZXBinaryBitmap * bitmap = [ZXBinaryBitmap binaryBitmapWithBinarizer:[ZXHybridBinarizer binarizerWithSource:source]];
    NSError * error = nil;
    ZXDecodeHints * hints = [ZXDecodeHints hints];
    ZXMultiFormatReader * reader = [ZXMultiFormatReader reader];
    ZXResult * result = [reader decode:bitmap hints:hints error:&error];
    if (result) {
        return result.text;
    } else {
        return @"获取支付链接失败";
    }
}


@end
