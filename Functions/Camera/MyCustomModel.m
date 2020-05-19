//
//  MyCustomModel.m
//  Functions
//
//  Created by 范魁东 on 2020/1/7.
//  Copyright © 2020 FanKD. All rights reserved.
//

#import "MyCustomModel.h"

@implementation MyCustomModel

- (instancetype)initWithName:(NSString *)name {
    self = [super init];
    if (self) {
        self.name = name;
    }
    return self;
}

@synthesize name;

@end
