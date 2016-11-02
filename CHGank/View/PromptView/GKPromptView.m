//
//  GKPromptView.m
//  Quketi
//
//  Created by ChiHo on 14-4-22.
//  Copyright (c) 2014年 youthMBA. All rights reserved.
//

#import "GKPromptView.h"

@implementation GKPromptView

+ (CGFloat)height
{
    return 170.f;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIButton *iconBtn = [[UIButton alloc] init];
        [iconBtn setFrame:CGRectMake((CGRectWidth(frame)-240/2)/2, 5, 240/2, 240/2)];
        UIImage *image = [UIImage imageNamed:@"ic_failure"];
        [iconBtn setImage:image
                 forState:UIControlStateNormal];
        [iconBtn addTarget:self
                    action:@selector(onPromptViewDidPressed)
          forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:iconBtn];
        
        UIButton *prompt = [UIButton buttonWithType:UIButtonTypeCustom];
        [prompt setTitle:LS(@"加载失败，请点击重新加载")
                forState:UIControlStateNormal];
        [prompt setFrame:CGRectMake(0, 240/2+15, CGRectWidth(frame), 20)];
        [prompt setTitleColor:[UIColor blackColor]
                     forState:UIControlStateNormal];
        [prompt.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [prompt addTarget:self
                   action:@selector(onPromptViewDidPressed)
         forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:prompt];
        
    }
    return self;
}

- (void)onPromptViewDidPressed
{
    if ([self.delegate respondsToSelector:@selector(onPromptViewDidPressed)]) {
        [self.delegate onPromptViewDidPressed];
    }
}

@end
