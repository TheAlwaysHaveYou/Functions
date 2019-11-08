//
//  KDLeftAlignedCell.m
//  Functions
//
//  Created by 范魁东 on 2019/11/7.
//  Copyright © 2019 FanKD. All rights reserved.
//

#import "KDLeftAlignedCell.h"

@implementation KDLeftAlignedCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        [self.contentView addSubview:self.textField];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChanged:) name:UITextFieldTextDidChangeNotification object:self.textField];
    }
    return self;
}

- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.font = [UIFont systemFontOfSize:18.f];
        _textField.textColor = [UIColor whiteColor];
        _textField.backgroundColor = [UIColor redColor];
    }
    return _textField;
}

- (void)textFieldChanged:(NSNotification *)notification {
    if ([self.delegate respondsToSelector:@selector(changeCollectionItem:andIndexPath:)]) {
        [self.delegate changeCollectionItem:self andIndexPath:self.indexPath];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.textField.frame = self.contentView.bounds;
}

@end
