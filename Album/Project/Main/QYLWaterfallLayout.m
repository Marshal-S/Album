//
//  QYLWaterfallLayout.m
//  CollectionView
//
//  Created by Marshal on 2017/10/16.
//  Copyright © 2017年 Marshal. All rights reserved.
//

#import "QYLWaterfallLayout.h"

static CGFloat columnHeight[3] = {10, 10, 10};//列数组,最多三组

static UIEdgeInsets defaultEdgeInsets = {15, 15, 15 ,15};//默认的比编剧

@interface QYLWaterfallLayout ()

@property (nonatomic, strong) NSMutableArray *attrAry;//布局属性数组

@end

@implementation QYLWaterfallLayout

- (instancetype)init
{
    self = [super init];
    if (self) {
        _attrAry = [NSMutableArray array];
    }
    return self;
}

- (void)prepareLayout {
    [super prepareLayout];
    
    //开始布局或者重新布局要清空所有数组
    [_attrAry removeAllObjects];
    
    NSAssert(_columCount < 4 , @"列数不能大于3");
    //初始化基本数据
    _edgInsets = UIEdgeInsetsEqualToEdgeInsets(_edgInsets, UIEdgeInsetsZero) ? defaultEdgeInsets : _edgInsets; //赋值边距
    columnHeight[0] = columnHeight[1] = columnHeight[2] = _edgInsets.top;//赋值做最多三组,刷新布局会走这个方法,所以会自动清空高度数组
    _columCount = _columCount ? _columCount : 2; //赋值列数
    _columnMargin = _columnMargin ? _columnMargin : 10; //赋值列间距
    _rowMargin = _rowMargin ? _rowMargin : 10;  //赋值行间距
    
    //开始正式布局属性
    NSInteger count = [self.collectionView numberOfItemsInSection:0];//获取行数
    for (NSInteger idx = 0; idx < count; idx++) {
        //创建cell属性
        UICollectionViewLayoutAttributes *attr = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:idx inSection:0]];
        [_attrAry addObject:attr];
    }
    
}

#pragma mark --创建并计算cell frame属性方法
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    //获取高度最小的那列
    NSInteger minColumn = 0;//先默认即将插入属性到第一列
    CGFloat minHeight = columnHeight[0];//先默认第一列为最短列
    for (NSInteger idx = 1; idx < _columCount; idx++) {
        if (columnHeight[idx] < minHeight) {
            minHeight = columnHeight[idx];
            minColumn = idx;
        }
    }
    
    CGFloat width = (self.collectionView.frame.size.width - _edgInsets.left - _edgInsets.right - _columnMargin*(_columCount-1))/2;
    CGFloat height = [self.delegate waterfallLayout:self indexPath:indexPath];
    CGFloat x = _edgInsets.left + minColumn*(width + _columnMargin);
    CGFloat y = minHeight;
    if (y != _edgInsets.top) {
        y += _rowMargin;
    }
    attr.frame = CGRectMake(x, y, width, height);
    columnHeight[minColumn] = y+height;
    return attr;
}

#pragma mark --系统获取属性数组方法
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    return _attrAry;
}

#pragma mark --系统获取可滑动大小方法，即设置contentSize
- (CGSize)collectionViewContentSize {
    CGFloat maxHeight = columnHeight[0];
    for (NSInteger idx = 1; idx < _columCount; idx++) {
        if (columnHeight[idx] > maxHeight) {
            maxHeight = columnHeight[idx];
        }
    }
    return CGSizeMake(0, maxHeight);
}


@end
