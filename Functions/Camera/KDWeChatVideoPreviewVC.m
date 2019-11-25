//
//  KDWeChatVideoPreviewVC.m
//  Functions
//
//  Created by 范魁东 on 2019/11/22.
//  Copyright © 2019 FanKD. All rights reserved.
//

#import "KDWeChatVideoPreviewVC.h"
#import <AVFoundation/AVFoundation.h>

@interface KDWeChatVideoPreviewVC ()

@property (nonatomic , strong) AVPlayer *player;

@property (nonatomic , strong) AVPlayerLayer *playerLayer;

@property (nonatomic , strong) UIButton *deleteBtn;

@property (nonatomic , strong) UIButton *saveBtn;

@end

@implementation KDWeChatVideoPreviewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
}

- (void)setPhotoImage:(UIImage *)image {
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imgV.contentMode = UIViewContentModeScaleAspectFit;
    imgV.image = image;
    [self.view addSubview:imgV];
    
    [self setupSubviews];
}

- (void)setVideoURL:(NSURL *)url {
    
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:url];
    
    self.player = [AVPlayer playerWithPlayerItem:playerItem];
    
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    self.playerLayer.frame = self.view.bounds;
    self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:self.playerLayer];
    
    [self addNotification];
    
    [self.player play];
    
    [self setupSubviews];
}

- (void)setupSubviews {
    self.deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(kSCREEN_WIDTH/4-40, kSCREEN_HEIGHT-150, 80, 80)];
    [self.deleteBtn setImage:[UIImage imageNamed:@"ico_camera_cancel.png"] forState:UIControlStateNormal];
    self.deleteBtn.adjustsImageWhenHighlighted = NO;
    [self.deleteBtn addTarget:self action:@selector(deletePreviewSources) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.deleteBtn];
    
    self.saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(kSCREEN_WIDTH*3/4-40, kSCREEN_HEIGHT-150, 80, 80)];
    [self.saveBtn setImage:[UIImage imageNamed:@"ico_camera_confirm.png"] forState:UIControlStateNormal];
    self.saveBtn.adjustsImageWhenHighlighted = NO;
    [self.saveBtn addTarget:self action:@selector(savePreviewSources) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.saveBtn];
}

- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
}

- (void)playbackFinished:(NSNotification *)notification {//播放完了,从头开始
    [self.player seekToTime:CMTimeMake(0, 1)];
    [self.player play];
}

#pragma mark - ACTION

- (void)deletePreviewSources {
    if (self.managePhoto) {
        self.managePhoto(YES);
    }
    
    if (self.manageVideo) {
        self.manageVideo(YES);
    }
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)savePreviewSources {
    if (self.managePhoto) {
        self.managePhoto(NO);
    }
    
    if (self.manageVideo) {
        self.manageVideo(NO);
        
    }
    
    [self.presentingViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
}

@end
