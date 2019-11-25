//
//  KDWeChatCaptureButton.h
//  Functions
//
//  Created by 范魁东 on 2019/11/22.
//  Copyright © 2019 FanKD. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger , CaptureMediaType ) {
    CaptureMediaTypeAll = 0,//默认可拍照可录视频
    CaptureMediaTypePhoto ,//拍照
    CaptureMediaTypeVideo ,//仅录视频
};

@protocol KDWeChatCaptureButtonDelegate <NSObject>

- (void)captureButtonActoinWithMediaType:(CaptureMediaType)mediaType recordVideoFinish:(BOOL)recordFinish;

@end

@interface KDWeChatCaptureButton : UIView

@property (nonatomic , weak) id <KDWeChatCaptureButtonDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame andCaptureMediaType:(CaptureMediaType)type;

@end

NS_ASSUME_NONNULL_END
