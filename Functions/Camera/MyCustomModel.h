//
//  MyCustomModel.h
//  Functions
//
//  Created by 范魁东 on 2020/1/7.
//  Copyright © 2020 FanKD. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@protocol MyCustomDelegate <NSObject>

@required

- (instancetype)initWithName:(NSString *)name;

//@optional
@property (nonatomic , strong) NSString *name;

@end

@interface MyCustomModel : NSObject<MyCustomDelegate>

@end

NS_ASSUME_NONNULL_END
