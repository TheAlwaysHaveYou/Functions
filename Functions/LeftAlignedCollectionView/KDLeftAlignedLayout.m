//
//  KDLeftAlignedLayout.m
//  Functions
//
//  Created by 范魁东 on 2019/11/7.
//  Copyright © 2019 FanKD. All rights reserved.
//

#import "KDLeftAlignedLayout.h"

@implementation KDLeftAlignedLayout

/*
 https://github.com/mokagio/UICollectionViewLeftAlignedLayout
 */

- (instancetype)init {
    self = [super init];
    if (self) {
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
        self.minimumLineSpacing = 10;
        self.minimumInteritemSpacing = 10;
        self.sectionInset = UIEdgeInsetsMake(2, 20, 2, 20);
        self.headerReferenceSize = CGSizeMake(kSCREEN_WIDTH, 40);
    }
    return self;
}

- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *originalAttributes = [super layoutAttributesForElementsInRect:rect];
    NSMutableArray *updatedAttributes = [NSMutableArray arrayWithArray:originalAttributes];
    for (UICollectionViewLayoutAttributes *attributes in originalAttributes) {
        if (!attributes.representedElementKind) {//UICollectionElementKindSectionHeader  UICollectionElementKindSectionHeader  item时为null  这样排除header和footer
            NSUInteger index = [updatedAttributes indexOfObject:attributes];
            updatedAttributes[index] = [self layoutAttributesForItemAtIndexPath:attributes.indexPath];
        }
    }
    
    return updatedAttributes;
}

- (nullable UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes* currentItemAttributes = [[super layoutAttributesForItemAtIndexPath:indexPath] copy];
    UIEdgeInsets sectionInset = self.sectionInset;
    
    BOOL isFirstItemInSection = indexPath.item == 0;
    CGFloat layoutWidth = CGRectGetWidth(self.collectionView.frame) - sectionInset.left - sectionInset.right;
    
    if (isFirstItemInSection) {
        CGRect frame = currentItemAttributes.frame;
        frame.origin.x = sectionInset.left;
        currentItemAttributes.frame = frame;
        
        return currentItemAttributes;
    }
    
    NSIndexPath* previousIndexPath = [NSIndexPath indexPathForItem:indexPath.item-1 inSection:indexPath.section];
    CGRect previousFrame = [self layoutAttributesForItemAtIndexPath:previousIndexPath].frame;
    CGFloat previousFrameRightPoint = previousFrame.origin.x + previousFrame.size.width;
    CGRect currentFrame = currentItemAttributes.frame;
    CGRect strecthedCurrentFrame = CGRectMake(sectionInset.left,
                                              currentFrame.origin.y,
                                              layoutWidth,
                                              currentFrame.size.height);
    
    BOOL isFirstItemInRow = !CGRectIntersectsRect(previousFrame, strecthedCurrentFrame);
    
    if (isFirstItemInRow) {
        CGRect frame = currentItemAttributes.frame;
        frame.origin.x = sectionInset.left;
        currentItemAttributes.frame = frame;
        
        return currentItemAttributes;
    }
    
    CGRect frame = currentItemAttributes.frame;
    frame.origin.x = previousFrameRightPoint + self.minimumInteritemSpacing;
    currentItemAttributes.frame = frame;
    return currentItemAttributes;
}

@end
