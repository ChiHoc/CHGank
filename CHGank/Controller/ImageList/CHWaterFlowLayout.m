//
//  CHWaterFlowLayout.m
//  CHGank
//
//  Created by ChiHo on 5/23/16.
//  Copyright © 2016 ChiHo. All rights reserved.
//

#import "CHWaterFlowLayout.h"

static const CGFloat CHRowMargin = 10;

static const CGFloat CHColumnMargin = 10;

static const UIEdgeInsets CHDefaultInsets = {10, 10, 10, 10};


@interface CHWaterFlowLayout()

@property (nonatomic, strong) NSMutableArray *columnMaxYs;

@property (nonatomic, strong) NSMutableArray *attrsArray;

@end

@implementation CHWaterFlowLayout

#pragma mark - 懒加载

- (NSMutableArray *)columnMaxYs
{
    if (!_columnMaxYs) {
        _columnMaxYs = [[NSMutableArray alloc] init];
        [_columnMaxYs sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            NSComparisonResult result = [obj1 compare:obj2];
            return result == NSOrderedDescending;
        }];
    }
    return _columnMaxYs;
}

- (NSMutableArray *)attrsArray
{
    if (!_attrsArray) {
        _attrsArray = [[NSMutableArray alloc] init];
    }
    return _attrsArray;
}

#pragma mark - 实现内部的方法

/**
 * 决定了collectionView的contentSize
 */
- (CGSize)collectionViewContentSize
{
    // 找出最长那一列的最大Y值
    CGFloat destMaxY = [self.columnMaxYs[0] doubleValue];
    for (NSUInteger i = 1; i<self.columnMaxYs.count; i++) {
        // 取出第i列的最大Y值
        CGFloat columnMaxY = [self.columnMaxYs[i] doubleValue];
        
        // 找出数组中的最大值
        if (destMaxY < columnMaxY) {
            destMaxY = columnMaxY;
        }
    }
    return CGSizeMake(0, destMaxY + CHDefaultInsets.bottom);
}

- (void)prepareLayout
{
    [super prepareLayout];
    
    // 重置每一列的最大Y值
    [self.columnMaxYs removeAllObjects];
    NSInteger numberOfColumns = [self.layoutDataSource numberOfColumnsInFlowLayout:self];
    for (NSUInteger i = 0; i < numberOfColumns; i ++) {
        [self.columnMaxYs addObject:@(CHDefaultInsets.top)];
    }
    
    // 计算所有cell的布局属性
    [self.attrsArray removeAllObjects];
    NSUInteger count = [self.collectionView numberOfItemsInSection:0];
    for (NSUInteger i = 0; i < count; i ++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i
                                                     inSection:0];
        UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:indexPath];
        [self.attrsArray addObject:attrs];
    }
}

/**
 * 说明所有元素（比如cell、补充控件、装饰控件）的布局属性
 */
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return self.attrsArray;
}

/**
 * 说明cell的布局属性
 */
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    /** 计算indexPath位置cell的布局属性 */
    
    NSInteger numberOfColumns = [self.layoutDataSource numberOfColumnsInFlowLayout:self];
    // 水平方向上的总间距
    CGFloat xMargin = CHDefaultInsets.left + CHDefaultInsets.right + (numberOfColumns - 1) * CHColumnMargin;
    // cell的宽度
    CGFloat w = (CGRectGetWidth(self.collectionView.frame) - xMargin) / numberOfColumns;
    // cell的高度，测试数据，随机数
    CGFloat h = 100 + arc4random_uniform(150);
    
    // 找出最短那一列的 列号 和 最大Y值
    CGFloat destMaxY = [self.columnMaxYs[0] doubleValue];
    NSUInteger destColumn = 0;
    for (NSUInteger i = 1; i<self.columnMaxYs.count; i++) {
        // 取出第i列的最大Y值
        CGFloat columnMaxY = [self.columnMaxYs[i] doubleValue];
        
        // 找出数组中的最小值
        if (destMaxY > columnMaxY) {
            destMaxY = columnMaxY;
            destColumn = i;
        }
    }
    
    // cell的x值
    CGFloat x = CHDefaultInsets.left + destColumn * (w + CHColumnMargin);
    // cell的y值
    CGFloat y = destMaxY + CHRowMargin;
    // cell的frame
    attrs.frame = CGRectMake(x, y, w, h);
    
    // 更新数组中的最大Y值
    self.columnMaxYs[destColumn] = @(CGRectGetMaxY(attrs.frame));
    
    return attrs;
}

@end
