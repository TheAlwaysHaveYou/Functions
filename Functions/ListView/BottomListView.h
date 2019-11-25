//
//  BottomListView.h
//  Functions
//
//  Created by 范魁东 on 2019/11/22.
//  Copyright © 2019 FanKD. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BottomListView : UIView

@property (nonatomic , assign) BOOL isShow;

- (void)showInView:(UIView *)view;

- (void)dismiss;

@end

NS_ASSUME_NONNULL_END
