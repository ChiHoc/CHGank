//
//  GKImagesListCollectionViewController.m
//  CHWaterFlow
//
//  Created by ChiHo on 5/22/16.
//  Copyright © 2016 ChiHo. All rights reserved.
//

#import "GKImagesListCollectionViewController.h"
#import "CHWaterFallLayout.h"
#import "GKImageDataSource.h"
#import "GKImageCollectionCell.h"
#import "GKData.h"

@interface GKImagesListCollectionViewController () <CHWaterFallLayoutDataSource, CHWaterFallLayoutDelegate>

@property (nonatomic, strong) GKImageDataSource *dataSource;

@property (nonatomic, strong) NSMutableArray *heightAry;

@property (strong, nonatomic) IBOutlet CHWaterFallLayout *waterFallLayout;

@end

@implementation GKImagesListCollectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.heightAry = [NSMutableArray array];
    
    ((CHWaterFallLayout *)self.collectionViewLayout).layoutDataSource = self;
    ((CHWaterFallLayout *)self.collectionViewLayout).layoutDelegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (GKListDataSource *)dataSource
{
    if (!_dataSource) {
        _dataSource = [[GKImageDataSource alloc] init];
        [_dataSource setDelegate:self];
    }
    return _dataSource;
}

- (Class)listCellClass
{
    return [GKImageCollectionCell class];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.dataSource.data count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.dataSource.data count]) {
        GKImageCollectionCell *cell = (GKImageCollectionCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
        GKData *data = self.dataSource.data[indexPath.row];
        [cell setImageWithUri:data.url];
        [cell setTitleText:data.desc];
        return cell;
    }
    return [UICollectionViewCell new];
}

#pragma mark - CHWaterFallLayoutDelegate

- (CGFloat)flowLayout:(CHWaterFallLayout *)flowView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if (indexPath.row >= [self.heightAry count]) {
        GKData *data = self.dataSource.data[indexPath.row];
        [self.heightAry addObject:@(flowView.itemSize.width * data.imageSize.height / data.imageSize.width)];
    }
    return [self.heightAry[indexPath.row] floatValue];
}

- (NSInteger)numberOfColumnsInFlowLayout:(CHWaterFallLayout*)flowlayout
{
    return 2;
}

#pragma mark - GKListDataSourceDelegate

- (void)dataSourceDidReceiveResponse:(GKListDataSource *)dataSource
{
    [super dataSourceDidReceiveResponse:dataSource];
    if (dataSource.isLoadAll) {
        [self.collectionView.mj_footer setHidden:YES];
    }
}

- (void)dataSourceDidFailedToRequestData:(GKListDataSource *)dataSource
{
    [super dataSourceDidFailedToRequestData:dataSource];
    [SVProgressHUD showErrorWithStatus:@"Request Failed"];
}

@end
