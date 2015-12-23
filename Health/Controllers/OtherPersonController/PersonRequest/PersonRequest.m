//
//  PersonRequest.m
//  Health
//
//  Created by cheng on 15/3/3.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "PersonRequest.h"

@implementation PersonRequest

+ (void)personInfoWith:(PersonEntity*)person success:(void(^)(id response))success failure:(void(^)(NSError *error))failure{
    UserData *userdata = [UserData shared];
    UserInfo *userinfo = userdata.userInfo;
    NSMutableDictionary *parameter = [NSMutableDictionary dictionaryWithObjectsAndKeys:userinfo.userid,@"userid",userinfo.usertoken,@"usertoken",person.personid,@"friendid", nil];
    NSString *url = [NSString stringWithFormat:@"%@%@",URL_BASE,URL_FRIEND_INFO];
    [NetWorking post:url params:parameter success:^(id response) {
        
        if (![Util isEmpty:[response objectForKey:@"data"]]) {
            //解析 获取userid和usertoken
            NSDictionary *tempDictionary = [response objectForKey:@"data"];
            person.photo = [NSString stringWithFormat:@"%@",[tempDictionary objectForKey:@"userheadportrait"]];
            person.name = [NSString stringWithFormat:@"%@",[tempDictionary objectForKey:@"nickname"]];
            person.sex = [NSString stringWithFormat:@"%@",[tempDictionary objectForKey:@"usersex"]];//1是男生
            person.attention = [NSString stringWithFormat:@"%@",[tempDictionary objectForKey:@"myfollow"]];
            person.fans = [NSString stringWithFormat:@"%@",[tempDictionary objectForKey:@"myfeans"]];
            person.isTeacher = [NSString stringWithFormat:@"%@",[tempDictionary objectForKey:@"usertype"]];//1是教练
            person.tearchPoint = [NSString stringWithFormat:@"%@",[tempDictionary objectForKey:@"systemscoring"]];
            person.skillPoint = [NSString stringWithFormat:@"%@",[tempDictionary objectForKey:@"studebtscoring"]];
            person.flag = [NSString stringWithFormat:@"%@",[tempDictionary objectForKey:@"flag"]];
            person.chatid = [NSString stringWithFormat:@"%@",[tempDictionary objectForKey:@"chatid"]];
            person.birthday = [NSString stringWithFormat:@"%@",[tempDictionary objectForKey:@"userbirthday"]];
            person.rongyunid = [NSString stringWithFormat:@"%@",[tempDictionary objectForKey:@"rongtoken"]];
        }
        if (success) {
            success(response);
        }
    } failure:^(NSError *error) {
        if (error) {
            failure(error);
        }
    }];
}

+ (void)personDetailInfoWith:(PersonEntity*)person success:(void(^)(id response))success failure:(void(^)(NSError *error))failure{
    
    UserData *userdata = [UserData shared];
    UserInfo *userinfo = userdata.userInfo;
    NSMutableDictionary *parameter = [NSMutableDictionary dictionaryWithObjectsAndKeys:userinfo.userid,@"userid",userinfo.usertoken,@"usertoken",person.personid,@"friendid", nil];
    NSString *url = [NSString stringWithFormat:@"%@%@",URL_BASE,URL_FRIEND_DETAILINFO];
    [NetWorking post:url params:parameter success:^(id response) {
        
        if (![Util isEmpty:[response objectForKey:@"data"]]) {
            //解析 获取userid和usertoken
            NSDictionary *tempDictionary = [response objectForKey:@"data"];
            person.photo = [NSString stringWithFormat:@"%@",[tempDictionary objectForKey:@"userheadportrait"]];
            person.name = [NSString stringWithFormat:@"%@",[tempDictionary objectForKey:@"nickname"]];
            person.sex = [NSString stringWithFormat:@"%@",[tempDictionary objectForKey:@"usersex"]];//1是男生
            person.attention = [NSString stringWithFormat:@"%@",[tempDictionary objectForKey:@"myfollow"]];
            person.fans = [NSString stringWithFormat:@"%@",[tempDictionary objectForKey:@"myfeans"]];
            person.isTeacher = [NSString stringWithFormat:@"%@",[tempDictionary objectForKey:@"usertype"]];//1是教练
            person.tearchPoint = [NSString stringWithFormat:@"%@",[tempDictionary objectForKey:@"systemscoring"]];
            person.skillPoint = [NSString stringWithFormat:@"%@",[tempDictionary objectForKey:@"studebtscoring"]];
            person.flag = [NSString stringWithFormat:@"%@",[tempDictionary objectForKey:@"flag"]];
            person.chatid = [NSString stringWithFormat:@"%@",[tempDictionary objectForKey:@"chatid"]];
            person.birthday = [NSString stringWithFormat:@"%@",[tempDictionary objectForKey:@"userbirthday"]];
        }
        if (success) {
            success(response);
        }
    } failure:^(NSError *error) {
        if (error) {
            failure(error);
        }
    }];
}

