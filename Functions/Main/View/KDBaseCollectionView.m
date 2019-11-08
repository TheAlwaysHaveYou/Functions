//
//  KDBaseCollectionView.m
//  Functions
//
//  Created by 范魁东 on 2019/11/7.
//  Copyright © 2019 FanKD. All rights reserved.
//

#import "KDBaseCollectionView.h"

@implementation KDBaseCollectionView

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.backgroundColor =[UIColor whiteColor];
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
//        self.alwaysBounceVertical = YES;
//        self.alwaysBounceHorizontal = YES;
        self.pagingEnabled = YES;
//        if (@available(iOS 11.0, *)) {
//            self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//        }
    }
    return self;
}

@end
