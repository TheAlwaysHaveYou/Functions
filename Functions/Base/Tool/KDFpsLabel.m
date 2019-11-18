//
//  KDFpsLabel.m
//  Functions
//
//  Created by 范魁东 on 2019/11/8.
//  Copyright © 2019 FanKD. All rights reserved.
//

#import "KDFpsLabel.h"
#import "KDPerformanceUtil.h"

@interface KDFpsLabel ()

@property (nonatomic , strong) CADisplayLink *displayLink;
@property (nonatomic , assign) NSTimeInterval lastTime;
@property (nonatomic , assign) NSInteger count;

@end

@implementation KDFpsLabel

- (instancetype)init {
    self = [self initWithFrame:CGRectZero];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor alloc] initWithWhite:0.3 alpha:0.5];
        self.textAlignment = NSTextAlignmentCenter;
        self.font = [UIFont systemFontOfSize:12];
        
        self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(screenRefresh:)];
        [self.displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    }
    return self;
}

- (void)screenRefresh:(CADisplayLink *)displayLink {
    if (self.lastTime == 0) {
        self.lastTime = displayLink.timestamp;
        return;
    }
    
    self.count += 1;
    NSTimeInterval timeDelta = displayLink.timestamp-self.lastTime;
    if (timeDelta < 0.25) {
        return;
    }
    self.lastTime = displayLink.timestamp;
    CGFloat fps = self.count*1.0/timeDelta;
    self.count = 0;
    self.text = [NSString stringWithFormat:@"FPS:%.1f CPU:%.2f%% Memory:%.2fM",fps,[KDPerformanceUtil cpuUsage],[KDPerformanceUtil usedMemoryInMB]];
    self.textColor = fps>30 ?[UIColor greenColor]:[UIColor redColor];
}

@end
