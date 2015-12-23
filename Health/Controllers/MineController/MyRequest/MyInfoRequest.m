//
//  MyInfoRequest.m
//  Health
//
//  Created by 王杰 on 15/2/3.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "MyInfoRequest.h"
#import "PersonEntity.h"

@implementation MyInfoRequest

+ (void)myInfoWithParam:(NSDictionary*)parameter success:(void(^)(id response))success failure:(void(^)(NSError *error))failure{
    
    NSString *url = [NSString stringWithFormat:@"%@%@",URL_BASE,URL_MY_INFO];
    [NetWorking post:url params:parameter success:^(id response) {
        if (![Util isEmpty:[response objectForKey:@"data"]]) {
            //解析 获取name,sex,photo,fans,focus...
            UserData *userdata = [UserData shared];
            UserInfo *userInfo = userdata.userInfo;
            userInfo.username = [Util isEmpty:[[response objectForKey:@"data"] objectForKey:@"nickname"]]?nil:[[response objectForKey:@"data"] objectForKey:@"nickname"];
            userInfo.balance = [Util isEmpty:[[response objectForKey:@"data"] objectForKey:@"balance"]] ?nil:[[response objectForKey:@"data"] objectForKey:@"balance"];
            userInfo.myfeans = [Util isEmpty:[[response objectForKey:@"data"] objectForKey:@"myfeans"]]?nil:[[response objectForKey:@"data"] objectForKey:@"myfeans"];
            userInfo.myfollow = [Util isEmpty:[[response objectForKey:@"data"] objectForKey:@"myfollow"]]?nil:[[response objectForKey:@"data"] objectForKey:@"myfollow"];
            userInfo.totalmoney = [Util isEmpty:[[response objectForKey:@"data"] objectForKey:@"totalmoney"]]?nil:[[response objectForKey:@"data"] objectForKey:@"totalmoney"];
            userInfo.userbirthday = [Util isEmpty:[[response objectForKey:@"data"] objectForKey:@"userbirthday"]]?nil:[[response objectForKey:@"data"] objectForKey:@"userbirthday"];
            userInfo.userphoto = [Util isEmpty:[[response objectForKey:@"data"] objectForKey:@"userheadportrait"]]?nil:[[response objectForKey:@"data"] objectForKey:@"userheadportrait"];
            userInfo.usersex = [Util isEmpty:[[response objectForKey:@"data"] objectForKey:@"usersex"]]?nil:[[response objectForKey:@"data"] objectForKey:@"usersex"];
            userInfo.usertype = [Util isEmpty:[[response objectForKey:@"data"] objectForKey:@"usertype"]]?nil:[[response objectForKey:@"data"] objectForKey:@"usertype"];
            userInfo.teacherpoint = [Util isEmpty:[[response objectForKey:@"data"] objectForKey:@"systemscoring"]]?nil:[[response objectForKey:@"data"] objectForKey:@"systemscoring"];
            userInfo.skillpoint = [Util isEmpty:[[response objectForKey:@"data"] objectForKey:@"studebtscoring"]]?nil:[[response objectForKey:@"data"] objectForKey:@"studebtscoring"];//这两个字段需要修改
            userInfo.goodat = [Util isEmpty:[[response objectForKey:@"data"] objectForKey:@"goodat"]]?nil:[[response objectForKey:@"data"] objectForKey:@"goodat"];
            userInfo.usertelphone = [Util isEmpty:[[response objectForKey:@"data"] objectForKey:@"tel"]]?nil:[[response objectForKey:@"data"] objectForKey:@"tel"];
            userInfo.userbodyphoto = [Util isEmpty:[[response objectForKey:@"data"] objectForKey:@"ownerphoto"]]?nil:[[response objectForKey:@"data"] objectForKey:@"ownerphoto"];
            [[NSManagedObjectContext MR_defaultContext]MR_saveToPersistentStoreAndWait];
        }
        success(response);
    } failure:^(NSError *error) {
        
    }];
}
+ (void)myWeightInfo:(NSDictionary *)parameter success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    NSString *url = [NSString stringWithFormat:@"%@%@", URL_BASE, URL_WEIGHTINFO];
    [NetWorking post:url params:parameter success:^(id response) {
        if (success) {
            success(response);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}
+ (void)dairyInfoList:(NSDictionary *)parameter success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    NSString *url = [NSString stringWithFormat:@"%@%@", URL_BASE, URL_DAIRY_LIST];
    [NetWorking post:url params:parameter success:^(id response) {
        if (success) {
            success(response);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)myPicWithParam:(NSDictionary *)parameter success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    NSString *url = [NSString stringWithFormat:@"%@%@",URL_BASE,URL_MY_PIC];
    [NetWorking post:url params:parameter success:^(id response) {
            if (success) {
                success(response);
            }
    } failure:^(NSError *error) {
        
    }];
    
}

+ (void)myCourseWithParam:(NSDictionary*)parameter success:(void(^)(id response))success failure:(void(^)(NSError *error))failure {
    NSString *url = [NSString stringWithFormat:@"%@%@",URL_BASE,URL_MY_COURESE];
    [NetWorking post:url params:parameter success:^(id response) {
            if (success) {
                success (response);
        }
    } failure:^(NSError *error) {
        NSLog(@"error mycourse");
    }];
}



+ (void)myFansWithParam:(NSDictionary *)parameter success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    NSString *url = [NSString stringWithFormat:@"%@%@",URL_BASE,URL_MY_FANS];
    [NetWorking post:url params:parameter success:^(id response) {
        if (success) {
            success(response);
        }
    } failure:^(NSError *error) {
        //        <#code#>
    }];
}

+ (void)myAttentionWithParam:(NSDictionary *)parameter success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    NSString *url = [NSString stringWithFormat:@"%@%@",URL_BASE,URL_MY_ATTENTION];
    [NetWorking post:url params:parameter success:^(id response) {
        if (success) {
            success(response);
        }
    } failure:^(NSError *error) {
        //        <#code#>
    }];
}

+ (void)fanCreateWithParam:(NSDictionary *)parameter success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    NSString *url = [NSString stringWithFormat:@"%@%@",URL_BASE,URL_MY_FANSCREATE];
    [NetWorking post:url params:parameter success:^(id response) {
        if (success) {
            success(response);
        }
    } failure:^(NSError *error) {
        //        <#code#>
    }];
}

