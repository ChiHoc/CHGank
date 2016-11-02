//
//  GKPromptView.h
//  Quketi
//
//  Created by ChiHo on 14-4-22.
//  Copyright (c) 2014年 youthMBA. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PromptViewDelegate <NSObject>

- (void)onPromptViewDidPressed;

@end

@interface GKPromptView : UIView

@property (nonatomic, weak) id<PromptViewDelegate>delegate;

+ (CGFloat)height;

@end
