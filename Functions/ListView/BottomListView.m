//
//  BottomListView.m
//  Functions
//
//  Created by 范魁东 on 2019/11/22.
//  Copyright © 2019 FanKD. All rights reserved.
//

#import "BottomListView.h"

#define kListViewHeitht (kSCREEN_HEIGHT-kNavBarHeight-70)
#define kListViewWidth (kSCREEN_WIDTH-30)

@interface BottomListView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , strong) UILabel *headerLabel;

@property (nonatomic , strong) UITableView *tableView;

@property (nonatomic , strong) UIPanGestureRecognizer *panGesture;

@property (nonatomic , assign) CGFloat minY;

@property (nonatomic , assign) CGFloat showY;

@end


@implementation BottomListView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor grayColor];
        self.layer.shadowColor = [UIColor grayColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(0, 3);
        self.minY = kSCREEN_HEIGHT-kListViewHeitht-10;
        
        self.headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kListViewWidth, 50)];
        self.headerLabel.backgroundColor = [UIColor redColor];
        [self addSubview:self.headerLabel];
        
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, kListViewWidth, kListViewHeitht-50) style:UITableViewStylePlain];
        self.tableView.rowHeight = 70;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.scrollEnabled = NO;
        self.tableView.bounces = NO;
        [self addSubview:self.tableView];
        
        self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureAction:)];
        [self addGestureRecognizer:self.panGesture];
        
        @weakify(self)
        [[RACObserve(self.panGesture, state) deliverOnMainThread] subscribeNext:^(id  _Nullable x) {
            @strongify(self)
            if ([x integerValue] == UIGestureRecognizerStateEnded) {
                if (self.top <= (self.minY+self.showY)/2) {
                    if (self.top == self.minY) {
                        if (self.tableView.contentSize.height > self.tableView.height) {//数据多的时候
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{//手速过快的话，单次偏移量很大，0.1秒后纠正一下
                                if (self.tableView.contentOffset.y+self.tableView.height > self.tableView.contentSize.height) {
                                    [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentSize.height-self.tableView.height) animated:NO];
                                }
                            });
                        }
                        return ;
                    }
                    
                    CGRect rect = self.frame;
                    rect.origin.y = self.minY;
                    [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:5 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                        self.frame = rect;
                    } completion:^(BOOL finished) {
                        
                    }];
                }else {
                    if (self.top == self.showY) {
                        return ;
                    }
                    CGRect rect = self.frame;
                    rect.origin.y = self.showY;
                    [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:5 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                        self.frame = rect;
                    } completion:^(BOOL finished) {
                        [self.tableView scrollToTopAnimated:YES];
                        self.tableView.scrollEnabled = NO;
                    }];
                    
                }
            }
        }];
        
    }
    return self;
}

- (void)panGestureAction:(UIPanGestureRecognizer *)panGesture {
    CGPoint point = [panGesture translationInView:[self superview]];
    
    if (self.top <= self.minY) {
        if (point.y < 0) {
            if (self.tableView.contentSize.height <= self.tableView.height) {//防止当Cell行数太少的时候，还继续往上滑动
                return;
            }
            
            if (self.tableView.contentOffset.y+self.tableView.height >= self.tableView.contentSize.height) {//防止行数稍微超出tableview高，手势没停产生误差
                self.tableView.scrollEnabled = YES;
                return;
            }
            [self.tableView setContentOffset:CGPointMake(0, -point.y) animated:NO];
            self.tableView.scrollEnabled = YES;
            return;
        }
    }
    
    if (self.top >= self.showY) {
        if (point.y > 0) {
            return;
        }
    }
    
    panGesture.view.center = CGPointMake(panGesture.view.center.x, panGesture.view.center.y + point.y);
    [panGesture setTranslation:CGPointZero inView:[self superview]];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *const identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.textLabel.text = [NSString stringWithFormat:@"第--%ld--行",(long)indexPath.row];
    
    return cell;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offSetY = scrollView.contentOffset.y;
    if (offSetY == 0) {
        scrollView.scrollEnabled = NO;
    }
}

- (void)showInView:(UIView *)view {
    if (self.isShow) {
        return;
    }
    
    [view addSubview:self];
    
    self.frame = CGRectMake(15, view.height, kListViewWidth, kListViewHeitht);
    CGRect rect = self.frame;
    rect.origin.y = view.height-300;
    
    self.showY = rect.origin.y;//记录弹出时的Y值
    [UIView animateWithDuration:0.25 animations:^{
        self.frame = rect;
    }];
    
    self.isShow = YES;
    
}

- (void)dismiss {
    if (!self.isShow) {
        return;
    }
    
    UIView *view = [self superview];
    
    CGRect rect = self.frame;
    rect.origin.y = view.height;
    [UIView animateWithDuration:0.25 animations:^{
        self.frame = rect;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
    self.isShow = NO;
}

@end
