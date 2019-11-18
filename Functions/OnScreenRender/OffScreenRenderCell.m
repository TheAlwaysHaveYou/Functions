//
//  OffScreenRenderCell.m
//  Functions
//
//  Created by 范魁东 on 2019/11/8.
//  Copyright © 2019 FanKD. All rights reserved.
//

#import "OffScreenRenderCell.h"

@interface OffScreenRenderCell ()

@property (nonatomic , strong) UIView *clipView;

@end

@implementation OffScreenRenderCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.clipView = [[UIView alloc] initWithFrame:self.bounds];
        self.clipView.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.5];
        self.clipView.layer.cornerRadius = frame.size.width/2;
        self.clipView.layer.masksToBounds = YES;
        [self.contentView addSubview:self.clipView];
    }
    return self;
}

- (void)prepareForReuse {
    self.clipView.layer.cornerRadius = self.frame.size.width/2;
    self.clipView.layer.masksToBounds = YES;
}

@end
