//
//  GKImageCollectionCell.m
//  CHGank
//
//  Created by ChiHo on 16/9/16.
//  Copyright © 2016年 ChiHo. All rights reserved.
//

#import "GKImageCollectionCell.h"
#import <AVFoundation/AVFoundation.h>

@interface GKImageCollectionCell ()

@property (strong, nonatomic) IBOutlet UIImageView *imageView;

@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation GKImageCollectionCell

+ (CGFloat)height
{
    return 200.f;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self.layer setBorderWidth:1];
    [self.layer setBorderColor:[UIColor colorWithRed:0xd3/255.f
                                               green:0xcc/255.f
                                                blue:0xc6/255.f
                                               alpha:1].CGColor];
}

- (void)setImageWithUri:(NSString *)imageUri;
{
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageUri]];
}

- (void)setTitleText:(NSString *)titleText
{
    [self.titleLabel setText:titleText];
}

@end
