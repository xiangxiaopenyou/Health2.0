//
//  MyInfoRequest.m
//  Health
//
//  Created by 王杰 on 15/2/3.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "MyInfoRequest.h"

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
            [[NSManagedObjectContext MR_defaultContext]MR_saveToPersistentStoreAndWait];
        }
        success(response);
    } failure:^(NSError *error) {
        
    }];
}

+ (void)myPicWithParam:(NSDictionary *)parameter success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    NSString *url = [NSString stringWithFormat:@"%@%@",URL_BASE,URL_MY_PIC];
    [NetWorking post:url params:parameter success:^(id response) {
        if (![Util isEmpty:[response objectForKey:@"data"]]) {
            //解析 获取照片
            NSArray *array = [response objectForKey:@"data"];
            if (success) {
                success(array);
            }
        }
    } failure:^(NSError *error) {
        
    }];
    
}


@end
