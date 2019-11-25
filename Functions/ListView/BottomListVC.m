//
//  BottomListVC.m
//  Functions
//
//  Created by 范魁东 on 2019/11/22.
//  Copyright © 2019 FanKD. All rights reserved.
//

#import "BottomListVC.h"
#import "BottomListView.h"

@interface BottomListVC ()

@end

@implementation BottomListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    BottomListView *listView = [[BottomListView alloc] init];
    [listView showInView:self.view];
}



@end
