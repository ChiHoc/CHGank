//
//  CHWaterFallLayout.h
//  CHGank
//
//  Created by ChiHo on 5/23/16.
//  Copyright © 2016 ChiHo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CHWaterFallLayout;

@protocol CHWaterFallLayoutDelegate <UICollectionViewDelegate>

/**
 指定位置cell高度

 @param flowView flowView
 @param indexPath 位置
 @return 高度
 */
- (CGFloat)flowLayout:(CHWaterFallLayout *)flowlayout heightForRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@protocol CHWaterFallLayoutDataSource <UICollectionViewDataSource>


/**
 瀑布流行数
 
 @param flowlayout flowlayout
 @return 瀑布流行数
 */
- (NSInteger)numberOfColumnsInFlowLayout:(CHWaterFallLayout *)flowlayout;

@end


@interface CHWaterFallLayout : UICollectionViewFlowLayout

@property (nonatomic, weak) id<CHWaterFallLayoutDataSource> layoutDataSource;

@property (nonatomic, weak) id<CHWaterFallLayoutDelegate> layoutDelegate;

@end