+ (void)fanDelesWithParam:(NSDictionary *)parameter success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    NSString *url = [NSString stringWithFormat:@"%@%@",URL_BASE,URL_MY_DELEFANS];
    [NetWorking post:url params:parameter success:^(id response) {
        if (success) {
            success(response);
        }
    } failure:^(NSError *error) {
        //        <#code#>
    }];
}


+ (void)myDetailInfoWithParam:(NSDictionary *)parameter success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    NSString *url = [NSString stringWithFormat:@"%@%@",URL_BASE,URL_MY_INFO_DETAIL];
    [NetWorking post:url params:parameter success:^(id response) {
        if (![Util isEmpty:[response objectForKey:@"data"]]) {
            UserData *userdata = [UserData shared];
            UserInfo *userInfo = userdata.userInfo;
            userInfo.username = [Util isEmpty:[[response objectForKey:@"data"] objectForKey:@"nickname"]]?nil:[[response objectForKey:@"data"] objectForKey:@"nickname"];
            userInfo.userarea = [Util isEmpty:[[response objectForKey:@"data"] objectForKey:@"userarea"]] ?nil:[[response objectForKey:@"data"] objectForKey:@"userarea"];
            userInfo.userweight = [Util isEmpty:[[response objectForKey:@"data"] objectForKey:@"userweight"]]?nil:[[response objectForKey:@"data"] objectForKey:@"userweight"];
            userInfo.userheight = [Util isEmpty:[[response objectForKey:@"data"] objectForKey:@"userheight"]]?nil:[[response objectForKey:@"data"] objectForKey:@"userheight"];
            userInfo.usertype = [Util isEmpty:[[response objectForKey:@"data"] objectForKey:@"usertype"]]?nil:[[response objectForKey:@"data"] objectForKey:@"usertype"];
            userInfo.userbirthday = [Util isEmpty:[[response objectForKey:@"data"] objectForKey:@"userbirthday"]]?nil:[[response objectForKey:@"data"] objectForKey:@"userbirthday"];
            userInfo.userphoto = [Util isEmpty:[[response objectForKey:@"data"] objectForKey:@"userheadportrait"]]?nil:[[response objectForKey:@"data"] objectForKey:@"userheadportrait"];
            userInfo.usersex = [Util isEmpty:[[response objectForKey:@"data"] objectForKey:@"usersex"]]?nil:[[response objectForKey:@"data"] objectForKey:@"usersex"];
            userInfo.usertelphone = [Util isEmpty:[[response objectForKey:@"data"] objectForKey:@"tel"]]?nil:[[response objectForKey:@"data"] objectForKey:@"tel"];
            userInfo.userintrduce = [Util isEmpty:[[response objectForKey:@"data"] objectForKey:@"userintroduce"]]?nil:[[response objectForKey:@"data"] objectForKey:@"userintroduce"];
            userInfo.usertargetweight = [Util isEmpty:[[response objectForKey:@"data"] objectForKey:@"weight"]]?nil:[[response objectForKey:@"data"] objectForKey:@"weight"];
            [[NSManagedObjectContext MR_defaultContext]MR_saveToPersistentStoreAndWait];
        }
        success (response);
    } failure:^(NSError *error) {
        failure (error);
    }];
}

