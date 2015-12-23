//
//  PersonEntity.h
//  Health
//
//  Created by cheng on 15/3/3.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PersonEntity : NSObject

@property (nonatomic,strong) NSString *personid;
@property (nonatomic,strong) NSString *photo;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *sex;
@property (nonatomic,strong) NSString *fans;
@property (nonatomic,strong) NSString *attention;
@property (nonatomic,strong) NSString *tearchPoint;
@property (nonatomic,strong) NSString *skillPoint;
@property (nonatomic,strong) NSString *goodAt;
@property (nonatomic,strong) NSString *flag;
@property (nonatomic,strong) NSString *chatid;
@property (nonatomic,strong) NSString *isTeacher;
@property (nonatomic,strong) NSString *birthday;
@property (nonatomic,strong) NSString *height;
@property (nonatomic,strong) NSString *weight;
@property (nonatomic,strong) NSString *introduce;
@property (nonatomic,strong) NSString *address;
@property (nonatomic,strong) NSString *rongyunid;

@end

@interface PhotoEntity : NSObject

@property (nonatomic,strong) NSString *trendid;
@property (nonatomic,strong) NSString *trendpicture;
@property (nonatomic,strong) NSString *createdtime;

@end

@interface CourseEntity : NSObject

@property (nonatomic,strong) NSString *courseid;
@property (nonatomic, strong) NSString *coursetitle;
@property (nonatomic,strong) NSString *coursecommentnumber;
@property (nonatomic,strong) NSString *coursecourseday;
@property (nonatomic,strong) NSString *coursephoto;
@property (nonatomic,strong) NSString *coursestarttime;
@property (nonatomic,strong) NSString *createdtime;
@property (nonatomic,strong) NSString *courseLevel;
@property (nonatomic, strong) NSString *is_join;

@end
