//
//  KDLeftAlignedCell.h
//  Functions
//
//  Created by 范魁东 on 2019/11/7.
//  Copyright © 2019 FanKD. All rights reserved.
//

#import "KDBaseCollectionViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@class KDLeftAlignedCell;
@protocol BBYSearchKeyWordItemDelegate <NSObject>

- (void)changeCollectionItem:(KDLeftAlignedCell *)item andIndexPath:(NSIndexPath *)indexPath;

@end

@interface KDLeftAlignedCell : KDBaseCollectionViewCell

@property (nonatomic , strong) UITextField *textField;

@property (nonatomic , strong) NSIndexPath *indexPath;

@property (nonatomic , weak) id <BBYSearchKeyWordItemDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