+ (void)pictureListWith:(NSMutableArray*)array PersonID:(NSString*)personID success:(void(^)(id response))success failure:(void(^)(NSError *error))failure{
    UserData *userdata = [UserData shared];
    UserInfo *userinfo = userdata.userInfo;
    NSMutableDictionary *parameter = [NSMutableDictionary dictionaryWithObjectsAndKeys:userinfo.userid,@"userid",userinfo.usertoken,@"usertoken",personID,@"friendid", nil];
    NSString *url = [NSString stringWithFormat:@"%@%@",URL_BASE,URL_FRIEND_PICTURE];
    [NetWorking post:url params:parameter success:^(id response) {
        
        if (![Util isEmpty:[response objectForKey:@"data"]]) {
            //解析 获取userid和usertoken
            [array removeAllObjects];
            for (NSDictionary *tempDictionary in [response objectForKey:@"data"]) {
                PhotoEntity *entity = [[PhotoEntity alloc]init];
                entity.createdtime = [NSString stringWithFormat:@"%@",[tempDictionary objectForKey:@"created_time"]];
                entity.trendid = [NSString stringWithFormat:@"%@",[tempDictionary objectForKey:@"id"]];
                entity.trendpicture = [NSString stringWithFormat:@"%@",[tempDictionary objectForKey:@"trendpicture"]];
                [array addObject:entity];
            }
        }
        if (success) {
            success(response);
        }
    } failure:^(NSError *error) {
        if (error) {
            failure(error);
        }
    }];
}
+ (void)pictureMoreListWith:(NSMutableArray *)array PersonID:(NSString *)personID success:(void(^)(id))success failure:(void(^)(NSError *))failure{
    UserData *userdata = [UserData shared];
    UserInfo *userinfo = userdata.userInfo;
    NSMutableDictionary *parameter = [NSMutableDictionary dictionaryWithObjectsAndKeys:userinfo.userid,@"userid",userinfo.usertoken,@"usertoken",personID,@"friendid", nil];
    if (array.count == 0 || array == nil) {
    }else{
        PhotoEntity *entity = [array objectAtIndex:array.count-1];
        [parameter setObject:entity.createdtime forKey:@"time"];
    }
    
    NSString *url = [NSString stringWithFormat:@"%@%@",URL_BASE,URL_FRIEND_PICTURE];
    [NetWorking post:url params:parameter success:^(id response) {
        
        if (![Util isEmpty:[response objectForKey:@"data"]]) {
            //解析 获取userid和usertoken
            for (NSDictionary *tempDictionary in [response objectForKey:@"data"]) {
                PhotoEntity *entity = [[PhotoEntity alloc]init];
                entity.createdtime = [NSString stringWithFormat:@"%@",[tempDictionary objectForKey:@"created_time"]];
                entity.trendid = [NSString stringWithFormat:@"%@",[tempDictionary objectForKey:@"id"]];
                entity.trendpicture = [NSString stringWithFormat:@"%@",[tempDictionary objectForKey:@"trendpicture"]];
                [array addObject:entity];
            }
        }
        if (success) {
            success(response);
        }
    } failure:^(NSError *error) {
        if (error) {
            failure(error);
        }
    }];
}

+ (void)courseListWith:(NSMutableArray*)array PersonID:(NSString*)personID success:(void(^)(id response))success failure:(void(^)(NSError *error))failure{
    UserData *userdata = [UserData shared];
    UserInfo *userinfo = userdata.userInfo;
    NSMutableDictionary *parameter = [NSMutableDictionary dictionaryWithObjectsAndKeys:userinfo.userid,@"userid",userinfo.usertoken,@"usertoken",personID,@"friendid", nil];
    NSString *url = [NSString stringWithFormat:@"%@%@",URL_BASE,URL_FRIEND_COURSE];
    [NetWorking post:url params:parameter success:^(id response) {
        
        if (![Util isEmpty:[response objectForKey:@"data"]]) {
            //解析 获取userid和usertoken
            [array removeAllObjects];
            for (NSDictionary *tempDictionary in [response objectForKey:@"data"]) {
                CourseEntity *entity = [[CourseEntity alloc]init];
                entity.createdtime = [NSString stringWithFormat:@"%@",[tempDictionary objectForKey:@"created_time"]];
                entity.coursecommentnumber = [NSString stringWithFormat:@"%@",[tempDictionary objectForKey:@"coursecommentnumber"]];
                entity.coursecourseday = [NSString stringWithFormat:@"%@",[tempDictionary objectForKey:@"courseday"]];
                entity.coursephoto = [NSString stringWithFormat:@"%@",[tempDictionary objectForKey:@"coursephoto"]];
                entity.coursestarttime = [NSString stringWithFormat:@"%@",[tempDictionary objectForKey:@"coursestarttime"]];
                entity.courseid = [NSString stringWithFormat:@"%@",[tempDictionary objectForKey:@"id"]];
                entity.courseLevel = [NSString stringWithFormat:@"%@",[tempDictionary objectForKey:@"coursedifficulty"]];
                entity.coursetitle = [NSString stringWithFormat:@"%@", [tempDictionary objectForKey:@"coursetitle"]];
                entity.is_join = [NSString stringWithFormat:@"%@", [tempDictionary objectForKey:@"coursepayment"]];
                [array addObject:entity];
            }
        }
        if (success) {
            success(response);
        }
    } failure:^(NSError *error) {
        if (error) {
            failure(error);
        }
    }];
}

