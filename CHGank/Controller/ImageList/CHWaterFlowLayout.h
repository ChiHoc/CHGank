//
//  CHWaterFlowLayout.h
//  CHGank
//
//  Created by ChiHo on 5/23/16.
//  Copyright © 2016 ChiHo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CHWaterFlowLayout;

@protocol CHWaterFlowLayoutDelegate <UICollectionViewDelegate>

- (CGFloat)flowLayout:(CHWaterFlowLayout *)flowView heightForRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@protocol CHWaterFlowLayoutDataSource <UICollectionViewDataSource>

- (NSInteger)numberOfColumnsInFlowLayout:(CHWaterFlowLayout*)flowlayout;

@end


@interface CHWaterFlowLayout : UICollectionViewFlowLayout

@property (nonatomic, weak) id<CHWaterFlowLayoutDataSource> layoutDataSource;

@property (nonatomic, weak) id<CHWaterFlowLayoutDelegate> layoutDelegate;

@end
