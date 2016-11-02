//
//  GKImageCollectionCell.h
//  CHGank
//
//  Created by ChiHo on 16/9/16.
//  Copyright © 2016年 ChiHo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GKImageCollectionCell : UICollectionViewCell

+ (CGFloat)height;

- (void)setImageWithUri:(NSString *)imageUri;

- (void)setTitleText:(NSString *)titleText;

@end
