//
//  UIView+AddCorner.m
//  Functions
//
//  Created by 范魁东 on 2019/11/8.
//  Copyright © 2019 FanKD. All rights reserved.
//

#import "UIView+AddCorner.h"

@implementation UIView (AddCorner)

- (void)kd_clipRoundedCorner:(CGFloat)redius backgroundColor:(UIColor *)backgroundColor {
    UIImageView *imgV = [[UIImageView alloc] initWithImage:[self kd_drawRectWithRoundedCorner:redius backgroundColor:backgroundColor]];
    [self insertSubview:imgV atIndex:0];
}

- (UIImage *)kd_drawRectWithRoundedCorner:(CGFloat)redius backgroundColor:(UIColor *)backgroundColor {
    /*
     第二个参数 opaque
     A Boolean flag indicating whether the bitmap is opaque. If you know the bitmap is fully opaque, specify YES to ignore the alpha channel and optimize the bitmap’s storage. Specifying NO means that the bitmap must include an alpha channel to handle any partially transparent pixels
     一个布尔标志，指示位图是否不透明。如果您知道位图是完全不透明的，请指定YES以忽略alpha通道并优化位图的存储。指定NO意味着位图必须包含一个alpha通道来处理任何部分透明的像素
     
     个人理解:png格式的图片保留了alpha通道  设置为NO， jpg没有alpha通道，设置为YES
     */
    
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    UIGraphicsBeginImageContextWithOptions(self.frame.size, false, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(context, backgroundColor.CGColor);
    CGContextSetFillColorWithColor(context, backgroundColor.CGColor);
    CGContextMoveToPoint(context, width/2, 0);
    CGContextAddArcToPoint(context, width/2, 0, width, 0, redius);
    CGContextAddArcToPoint(context, width, 0, width, height, redius);
    CGContextAddArcToPoint(context, width, height, 0, height, redius);
    CGContextAddArcToPoint(context, 0, height, 0, 0, redius);
    CGContextAddArcToPoint(context, 0, 0, width/2, 0, redius);
    CGContextDrawPath(context, kCGPathFillStroke);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
