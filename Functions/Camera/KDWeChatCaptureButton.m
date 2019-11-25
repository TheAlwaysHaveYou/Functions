//
//  KDWeChatCaptureButton.m
//  Functions
//
//  Created by 范魁东 on 2019/11/22.
//  Copyright © 2019 FanKD. All rights reserved.
//

#import "KDWeChatCaptureButton.h"

@interface KDWeChatCaptureButton ()

@property (nonatomic , strong) UIView *videoView;

@property (nonatomic , strong) UIView *photoView;

@property (nonatomic , strong) NSTimer *timer;

@property (nonatomic , strong) CAShapeLayer *cycleLayer;

@property (nonatomic , assign) CGFloat second;

@property (nonatomic , assign) CaptureMediaType mediaType;

@end

@implementation KDWeChatCaptureButton

- (instancetype)initWithFrame:(CGRect)frame andCaptureMediaType:(CaptureMediaType)type {
    self = [super initWithFrame:frame];
    if (self) {
        self.mediaType = type;
        
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews {
    self.videoView = [[UIView alloc] initWithFrame:self.bounds];
    self.videoView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.8];
    self.videoView.layer.cornerRadius = 50;
    self.videoView.layer.masksToBounds = YES;
    self.videoView.hidden = YES;
    self.videoView.transform = CGAffineTransformRotate(CGAffineTransformIdentity, -M_PI / 2);
    [self addSubview:self.videoView];
    
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:self.videoView.bounds];
    
    self.cycleLayer = [CAShapeLayer layer];
    self.cycleLayer.frame = self.videoView.bounds;
    self.cycleLayer.position = self.videoView.center;
    self.cycleLayer.fillColor = [UIColor clearColor].CGColor;
    self.cycleLayer.lineWidth = 20.f;
    self.cycleLayer.strokeColor = [UIColor redColor].CGColor;
    self.cycleLayer.strokeStart = 0;
    self.cycleLayer.strokeEnd = 0;
    self.cycleLayer.path = path.CGPath;
    [self.videoView.layer addSublayer:self.cycleLayer];
    
    
    self.photoView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, self.frame.size.width - 20, self.frame.size.height - 20)];
    self.photoView.backgroundColor = [UIColor whiteColor];
    self.photoView.layer.cornerRadius = 40;
    self.photoView.layer.masksToBounds = YES;
    [self addSubview:self.photoView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(takePhotos)];
    if (self.mediaType == CaptureMediaTypeAll || self.mediaType == CaptureMediaTypePhoto) {
        [self addGestureRecognizer:tap];
    }
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(takeVideos:)];
    if (self.mediaType == CaptureMediaTypeAll || self.mediaType == CaptureMediaTypeVideo) {
        [self addGestureRecognizer:longPress];
    }
    
    [tap requireGestureRecognizerToFail:longPress];
}

#pragma mark - ACTION

- (void)takePhotos {
    if ([self.delegate respondsToSelector:@selector(captureButtonActoinWithMediaType:recordVideoFinish:)]) {
        [self.delegate captureButtonActoinWithMediaType:CaptureMediaTypePhoto recordVideoFinish:NO];
    }
}

- (void)takeVideos:(UILongPressGestureRecognizer *)longPress {
    if (longPress.state == UIGestureRecognizerStateBegan) {
        self.videoView.hidden = NO;
        [self creatNewThread];
        
        if ([self.delegate respondsToSelector:@selector(captureButtonActoinWithMediaType:recordVideoFinish:)]) {
            [self.delegate captureButtonActoinWithMediaType:CaptureMediaTypeVideo recordVideoFinish:NO];
        }
    }else if (longPress.state == UIGestureRecognizerStateEnded || longPress.state == UIGestureRecognizerStateCancelled || longPress.state == UIGestureRecognizerStateFailed){
        self.videoView.hidden = YES;
        [self stopTimer];
        self.second = 0;
        
        if ([self.delegate respondsToSelector:@selector(captureButtonActoinWithMediaType:recordVideoFinish:)]) {
            [self.delegate captureButtonActoinWithMediaType:CaptureMediaTypeVideo recordVideoFinish:YES];
        }
    }
}

#pragma makr - Timer 定时器动画
- (void)creatNewThread {
    [NSThread detachNewThreadSelector:@selector(creatTimerTask) toTarget:self withObject:nil];
}

- (void)creatTimerTask {
    if (![NSThread isMainThread]) {
        if (!self.timer) {
            self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(recycleAnimation) userInfo:nil repeats:YES];
            [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
            [[NSRunLoop currentRunLoop] run];
        }
    }
}

- (void)stopTimer {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
        
        self.cycleLayer.strokeEnd = 0;
    }
}

- (void)recycleAnimation {
    self.second += 0.1;
    self.cycleLayer.strokeEnd += 1.0/600;
    
    NSLog(@"---------  fire  -------- %f ------- %f",self.second,self.cycleLayer.strokeEnd);
    if (self.second >= 60.0) {//总共可以录制一分钟
        NSLog(@"录制一分钟了");
        self.userInteractionEnabled = NO;
        [self stopTimer];
        
        if ([self.delegate respondsToSelector:@selector(captureButtonActoinWithMediaType:recordVideoFinish:)]) {
            [self.delegate captureButtonActoinWithMediaType:CaptureMediaTypeVideo recordVideoFinish:YES];
        }
        
        self.userInteractionEnabled = YES;
    }
}

- (void)dealloc {
    [self stopTimer];
}

@end
