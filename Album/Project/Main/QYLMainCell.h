//
//  QYLMainViewCell.h
//  Album
//
//  Created by Marshal on 2017/10/11.
//  Copyright © 2017年 Marshal. All rights reserved.
//  主界面的流式布局cell

#import <UIKit/UIKit.h>

@class QYLKindModel;

@interface QYLMainCell : UICollectionViewCell

@property (nonatomic, copy) void (^removeBlock)();
@property (nonatomic, copy) void (^selectBlock)();

- (void)updateCellWithKindModel:(QYLKindModel *)kindModel isEidt:(BOOL)isEidt;

@end
