//
//  OnScreenRenderCell.m
//  Functions
//
//  Created by 范魁东 on 2019/11/8.
//  Copyright © 2019 FanKD. All rights reserved.
//

#import "OnScreenRenderCell.h"

@interface OnScreenRenderCell ()

@property (nonatomic , strong) UIView *clipView;

@end

@implementation OnScreenRenderCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.clipView = [[UIView alloc] initWithFrame:self.bounds];
        [self.clipView kd_clipRoundedCorner:frame.size.width/2 backgroundColor:[[UIColor greenColor] colorWithAlphaComponent:0.5]];
        [self.contentView addSubview:self.clipView];
    }
    return self;
}

- (void)prepareForReuse {
//    self.clipView.layer.cornerRadius = self.frame.size.width/2;
//    self.clipView.layer.masksToBounds = YES;
}

@end
