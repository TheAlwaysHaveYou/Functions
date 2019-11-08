//
//  KDBaseTableViewCell.m
//  Functions
//
//  Created by 范魁东 on 2019/11/7.
//  Copyright © 2019 FanKD. All rights reserved.
//

#import "KDBaseTableViewCell.h"

@implementation KDBaseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

@end
