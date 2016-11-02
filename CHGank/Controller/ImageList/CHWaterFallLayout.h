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

- (CGFloat)flowLayout:(CHWaterFallLayout *)flowView heightForRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@protocol CHWaterFallLayoutDataSource <UICollectionViewDataSource>

- (NSInteger)numberOfColumnsInFlowLayout:(CHWaterFallLayout*)flowlayout;

@end


@interface CHWaterFallLayout : UICollectionViewFlowLayout

@property (nonatomic, weak) id<CHWaterFallLayoutDataSource> layoutDataSource;

@property (nonatomic, weak) id<CHWaterFallLayoutDelegate> layoutDelegate;

@end
