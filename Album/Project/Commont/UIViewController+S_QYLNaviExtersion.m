//
//  UIViewController+S_QYLNaviExtersion.m
//  PersonBike
//
//  Created by Marshal on 2017/7/10.
//  Copyright © 2017年 Marshal. All rights reserved.
//

#import "UIViewController+S_QYLNaviExtersion.h"
#import "UIView+S_Extend.h"

CGFloat const animationDuration = 0.5;

@implementation UIViewController (S_QYLNaviExtersion)

- (void)s_setDefaultBack {
    UIButton *left = [UIButton buttonWithType:UIButtonTypeCustom];
    left.frame = CGRectMake(15, 0, 44, 44);
    [left setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [left setShowsTouchWhenHighlighted:YES];
    [left addTarget:self action:@selector(s_back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithCustomView:left];
    self.navigationItem.leftBarButtonItem = back;
}

- (void)s_setRightWithImage:(UIImage *)image title:(NSString *)title size:(CGFloat)titleSize  titleColor:(UIColor *)color action:(SEL)sel {
    UIButton *right = [UIButton buttonWithType:UIButtonTypeCustom];
    if (image) {
        right.frame = CGRectMake(0, 0, 44, 44);
        [right setImage:image forState:UIControlStateNormal];
        right.imageEdgeInsets = UIEdgeInsetsMake(12.5, 18.5, 12.5, 5.5);
        right.adjustsImageWhenHighlighted = YES;
    }else if (title) {
        right.frame = CGRectMake(0, 2, 80, 20);
        [right setTitle:title forState:UIControlStateNormal];
        right.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        [right setTitleColor:color forState:UIControlStateNormal];
        [right setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        right.titleLabel.font = [UIFont boldSystemFontOfSize:titleSize>0?titleSize:16];
    }
    [right addTarget:self action:sel forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:right];
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.rightBarButtonItem = rightItem;
}

//默认返回动画
- (void)s_back {
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)s_push:(UIViewController *)vc animated:(BOOL)animated {
    [self.navigationController pushViewController:vc animated:animated];
}


@end
