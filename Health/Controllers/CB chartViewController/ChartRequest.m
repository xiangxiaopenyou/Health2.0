//
//  ChartRequest.m
//  Health
//
//  Created by 陈 on 15/6/10.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "ChartRequest.h"
#import "ChartData.h"

@implementation ChartRequest

+(void)success:(void(^)(id response))success failure:(void(^)(NSError *error))failure
{
    UserData *userdata = [UserData shared];
    UserInfo *userinfo = userdata.userInfo;
    NSMutableDictionary *parameter = [NSMutableDictionary dictionaryWithObjectsAndKeys:userinfo.userid,@"userid",userinfo.usertoken,@"usertoken",nil];//@"2015-06-07",@"time",
    NSString *url = [NSString stringWithFormat:@"%@%@",URL_BASE,URL_CHART_DATA];
    [NetWorking post:url params:parameter success:^(id response) {
        ! success ?: success(response);
        //success(response);
    } failure:^(NSError *error) {
        
    }];
}
@end