+ (void)courseMoreListWith:(NSMutableArray *)array PersonID:(NSString *)personID success:(void(^)(id))success failure:(void(^)(NSError *))failure{
    UserData *userdata = [UserData shared];
    UserInfo *userinfo = userdata.userInfo;
    NSMutableDictionary *parameter = [NSMutableDictionary dictionaryWithObjectsAndKeys:userinfo.userid,@"userid",userinfo.usertoken,@"usertoken",personID,@"friendid", nil];
    if (array.count == 0 || array == nil) {
    }else{
        CourseEntity *entity = [array objectAtIndex:array.count-1];
        [parameter setObject:entity.createdtime forKey:@"time"];
    }
    NSString *url = [NSString stringWithFormat:@"%@%@",URL_BASE,URL_FRIEND_COURSE];
    [NetWorking post:url params:parameter success:^(id response) {
        
        if (![Util isEmpty:[response objectForKey:@"data"]]) {
            //解析 获取userid和usertoken
            for (NSDictionary *tempDictionary in [response objectForKey:@"data"]) {
                CourseEntity *entity = [[CourseEntity alloc]init];
                entity.createdtime = [NSString stringWithFormat:@"%@",[tempDictionary objectForKey:@"created_time"]];
                entity.coursecommentnumber = [NSString stringWithFormat:@"%@",[tempDictionary objectForKey:@"coursecommentnumber"]];
                entity.coursecourseday = [NSString stringWithFormat:@"%@",[tempDictionary objectForKey:@"courseday"]];
                entity.coursephoto = [NSString stringWithFormat:@"%@",[tempDictionary objectForKey:@"coursephoto"]];
                entity.coursestarttime = [NSString stringWithFormat:@"%@",[tempDictionary objectForKey:@"coursestarttime"]];
                entity.courseid = [NSString stringWithFormat:@"%@",[tempDictionary objectForKey:@"id"]];
                entity.courseLevel = [NSString stringWithFormat:@"%@",[tempDictionary objectForKey:@"coursedifficulty"]];
                entity.coursetitle = [NSString stringWithFormat:@"%@", [tempDictionary objectForKey:@"coursetitle"]];
                entity.is_join = [NSString stringWithFormat:@"%@", [tempDictionary objectForKey:@"coursepayment"]];
                [array addObject:entity];
            }
        }
        if (success) {
            success(response);
        }
    } failure:^(NSError *error) {
        if (error) {
            failure(error);
        }
    }];
}

+ (void)addAttentionWith:(NSString *)friendid success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    UserData *userdata = [UserData shared];
    UserInfo *userinfo = userdata.userInfo;
    NSMutableDictionary *parameter = [NSMutableDictionary dictionaryWithObjectsAndKeys:userinfo.userid,@"userid",userinfo.usertoken,@"usertoken",friendid,@"fansid", nil];
    NSString *url = [NSString stringWithFormat:@"%@%@",URL_BASE,URL_MY_FANSCREATE];
    [NetWorking post:url params:parameter success:^(id response) {
        if (success) {
            success(response);
        }
    } failure:^(NSError *error) {
    }];
}

+ (void)deleteAttentionWith:(NSString *)friendid success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    UserData *userdata = [UserData shared];
    UserInfo *userinfo = userdata.userInfo;
    NSMutableDictionary *parameter = [NSMutableDictionary dictionaryWithObjectsAndKeys:userinfo.userid,@"userid",userinfo.usertoken,@"usertoken",friendid,@"fansid", nil];
    NSString *url = [NSString stringWithFormat:@"%@%@",URL_BASE,URL_MY_DELEFANS];
    [NetWorking post:url params:parameter success:^(id response) {
        if (success) {
            success(response);
        }
    } failure:^(NSError *error) {
    }];
}
@end
