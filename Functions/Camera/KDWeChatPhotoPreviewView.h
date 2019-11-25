//
//  KDWeChatPhotoPreviewView.h
//  Functions
//
//  Created by 范魁东 on 2019/11/22.
//  Copyright © 2019 FanKD. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol KDWeChatPhotoPreviewViewDelegate <NSObject>

- (void)manageCurrentPreviewPhotoWithAction:(NSInteger)manage andImage:(UIImage *)image;

@end

@interface KDWeChatPhotoPreviewView : UIView

@property (nonatomic , weak) id <KDWeChatPhotoPreviewViewDelegate> delegate;

- (void)setPreviewImage:(UIImage *)image;

@end

NS_ASSUME_NONNULL_END
