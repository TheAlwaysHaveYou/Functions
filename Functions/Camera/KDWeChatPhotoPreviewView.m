//
//  KDWeChatPhotoPreviewView.m
//  Functions
//
//  Created by 范魁东 on 2019/11/22.
//  Copyright © 2019 FanKD. All rights reserved.
//

#import "KDWeChatPhotoPreviewView.h"

@interface KDWeChatPhotoPreviewView ()

@property (nonatomic , strong) UIImageView *imgV;

@property (nonatomic , strong) UIButton *deleteBtn;

@property (nonatomic , strong) UIButton *saveBtn;

@property (nonatomic , strong) UIImage *image;

@end

@implementation KDWeChatPhotoPreviewView


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        
        self.imgV = [[UIImageView alloc] initWithFrame:self.bounds];
        self.imgV.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.imgV];
        
        self.deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(kSCREEN_WIDTH/4-20, kSCREEN_HEIGHT-160, 40, 40)];
        self.deleteBtn.backgroundColor = [UIColor redColor];
        [self.deleteBtn addTarget:self action:@selector(deleteCurrentPhoto) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.deleteBtn];
        
        self.saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(kSCREEN_WIDTH*3/4-20, kSCREEN_HEIGHT-160, 40, 40)];
        self.saveBtn.backgroundColor = [UIColor greenColor];
        [self.saveBtn addTarget:self action:@selector(saveCurrentPhoto) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.saveBtn];
        
    }
    return self;
}

- (void)setPreviewImage:(UIImage *)image {
    self.imgV.image = image;
    self.image = image;
}

- (void)deleteCurrentPhoto {
    if ([self.delegate respondsToSelector:@selector(manageCurrentPreviewPhotoWithAction:andImage:)]) {
        [self.delegate manageCurrentPreviewPhotoWithAction:0 andImage:self.image];
    }
}

- (void)saveCurrentPhoto {
    if ([self.delegate respondsToSelector:@selector(manageCurrentPreviewPhotoWithAction:andImage:)]) {
        [self.delegate manageCurrentPreviewPhotoWithAction:1 andImage:self.image];
    }
}

@end
