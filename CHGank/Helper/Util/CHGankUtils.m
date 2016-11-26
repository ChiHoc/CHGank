//
//  CHGankUtils.m
//  CHGank
//
//  Created by ChiHo on 2016/11/26.
//  Copyright © 2016年 ChiHo. All rights reserved.
//

#import "CHGankUtils.h"

@implementation CHGankUtils

+ (NSDate *)dateFromString:(NSString *)timeStr
{
    timeStr = [timeStr stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    timeStr = [timeStr stringByReplacingOccurrencesOfString:@"Z" withString:@""];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss.SSS"];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    
    return [formatter dateFromString:timeStr];
}

+ (NSString *)formatDate:(NSDate *)date formatterStyle:(NSString *)style
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    [formatter setDateFormat:style];
    
    return [formatter stringFromDate:date];
}

@end
