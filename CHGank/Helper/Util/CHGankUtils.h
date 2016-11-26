//
//  CHGankUtils.h
//  CHGank
//
//  Created by ChiHo on 2016/11/26.
//  Copyright © 2016年 ChiHo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CHGankUtils : NSObject

/**
 转换字符串到NSDate
 
 @param timeStr 字符串
 @return 时间对象
 */
+ (NSDate *)dateFromString:(NSString *)timeStr;

/**
 格式化时间到字符串
 
 @param date 时间对象
 @param style 格式
 @return 字符串
 */
+ (NSString *)formatDate:(NSDate *)date formatterStyle:(NSString *)style;

@end
