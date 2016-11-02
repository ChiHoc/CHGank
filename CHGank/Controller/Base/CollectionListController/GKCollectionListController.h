//
//  GKCollectionListController.h
//  Quketi
//
//  Created by ChiHo on 11/26/15.
//  Copyright © 2015 YouthMBA. All rights reserved.
//

#import "GKCollectionViewController.h"
#import "GKListDataSource.h"

static NSString *const ListCellIdentifier = @"listCell";

@interface GKCollectionListController : GKCollectionViewController <GKListDataSourceDelegate, UICollectionViewDelegateFlowLayout>

/**
 *  列表cell类
 *
 *  @return 列表cell类
 */
- (Class)listCellClass;

/**
 *  列表对应节
 *
 *  @return 列表对应节
 */
- (NSInteger)listSection;

/**
 *  列表数据源
 *
 *  @return 数据源
 */
- (GKListDataSource *)dataSource;

/**
 *  列表空文字
 *
 *  @return 列表空文字
 */
- (NSString *)emptyLabelText;

/**
 *  重置Header和Footer
 */
- (void)resetHeaderFooter;

/**
 *  是否需要header
 *
 *  @return 是否需要
 */
- (BOOL)isHeaderAvailable;

/**
 *  是否需要footer
 *
 *  @return 是否需要
 */
- (BOOL)isFooterAvailable;

/**
*  列表指定行的cell
*
*  @param collectionView  列表
*  @param row             行
*
*  @return cell
*/
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView listCellAtIndex:(NSInteger)index;

/**
 *  列表cell大小
 *
 *  @param collectionView       列表
 *  @param collectionViewLayout 列表样式
 *  @param index                位置
 *
 *  @return 列表cell大小
 */
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndex:(NSInteger)index;

/**
 *  列表cell是否高亮
 *
 *  @param collectionView 列表
 *  @param index          位置
 *
 *  @return 是否高亮
 */
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndex:(NSInteger)index;

/**
 *  点击列表cell
 *
 *  @param collectionView 列表
 *  @param index          位置
 */
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndex:(NSInteger)index;

@end
