//
//  GKListDataSource.m
//  Quketi
//
//  Created by ChiHo on 3/29/16.
//  Copyright © 2016 YouthMBA. All rights reserved.
//

#import "GKListDataSource.h"
#import "GKData.h"

@interface GKListDataSource ()

@property (nonatomic, assign) NSUInteger page;

@end

@implementation GKListDataSource

#pragma mark - 初始化

- (id)init
{
    self = [super init];
    if (self) {
        self.page = 1;
    }
    return self;
}

#pragma mark - 属性方法

- (NSArray *)data
{
    if (!_data) {
        _data = @[];
    }
    return _data;
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

/**
 *  设置列表数据
 *
 *  @param listData 列表数据
 */
- (void)setListData:(NSArray *)listData
{
    if ( [listData count] < 10) {
        if ([self.delegate respondsToSelector:@selector(dataSourceDidLoadAllData:)]) {
            [self.delegate dataSourceDidLoadAllData:self];
        }
        self.isLoadAll = YES;
    }
    if (!self.data || ![self.data count]) {
        self.data = listData;
        if ([self.delegate respondsToSelector:@selector(dataSourceDidRefreshData:)]) {
            [self.delegate dataSourceDidRefreshData:self];
        }
    } else {
        NSMutableArray *temp = [NSMutableArray arrayWithArray:self.data];
        self.data = [temp arrayByAddingObjectsFromArray:listData];
        if ([self.delegate respondsToSelector:@selector(dataSource:didAddDataWithStart:length:)]) {
            [self.delegate dataSource:self didAddDataWithStart:[temp count] length:[listData count]];
        }
    }
}

@end
