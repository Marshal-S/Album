//
//  QYLOperateCell.m
//  Album
//
//  Created by Marshal on 2017/10/13.
//  Copyright © 2017年 Marshal. All rights reserved.
//

#import "QYLOperateCell.h"

@interface QYLOperateCell ()
{
    UIButton *_btnKind;
}

@end

@implementation QYLOperateCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initContentView];
    }
    return self;
}

- (void)initContentView {
    self.backgroundColor = [UIColor blackColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _btnKind = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/4, self.bounds.size.height)];
    [_btnKind setTitleColor:[UIColor lightTextColor] forState:UIControlStateNormal];
    _btnKind.titleLabel.font = [UIFont boldSystemFontOfSize:12];
    _btnKind.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_btnKind addTarget:self action:@selector(onClickToSelect:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_btnKind];
}

- (void)updateCellWithKindName:(NSString *)kindName {
    [_btnKind setTitle:kindName forState:UIControlStateNormal];
}

- (void)onClickToSelect:(UIButton *)sender {
    if (_selectTypeBlock) _selectTypeBlock();
}

@end
