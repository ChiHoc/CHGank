//
//  GKData.h
//  CHGank
//
//  Created by ChiHo on 14-6-30.
//  Copyright (c) 2014 YouthMBA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GKData : NSObject <NSCoding, NSCopying>

@property (nonatomic, copy) NSString *dataId;
@property (nonatomic, copy) NSString *createdTime;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *publishedTime;
@property (nonatomic, copy) NSString *source;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *used;
@property (nonatomic, copy) NSString *who;
@property (nonatomic, assign) CGSize imageSize;

/**
 *  根据字典类型数据获取对象
 *
 *  @param dict 字典类型数据
 *
 *  @return 对象
 */
+ (id)modelObjectWithDictionary:(NSDictionary *)dict;

/**
 *  根据字典类型数据初始化对象
 *
 *  @param dict 字典类型数据
 *
 *  @return 初始化对象
 */
- (id)initWithDictionary:(NSDictionary *)dict;

/**
 *  获取对象的字典类型数据
 *
 *  @return 字典类型数据
 */
- (NSDictionary *)dictionaryRepresentation;

@end
