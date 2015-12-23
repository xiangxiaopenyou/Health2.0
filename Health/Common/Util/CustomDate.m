//
//  CustomDate.m
//
//  Created by cheng on 13-11-11.
//  Copyright (c) 2013年 huangcheng All rights reserved.
//

#import "CustomDate.h"

@implementation CustomDate

+ (NSInteger)getDayToDate:(NSDate *)date
{
    if (date == nil) {
        return 0;
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [formatter stringFromDate:date];
    NSDate *date1 = [formatter dateFromString:dateString];
    
    NSString *dateString2 = [formatter stringFromDate:[NSDate date]];
    NSDate *date2 = [formatter dateFromString:dateString2];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    unsigned int unitFlags = NSDayCalendarUnit;
    NSDateComponents *comps = [gregorian components:unitFlags fromDate:date1  toDate:date2  options:0];
    NSInteger days = [comps day];
    
    return days;
}
+ (NSInteger)getAgeToDate:(NSString*)dateString{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [formatter dateFromString:dateString];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    unsigned int unitFlags = NSYearCalendarUnit;
    NSDateComponents *comps = [gregorian components:unitFlags fromDate:date  toDate:[NSDate date]  options:0];
    NSInteger year = [comps year];
    return year;
}

+ (NSString*)getTimeString:(NSDate*)date
{
    NSLog(@"date %@",date);
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"HH:mm"];
    NSString *dateString = [formatter stringFromDate:date];
    NSLog(@"timeString %@",dateString);
    return dateString;
}

+ (NSDate*)getDate:(NSString*)dateString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:SS"];
    NSDate *date = [formatter dateFromString:dateString];
    return date;
}
+ (NSDate*)getDate2:(NSString *)dateString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
    NSDate *date = [formatter dateFromString:dateString];
    return date;
}
+ (NSDate*)getDateTime:(NSString *)dateString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *date = [formatter dateFromString:dateString];
    return date;
}
+ (NSDate*)getDateTimeHHMMSS:(NSString*)dateString{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:SS"];
    NSDate *date = [formatter dateFromString:dateString];
    return date;
}
+ (NSString*)getFileNameString:(NSDate *)date{
    
    NSLog(@"date %@",date);
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyyMMddHHmmSS"];
    NSString *dateString = [formatter stringFromDate:date];
    NSLog(@"datestring %@",dateString);
    return dateString;
}

+ (NSDate*)getBirthdayDate:(NSString*)string{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [formatter dateFromString:string];
    return date;
}
+ (NSString*)getBirthDayString:(NSDate*)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [formatter stringFromDate:date];
    return dateString;
}
+ (NSString*)getDateString:(NSDate *)date
{
    NSLog(@"date %@",date);
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:SS"];
    NSString *dateString = [formatter stringFromDate:date];
    NSLog(@"datestring %@",dateString);
    return dateString;
}
+(NSString*)getDateString2:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
    NSString *dateString = [formatter stringFromDate:date];
    return dateString;
}
+ (NSString*)getStringFromDate:(NSDate *)date
{
    //NSLog(@"date %@",date);
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *dateString = [formatter stringFromDate:date];
    //NSLog(@"datestring %@",dateString);
    return dateString;
}


+ (NSComparisonResult)compare:(NSDate *)date other:(NSDate *)otherDate
{
    //某天与今天比较
    switch ([date compare:otherDate]) {
        case NSOrderedSame:
            NSLog(@"same");
            return NSOrderedSame;
            break;
        case NSOrderedAscending:
            NSLog(@"earlier");
            return NSOrderedAscending;
            break;
        case NSOrderedDescending:
            NSLog(@"later");
            return NSOrderedDescending;
            break;
        default:
            break;
    }
}

+ (NSString*)compare:(NSString *)string otherString:(NSString *)otherString
{
    NSDateFormatter *dateFormatter= [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *date = [dateFormatter dateFromString:string];
    NSDate *otherDate = [dateFormatter dateFromString:otherString];
    NSTimeInterval late1 = [date timeIntervalSince1970];
    NSTimeInterval late2 = [otherDate timeIntervalSince1970];
    if (late1 == late2) {
        return @"same";
    }
    else if (late1 < late2){
        return @"earlier";
    }
    else{
        return @"later";
    }
    
}

+ (NSString*)getDateStringToDete:(NSString*)string{
    
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc]init];
    [formatter1 setDateFormat:@"yyyy-MM-dd"];
    NSDate *date = [formatter1 dateFromString:[string substringToIndex:10]];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    NSInteger index = [self getDayToDate:date];
    if (index == 0) {
        NSString *dateString = [string substringWithRange:NSMakeRange(11, 5)];
        return dateString;
    }else if (index == 1){
        NSString *dateString = [string substringWithRange:NSMakeRange(11, 5)];
        
        return [NSString stringWithFormat:@"昨天 %@",dateString];
    }else{
        NSString *dateString = [string substringWithRange:NSMakeRange(5, 11)];
        return dateString;
    }
    
}

+ (NSInteger)getTimeDistance:(NSString*)beginTime toTime:(NSString*)endTime
{
    NSLog(@"begintime endtime %@ %@",beginTime,endTime);
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc]init];
    [formatter1 setDateFormat:@"HH:mm"];
    NSDate *date1 = [formatter1 dateFromString:beginTime];
    NSDate *date2 = [formatter1 dateFromString:endTime];
    NSTimeInterval atimer = [date2 timeIntervalSinceDate:date1];
    int minute = (int)atimer/60;
    return minute;

}

+ (NSDate *)getTimeDate:(NSString *)timeString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:SS"];
    NSDate *date  = [dateFormatter dateFromString:timeString];
    return date;
}

+ (NSDate *)getTimeToDate:(NSString *)timeString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *date  = [dateFormatter dateFromString:timeString];
    return date;
}

+ (NSString *)compareDate:(NSDate *)date{
    
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    NSDate *today = [[NSDate alloc] init];
    NSDate *tomorrow, *yesterday, *aftertomorrow;
    
    tomorrow = [today dateByAddingTimeInterval: secondsPerDay];
    yesterday = [today dateByAddingTimeInterval: -secondsPerDay];
    aftertomorrow = [tomorrow dateByAddingTimeInterval:secondsPerDay];
    
    // 10 first characters of description is the calendar date:
    NSString * todayString = [[today description] substringToIndex:10];
    NSString * yesterdayString = [[yesterday description] substringToIndex:10];
    NSString * tomorrowString = [[tomorrow description] substringToIndex:10];
    NSString *afterTomorrowString = [[aftertomorrow description] substringToIndex:10];
    NSString *dateS = [self getDateString:date];
    NSString * dateString = [dateS substringToIndex:10];
    
    if ([dateString isEqualToString:todayString])
    {
        return @"今天";
    } else if ([dateString isEqualToString:yesterdayString])
    {
        return @"昨天";
    }else if ([dateString isEqualToString:tomorrowString])
    {
        return @"明天";
    }
    else if([dateString isEqualToString:afterTomorrowString])
    {
        return @"后天";
    }
    else{
        return dateString;
    }
}

+ (BOOL)equalToDate:(NSDate*)date{
    NSDate *nowDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *nowDateString  = [dateFormatter stringFromDate:nowDate];
    
    NSString *dateString = [dateFormatter stringFromDate:date];
    if ([dateString isEqualToString:nowDateString]) {
        return YES;
    }else{
        return NO;
    }
}
@end
