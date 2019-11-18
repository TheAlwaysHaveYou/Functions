//
//  KDPerformanceUtil.h
//  Functions
//
//  Created by 范魁东 on 2019/11/8.
//  Copyright © 2019 FanKD. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KDPerformanceUtil : NSObject

+ (CGFloat)usedMemoryInMB;

+ (CGFloat)cpuUsage;

@end

NS_ASSUME_NONNULL_END
