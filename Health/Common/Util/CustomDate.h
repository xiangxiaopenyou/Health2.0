//
//  CustomDate.h
//
//  Created by cheng on 13-11-11.
//  Copyright (c) 2013年 huangcheng All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomDate : NSObject

+ (NSInteger)getDayToDate:(NSDate*)date;

+ (NSString*)getTimeString:(NSDate*)date;

//string转date
+ (NSDate*)getDate:(NSString*)dateString;
+ (NSDate*)getDate2:(NSString*)dateString;
+ (NSDate*)getDateTime:(NSString*)dateString;
+ (NSDate*)getDateTimeHHMMSS:(NSString*)dateString;

//date转成string  yyyymmdd
+ (NSString*)getStringFromDate:(NSDate*)date;
+ (NSString*)getDateString:(NSDate *)date;
+ (NSString*)getDateString2:(NSDate*)date;
+ (NSString*)getFileNameString:(NSDate *)date;

//格式YYYY-MM-DD
+ (NSDate*)getBirthdayDate:(NSString*)string;
//返回格式YYYY-MM-DD
+ (NSString*)getBirthDayString:(NSDate*)date;
//两个时间的比较
+ (NSComparisonResult)compare:(NSDate *)date other:(NSDate *)otherDate;

+ (NSString*)compare:(NSString*)string otherString:(NSString*)otherString;

+ (NSString*)getDateStringToDete:(NSString*)date;

+ (NSInteger)getTimeDistance:(NSString*)beginTime toTime:(NSString*)endTime;

+ (NSDate *)getTimeDate:(NSString*)timeString;
+ (NSDate *)getTimeToDate:(NSString*)timeString;

+ (NSString *)compareDate:(NSDate *)date;

+ (NSInteger)getAgeToDate:(NSString*)dateString;
+ (BOOL)equalToDate:(NSDate*)date;
@end
