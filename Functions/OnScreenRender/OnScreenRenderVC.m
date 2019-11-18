//
//  OnScreenRenderVC.m
//  Functions
//
//  Created by 范魁东 on 2019/11/8.
//  Copyright © 2019 FanKD. All rights reserved.
//

#import "OnScreenRenderVC.h"
#import "OnScreenRenderCell.h"
#import "OffScreenRenderCell.h"

@interface OnScreenRenderVC ()<UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic , strong) KDBaseCollectionView *collectionView;

@property (nonatomic , assign , getter=isOffScreen) BOOL offScreen;

@end

@implementation OnScreenRenderVC

static NSString * const identifier = @"onscreen";
static NSString * const otherIdentifier = @"offscreen";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"当前触发离屏渲染";
    self.offScreen = YES;
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(10, 10);
    layout.minimumLineSpacing = 1;
    layout.minimumInteritemSpacing = 1;
    
    self.collectionView = [[KDBaseCollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    [self.collectionView registerClass:[OnScreenRenderCell class] forCellWithReuseIdentifier:identifier];
    [self.collectionView registerClass:[OffScreenRenderCell class] forCellWithReuseIdentifier:otherIdentifier];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"改变状态" style:UIBarButtonItemStylePlain target:self action:@selector(rightItemFunctionClick:)];
}

- (void)rightItemFunctionClick:(UIBarButtonItem *)item {
    self.offScreen = !self.isOffScreen;
    self.title = self.isOffScreen?@"当前触发离屏渲染":@"没有触发离屏渲染";
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 5000;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isOffScreen) {
        OffScreenRenderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:otherIdentifier forIndexPath:indexPath];
        return cell;
    }else {
        OnScreenRenderCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        return cell;
    }
}

#pragma mark - UICollectionViewDelegate


@end
