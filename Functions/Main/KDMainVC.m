//
//  KDMainVC.m
//  Functions
//
//  Created by 范魁东 on 2019/11/7.
//  Copyright © 2019 FanKD. All rights reserved.
//

#import "KDMainVC.h"
#import "KDLeftAlignedVC.h"
#import "OnScreenRenderVC.h"

@interface KDMainVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , strong) KDBaseTableView *tableView;

@property (nonatomic , strong) NSArray *titleArr;

@end

@implementation KDMainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.titleArr = @[@"CollectionItem左对齐",@"离屏渲染"];
    
    self.tableView = [[KDBaseTableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.rowHeight = 50;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"identifier";
    KDBaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[KDBaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = self.titleArr[indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        KDLeftAlignedVC *vc = [[KDLeftAlignedVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 1) {
        OnScreenRenderVC *vc = [[OnScreenRenderVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else if (indexPath.row == 2) {
        
    }else if (indexPath.row == 3) {
        
    }else if (indexPath.row == 4) {
        
    }else if (indexPath.row == 5) {
        
    }else if (indexPath.row == 6) {
        
    }else if (indexPath.row == 7) {
        
    }else if (indexPath.row == 8) {
        
    }else if (indexPath.row == 9) {
        
    }else if (indexPath.row == 10) {
        
    }else if (indexPath.row == 11) {
        
    }
}

@end