+ (void)modifyMyInfoWithParam:(NSDictionary*)parameter success:(void(^)(id response))success failure:(void(^)(NSError *error))failure{
    NSString *url = [NSString stringWithFormat:@"%@%@",URL_BASE,URL_MY_INFO_MODIFY];
    [NetWorking post:url params:parameter success:^(id response) {
        if (![Util isEmpty:[response objectForKey:@"data"]]) {
//            UserData *userdata = [UserData shared];
//            UserInfo *userInfo = userdata.userInfo;
        }
        success (response);
    } failure:^(NSError *error) {
        failure (error);
    }];
}
+ (void)modifyWeightInfoWith:(NSDictionary *)parameter success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    NSString *url = [NSString stringWithFormat:@"%@%@",URL_BASE,URL_WEIGHT_INFO_MODIFY];
    [NetWorking post:url params:parameter success:^(id response) {
        if (![Util isEmpty:[response objectForKey:@"data"]]) {
        }
        success (response);
    } failure:^(NSError *error) {
        failure (error);
    }];
}


+ (void)modifyMyPortraitWithParam:(NSDictionary*)parameter success:(void(^)(id response))success failure:(void(^)(NSError *error))failure{
    NSString *url = [NSString stringWithFormat:@"%@%@",URL_BASE,URL_MY_INFO_MODIFYPHOTO];
    [NetWorking post:url params:parameter success:^(id response) {
        if (![Util isEmpty:[response objectForKey:@"data"]]) {
        }
        success (response);
    } failure:^(NSError *error) {
        failure (error);
    }];
}

+ (void)pictureListWith:(NSMutableArray*)array success:(void(^)(id response))success failure:(void(^)(NSError *error))failure{
    UserData *userdata = [UserData shared];
    UserInfo *userinfo = userdata.userInfo;
    NSMutableDictionary *parameter = [NSMutableDictionary dictionaryWithObjectsAndKeys:userinfo.userid,@"userid",userinfo.usertoken,@"usertoken", nil];
    NSString *url = [NSString stringWithFormat:@"%@%@",URL_BASE,URL_MY_PIC];
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
+ (void)pictureMoreListWith:(NSMutableArray *)array success:(void(^)(id))success failure:(void(^)(NSError *))failure{
    UserData *userdata = [UserData shared];
    UserInfo *userinfo = userdata.userInfo;
    NSMutableDictionary *parameter = [NSMutableDictionary dictionaryWithObjectsAndKeys:userinfo.userid,@"userid",userinfo.usertoken,@"usertoken", nil];
    if (array.count == 0 || array == nil) {
    }else{
        PhotoEntity *entity = [array objectAtIndex:array.count-1];
        [parameter setObject:entity.createdtime forKey:@"time"];
    }
    
    NSString *url = [NSString stringWithFormat:@"%@%@",URL_BASE,URL_MY_PIC];
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

+ (void)courseListWith:(NSMutableArray*)array success:(void(^)(id response))success failure:(void(^)(NSError *error))failure{
    UserData *userdata = [UserData shared];
    UserInfo *userinfo = userdata.userInfo;
    NSMutableDictionary *parameter = [NSMutableDictionary dictionaryWithObjectsAndKeys:userinfo.userid,@"userid",userinfo.usertoken,@"usertoken", nil];
    NSString *url = [NSString stringWithFormat:@"%@%@",URL_BASE,URL_MY_COURESE];
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
                entity.coursetitle = [NSString stringWithFormat:@"%@",[tempDictionary objectForKey:@"coursetitle"]];
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

+ (void)courseMoreListWith:(NSMutableArray *)array success:(void(^)(id))success failure:(void(^)(NSError *))failure{
    UserData *userdata = [UserData shared];
    UserInfo *userinfo = userdata.userInfo;
    NSMutableDictionary *parameter = [NSMutableDictionary dictionaryWithObjectsAndKeys:userinfo.userid,@"userid",userinfo.usertoken,@"usertoken", nil];
    NSString *url = [NSString stringWithFormat:@"%@%@",URL_BASE,URL_MY_COURESE];
    if (array.count == 0 || array == nil) {
    }else{
        CourseEntity *entity = [array objectAtIndex:array.count-1];
        [parameter setObject:entity.createdtime forKey:@"time"];
    }
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
                entity.coursetitle = [NSString stringWithFormat:@"%@",[tempDictionary objectForKey:@"coursetitle"]];
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
+ (void)bodyInfo:(NSDictionary *)parameter success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    NSString *url = [NSString stringWithFormat:@"%@%@", URL_BASE, URL_BODY_INFO];
    [NetWorking post:url params:parameter success:^(id response) {
        if (success) {
            success(response);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}
+ (void)bodyInfoEdit:(NSDictionary *)parameter success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    NSString *url = [NSString stringWithFormat:@"%@%@", URL_BASE, URL_BODY_INFO_EDIT];
    [NetWorking post:url params:parameter success:^(id response) {
        if (success) {
            success(response);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end
