//
//  KDBaseScrollView.m
//  Functions
//
//  Created by 范魁东 on 2019/11/7.
//  Copyright © 2019 FanKD. All rights reserved.
//

#import "KDBaseScrollView.h"

@implementation KDBaseScrollView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
//        if (@available(iOS 11.0, *)) {
//            self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//        }
    }
    return self;
}

@end
