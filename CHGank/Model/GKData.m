//
//  GKData.m
//  CHGank
//
//  Created by ChiHo on 14-6-30.
//  Copyright (c) 2014 YouthMBA. All rights reserved.
//

#import "GKData.h"

NSString *const kGKDataId = @"_id";
NSString *const kGKDataCreatedTime = @"createdAt";
NSString *const kGKDataDesc = @"desc";
NSString *const kGKDataPublishedTime = @"publishedAt";
NSString *const kGKDataSource = @"source";
NSString *const kGKDataType = @"type";
NSString *const kGKDataUrl = @"url";
NSString *const kGKDataUsed = @"used";
NSString *const kGKDataWho = @"who";
NSString *const kGKDataImageSize = @"imageSize";

@interface GKData ()

@end

@implementation GKData

/**
 *  根据字典类型数据获取对象
 *
 *  @param dict 字典类型数据
 *
 *  @return 对象
 */
+ (id)modelObjectWithDictionary:(NSDictionary *)dict
{
    return [[self alloc] initWithDictionary:dict];
}

/**
 *  根据字典类型数据初始化对象
 *
 *  @param dict 字典类型数据
 *
 *  @return 初始化对象
 */
- (id)initWithDictionary:(NSDictionary *)dict
{
    self = (dict && [dict isKindOfClass:[NSDictionary class]]) ? [super init] : nil;
    
    // This check serves to make sure that a non-NSDictionary object
    // passed into the model class doesn't break the parsing.
    if(self && [dict count]) {
        self.dataId = [dict objectOrNilForKey:kGKDataId];
        self.createdTime = [dict objectOrNilForKey:kGKDataCreatedTime];
        self.desc = [dict objectOrNilForKey:kGKDataDesc];
        self.publishedTime = [dict objectOrNilForKey:kGKDataPublishedTime];
        self.source = [dict objectOrNilForKey:kGKDataSource];
        self.type = [dict objectOrNilForKey:kGKDataType];
        self.url = [dict objectOrNilForKey:kGKDataUrl];
        self.used = [dict objectOrNilForKey:kGKDataUsed];
        self.who = [dict objectOrNilForKey:kGKDataWho];
    }
    
    return self;
    
}

/**
 *  获取对象的字典类型数据
 *
 *  @return 字典类型数据
 */
- (NSDictionary *)dictionaryRepresentation
{
    NSMutableDictionary *mutableDict = [NSMutableDictionary dictionary];
    [mutableDict setValue:self.dataId forKey:kGKDataId];
    [mutableDict setValue:self.createdTime forKey:kGKDataCreatedTime];
    [mutableDict setValue:self.desc forKey:kGKDataDesc];
    [mutableDict setValue:self.publishedTime forKey:kGKDataPublishedTime];
    [mutableDict setValue:self.source forKey:kGKDataSource];
    [mutableDict setValue:self.type forKey:kGKDataType];
    [mutableDict setValue:self.url forKey:kGKDataUrl];
    [mutableDict setValue:self.used forKey:kGKDataUsed];
    [mutableDict setValue:self.who forKey:kGKDataWho];
    [mutableDict setValue:NSStringFromCGSize(self.imageSize) forKey:kGKDataImageSize];
    return [NSDictionary dictionaryWithDictionary:mutableDict];
}

/**
 *  获取对象描述
 *
 *  @return 对象描述
 */
- (NSString *)description
{
    return [NSString stringWithFormat:@"%@", [self dictionaryRepresentation]];
}

#pragma mark - NSCoding Methods

/**
 *  使用解码数据初始化
 *
 *  @param aDecoder 解码数据
 *
 *  @return 初始化数据
 */
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    self.dataId = [aDecoder decodeObjectForKey:kGKDataId];
    self.createdTime = [aDecoder decodeObjectForKey:kGKDataCreatedTime];
    self.desc = [aDecoder decodeObjectForKey:kGKDataDesc];
    self.publishedTime = [aDecoder decodeObjectForKey:kGKDataPublishedTime];
    self.source = [aDecoder decodeObjectForKey:kGKDataSource];
    self.type = [aDecoder decodeObjectForKey:kGKDataType];
    self.url = [aDecoder decodeObjectForKey:kGKDataUrl];
    self.used = [aDecoder decodeObjectForKey:kGKDataUsed];
    self.who = [aDecoder decodeObjectForKey:kGKDataWho];
    NSValue *sizeValue = [aDecoder decodeObjectForKey:kGKDataImageSize];
    [sizeValue getValue:&_imageSize];
    return self;
}

/**
 *  编码
 *
 *  @param aCoder NSCoder
 */
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:_dataId forKey:kGKDataId];
    [aCoder encodeObject:_createdTime forKey:kGKDataCreatedTime];
    [aCoder encodeObject:_desc forKey:kGKDataDesc];
    [aCoder encodeObject:_publishedTime forKey:kGKDataPublishedTime];
    [aCoder encodeObject:_source forKey:kGKDataSource];
    [aCoder encodeObject:_type forKey:kGKDataType];
    [aCoder encodeObject:_url forKey:kGKDataUrl];
    [aCoder encodeObject:_used forKey:kGKDataUsed];
    [aCoder encodeObject:_who forKey:kGKDataWho];
    [aCoder encodeObject:_who forKey:kGKDataWho];
    NSValue *sizeValue = [NSValue value:&_imageSize withObjCType:@encode(CGSize)];
    [aCoder encodeObject:sizeValue forKey:kGKDataImageSize];
}

/**
 *  深复制
 *
 *  @param zone 内存区域
 *
 *  @return 复制对象
 */
- (id)copyWithZone:(NSZone *)zone
{
    GKData *copy = [[GKData alloc] init];
    
    if (copy) {
        copy.dataId = [self.dataId copyWithZone:zone];
        copy.createdTime = [self.createdTime copyWithZone:zone];
        copy.desc = [self.desc copyWithZone:zone];
        copy.publishedTime = [self.publishedTime copyWithZone:zone];
        copy.source = [self.source copyWithZone:zone];
        copy.type = [self.type copyWithZone:zone];
        copy.url = [self.url copyWithZone:zone];
        copy.used = [self.createdTime copyWithZone:zone];
        copy.who = [self.who copyWithZone:zone];
        copy.imageSize = self.imageSize;
    }
    
    return copy;
}


@end
