//
//  KDWeChatVideoPreviewVC.h
//  Functions
//
//  Created by 范魁东 on 2019/11/22.
//  Copyright © 2019 FanKD. All rights reserved.
//

#import "KDBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface KDWeChatVideoPreviewVC : KDBaseViewController

@property (nonatomic , copy) void(^managePhoto)(BOOL);
@property (nonatomic , copy) void(^manageVideo)(BOOL);

- (void)setPhotoImage:(UIImage *)image;
- (void)setVideoURL:(NSURL *)url;

@end

NS_ASSUME_NONNULL_END
