//
//  UIView+AddCorner.h
//  Functions
//
//  Created by 范魁东 on 2019/11/8.
//  Copyright © 2019 FanKD. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (AddCorner)
//利用Core Graphics 画出圆角，解决离屏渲染
- (void)kd_drawRectWithRoundedCorner:(CGFloat)redius;

@end

NS_ASSUME_NONNULL_END
