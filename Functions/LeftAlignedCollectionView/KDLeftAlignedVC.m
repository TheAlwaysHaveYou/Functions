//
//  KDLeftAlignedVC.m
//  Functions
//
//  Created by 范魁东 on 2019/11/7.
//  Copyright © 2019 FanKD. All rights reserved.
//

#import "KDLeftAlignedVC.h"
#import "KDLeftAlignedCell.h"
#import "KDLeftAlignedLayout.h"

@interface KDLeftAlignedVC ()<UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource,BBYSearchKeyWordItemDelegate>

@property (nonatomic , strong) KDBaseCollectionView *collectionView;

@property (nonatomic , strong) NSMutableArray *keyWordArr;

@end

@implementation KDLeftAlignedVC

static NSString * const identifier = @"item";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.keyWordArr = [[NSMutableArray alloc] initWithArray:@[@"艾欧尼亚",@"守望之海",@"巨神峰",@"德莱联盟",@"啦啦啦德玛西亚",@"盖伦",@"炸弹人",@"召唤师峡谷",@"布里茨"]];
    
    KDLeftAlignedLayout *layout = [[KDLeftAlignedLayout alloc] init];
    
    self.collectionView = [[KDBaseCollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    [self.collectionView registerClass:[KDLeftAlignedCell class] forCellWithReuseIdentifier:identifier];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.view addSubview:self.collectionView];
}

#pragma mark - <UICollectionViewDelegate,UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.keyWordArr.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    KDLeftAlignedCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.textField.text = self.keyWordArr[indexPath.item];
    cell.indexPath = indexPath;
    cell.delegate = self;
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *keyWord = self.keyWordArr[indexPath.item];
    
    CGSize size = [keyWord boundingRectWithSize:CGSizeMake(HUGE, HUGE)
                                        options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                     attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:18.f]} context:nil].size;
    
    CGFloat width = size.width + 10;
    
    return CGSizeMake(width, 40);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(kSCREEN_WIDTH, 40);
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}

#pragma mark - BBYSearchKeyWordItemDelegate

- (void)changeCollectionItem:(KDLeftAlignedCell *)item andIndexPath:(NSIndexPath *)indexPath {
    UITextField *textField = item.textField;
    [self.keyWordArr replaceObjectAtIndex:indexPath.item withObject:textField.text];
    [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
    
    [textField becomeFirstResponder];
}

@end
