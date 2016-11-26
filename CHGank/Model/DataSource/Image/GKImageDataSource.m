//
//  GKImageDataSource.m
//  CHGank
//
//  Created by ChiHo on 2016/10/16.
//  Copyright © 2016年 ChiHo. All rights reserved.
//

#import "GKImageDataSource.h"
#import "SDWebImageManager.h"
#import "GKData.h"

@implementation GKImageDataSource

/**
 *  设置列表数据
 *
 *  @param listData 列表数据
 */
- (void)setListData:(NSArray *)listData
{
    if ([listData count] < 10) {
        if ([self.delegate respondsToSelector:@selector(dataSourceDidLoadAllData:)]) {
            [self.delegate dataSourceDidLoadAllData:self];
        }
        self.isLoadAll = YES;
    }
    if (!self.data || ![self.data count]) {
        if ([self.delegate respondsToSelector:@selector(dataSourceDidRefreshData:)]) {
            [self.delegate dataSourceDidRefreshData:self];
        }
    }
    [self asynImageDatas:listData];
}


- (void)requestData:(BOOL)isRefresh
{
    if (isRefresh) {
        self.page = 1;
        self.data = @[];
        self.isLoadAll = NO;
    }
    self.isLoading = YES;
    __weak typeof(self) weakSelf = self;
    [GKShareNetworkMgr requestDataWithType:CHRequestTypeImagePage
                                  formData:nil
                                parameters:@{@(0) : [NSString stringWithFormat:@"%lu", (unsigned long)self.page ++]}
                                  userInfo:nil
                                  progress:nil
                                   success:^(id responseObject, NSDictionary *userInfo) {
                                       NSArray *imagePages = responseObject[@"imagePages"];
                                       [weakSelf setListData:imagePages];
                                   } failure:^(NSInteger errCode, NSString *errMsg, NSDictionary *userInfo) {
                                       if ([weakSelf.delegate respondsToSelector:@selector(dataSourceDidFailedToRequestData:)]) {
                                           [weakSelf.delegate dataSourceDidFailedToRequestData:weakSelf];
                                       }
                                   }];
}

- (void)asynImageDatas:(NSArray *)imageDatas
{
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        for (GKData *imageData in imageDatas) {
            dispatch_semaphore_wait(semaphore, INFINITY);
            [SDWebImageManager.sharedManager downloadImageWithURL:[NSURL URLWithString:imageData.url]
                                                          options:SDWebImageRetryFailed|SDWebImageHighPriority
                                                         progress:nil
                                                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                                            if (!self) {
                                                                return;
                                                            }
                                                            dispatch_main_sync_safe(^{
                                                                if (!self) {
                                                                    return;
                                                                }
                                                                if (image) {
                                                                    imageData.imageSize = image.size;
                                                                } else {
                                                                    imageData.imageSize = CGSizeMake(500, 500);
                                                                }
                                                                NSMutableArray *temp = [NSMutableArray arrayWithArray:self.data];
                                                                self.data = [temp arrayByAddingObject:imageData];
                                                                [self.delegate dataSource:self didAddDataWithStart:[self.data count] - 1 length:1];
                                                                dispatch_semaphore_signal(semaphore);
                                                            });
                                                        }];
        }
        dispatch_main_sync_safe(^{
            if ([self.delegate respondsToSelector:@selector(dataSourceDidReceiveResponse:)]) {
                [self.delegate dataSourceDidReceiveResponse:self];
            }
            self.isLoading = NO;
        });
    });
}

@end
