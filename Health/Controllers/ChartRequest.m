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
        success(response);
        NSLog(@"__________________%@",response);
    } failure:^(NSError *error) {
        
    }];
 //   [NetWorking post:url params:parameter success:^(id response) {
        
//        if (![Util isEmpty:[response objectForKey:@"data"]]) {
//            //解析 获取userid和usertoken
//            [array removeAllObjects];
//            for (NSDictionary *favoriteDictionary in [response objectForKey:@"data"]) {
//                MessageFavoriteEntity *favoriteEntity = [[MessageFavoriteEntity alloc]init];
//                favoriteEntity.favoriteTime = [favoriteDictionary objectForKey:@"favoritetime"];
//                favoriteEntity.favoriteType = [NSString stringWithFormat:@"%@",[favoriteDictionary objectForKey:@"type"]];
//                favoriteEntity.favoriteid = [NSString stringWithFormat:@"%@",[favoriteDictionary objectForKey:@"favoriteid"]];
//                favoriteEntity.userid = [NSString stringWithFormat:@"%@",[favoriteDictionary objectForKey:@"userid"]];
//                favoriteEntity.username = [NSString stringWithFormat:@"%@",[favoriteDictionary objectForKey:@"username"]];
//                favoriteEntity.userPortrait = [NSString stringWithFormat:@"%@",[favoriteDictionary objectForKey:@"userportrait"]];
//                favoriteEntity.trendid = [NSString stringWithFormat:@"%@",[favoriteDictionary objectForKey:@"trendid"]];
//                favoriteEntity.courseid = [NSString stringWithFormat:@"%@",[favoriteDictionary objectForKey:@"courseid"]];
//                favoriteEntity.courseTitle = [NSString stringWithFormat:@"%@",[favoriteDictionary objectForKey:@"coursetitle"]];
//                favoriteEntity.replyPhoto = [NSString stringWithFormat:@"%@",[favoriteDictionary objectForKey:@"trendphoto"]];
//                favoriteEntity.favoriteTrendsType = [NSString stringWithFormat:@"%@", [favoriteDictionary objectForKey:@"trendstype"]];
//                [array addObject:favoriteEntity];
//            }
//        }
//        if (success) {
//            success(response);
//        }
//    }
//    failure:^(NSError *error) {
//        if (error) {
//            failure(error);
//        }
//    }];
    

//    }

}
@end
