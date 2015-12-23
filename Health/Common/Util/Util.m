//
//  Util.m
//  Health
//
//  Created by cheng on 15/1/23.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "Util.h"

@implementation Util

+ (BOOL)isLogin{
    if (![Util isEmpty:[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"]]) {
        return YES;
    }
    return NO;
}

+ (BOOL)isEmpty:(id)sender{
    if (sender == nil || [sender isEqual:@""] || sender == [NSNull null] ||[sender isEqual:[NSNull null]]) {
        return YES;
    }
    return NO;
}

+ (UIImage*)levelImage:(NSString*)string{
    if ([self isEmpty:string]) {
        return nil;
    }else{
        NSInteger index = [string integerValue];
        if (index<=0 || index > 5) {
            return nil;
        }else{
            NSString *imagename = [NSString stringWithFormat:@"level_image%ld.png",(long)index];
            return [UIImage imageNamed:imagename];
        }
    }
}

+ (NSString*)urlPhoto:(NSString*)key
{
    if ([self isEmpty:key]) {
        return [NSString stringWithFormat:@"%@%@",URL_FOCUSMAP,@"1.png?imageView/5/w/320/h/480"];
    }else{
        NSArray *urlComps = [key componentsSeparatedByString:@"://"];
        if([urlComps count] && ( [[urlComps objectAtIndex:0] isEqualToString:@"http"]||[[urlComps objectAtIndex:0] isEqualToString:@"https"] ))
        {
            return key;
        }
        return [NSString stringWithFormat:@"%@%@",URL_FOCUSMAP,key];
    }
}

+ (NSString*)urlZoomPhoto:(NSString*)key{
    if ([self isEmpty:key]) {
        return [NSString stringWithFormat:@"%@%@",URL_FOCUSMAP,@"1.png?imageView/5/w/160/h/160"];
    }else{
        
        NSArray *urlComps = [key componentsSeparatedByString:@"://"];
        if([urlComps count] && ([[urlComps objectAtIndex:0] isEqualToString:@"http"]||[[urlComps objectAtIndex:0] isEqualToString:@"https"]))
        {
            return [NSString stringWithFormat:@"%@?imageView/5/w/160/h/160", key];
        }
        return [NSString stringWithFormat:@"%@%@?imageView/5/w/160/h/160",URL_FOCUSMAP,key];
    }
}

+ (NSString*)urlWeixinPhoto:(NSString *)key{
    if ([self isEmpty:key]) {
        return [NSString stringWithFormat:@"%@%@",URL_FOCUSMAP,@"1.png?imageView/3/w/40/h/40"];
    }else{
        
        NSArray *urlComps = [key componentsSeparatedByString:@"://"];
        if([urlComps count] && ([[urlComps objectAtIndex:0] isEqualToString:@"http"]||[[urlComps objectAtIndex:0] isEqualToString:@"https"]))
        {
            return [NSString stringWithFormat:@"%@?imageView/3/w/40/h/40", key];
        }
        return [NSString stringWithFormat:@"%@%@?imageView/3/w/40/h/40",URL_FOCUSMAP,key];
    }
}

+ (NSString*)urlForVideo:(NSString*)key{
    if ([self isEmpty:key]) {
        return nil;
    }else{
        NSArray *urlComps = [key componentsSeparatedByString:@"://"];
        if([urlComps count] && ([[urlComps objectAtIndex:0] isEqualToString:@"http"]||[[urlComps objectAtIndex:0] isEqualToString:@"https"]))
        {
            return [NSString stringWithFormat:@"%@", key];
        }
        return [NSString stringWithFormat:@"%@%@",URL_FOCUSMAP,key];
    }
}

+ (BOOL) isValidateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9])|(17[0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    //    NSLog(@"phoneTest is %@",phoneTest);
    return [phoneTest evaluateWithObject:mobile];
}
+ (NSInteger)getSportsEnergy:(NSInteger)sportsTime withPerEnergy:(NSInteger)perEnergy{
    float x = sportsTime/60.0;
    float y = perEnergy * x;
    NSInteger sportsEnergy = y;
    return sportsEnergy;
    
}
+ (NSInteger)getFoodEnergy:(NSInteger)foodWeight withPerEnergy:(NSInteger)perEnergy{
    float x = foodWeight/100.0;
    float y = x * perEnergy;
    NSInteger foodEnergy = y;
    return foodEnergy;
}

+ (NSString *)toJsonString:(id)theData{
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:theData options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}
+ (NSArray *)toArray:(NSString *)jsonString{
    NSData *jsonDate = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *array = [NSJSONSerialization JSONObjectWithData:jsonDate options:NSJSONReadingAllowFragments error:nil];
    return array;
}

//+ (NSString *)energyImage:(NSString *)energy{
//    if ([energy integerValue] <= 4000) {
//        
//    }
//}

@end
