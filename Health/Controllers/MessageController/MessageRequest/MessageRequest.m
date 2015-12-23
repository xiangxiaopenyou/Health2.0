//
//  MessageRequest.m
//  Health
//
//  Created by cheng on 15/2/7.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "MessageRequest.h"
#import "MessageEntity.h"

@implementation MessageRequest

+ (void)replyListWith:(NSMutableArray*)array success:(void(^)(id response))success failure:(void(^)(NSError *error))failure{
    
    UserData *userdata = [UserData shared];
    UserInfo *userinfo = userdata.userInfo;
    NSMutableDictionary *parameter = [NSMutableDictionary dictionaryWithObjectsAndKeys:userinfo.userid,@"userid",userinfo.usertoken,@"usertoken", nil];
    if (array.count == 0 || array == nil) {
    }else{
        MessageReplyEntity *entity = [array objectAtIndex:array.count-1];
        [parameter setObject:entity.replyTime forKey:@"time"];
    }
    NSString *url = [NSString stringWithFormat:@"%@%@",URL_BASE,URL_MESSAGE_REPLYLIST];
    [NetWorking post:url params:parameter success:^(id response) {
        
        if (![Util isEmpty:[response objectForKey:@"data"]]) {
            //解析 获取userid和usertoken
            for (NSDictionary *replyDictionary in [response objectForKey:@"data"]) {
                MessageReplyEntity *reply = [[MessageReplyEntity alloc]init];
                reply.replyContent = [NSString stringWithFormat:@"%@",[replyDictionary objectForKey:@"trendscommentcontent"]];
                reply.replyid = [NSString stringWithFormat:@"%@",[replyDictionary objectForKey:@"trendscommentid"]];
                reply.replyPhoto = [NSString stringWithFormat:@"%@",[replyDictionary objectForKey:@"trendphoto"]];
                reply.replyTime = [NSString stringWithFormat:@"%@",[replyDictionary objectForKey:@"trendscommenttime"]];
                reply.replyType = [NSString stringWithFormat:@"%@",[replyDictionary objectForKey:@"type"]];
                reply.userid = [NSString stringWithFormat:@"%@",[replyDictionary objectForKey:@"userid"]];
                reply.username = [NSString stringWithFormat:@"%@",[replyDictionary objectForKey:@"username"]];
                reply.userPortrait = [NSString stringWithFormat:@"%@",[replyDictionary objectForKey:@"userportrait"]];
                reply.courseid = [NSString stringWithFormat:@"%@",[replyDictionary objectForKey:@"courseid"]];
                reply.courseTitle = [NSString stringWithFormat:@"%@",[replyDictionary objectForKey:@"coursetitle"]];
                reply.trendid = [NSString stringWithFormat:@"%@",[replyDictionary objectForKey:@"trendid"]];
                reply.replyTitle = [NSString stringWithFormat:@"%@", [replyDictionary objectForKey:@"title"]];
                reply.replyTrendType = [NSString stringWithFormat:@"%@", [replyDictionary objectForKey:@"trendstype"]];
                [array addObject:reply];
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


+ (void)replyListRefreshWith:(NSMutableArray*)array success:(void(^)(id response))success failure:(void(^)(NSError *error))failure{
    
    UserData *userdata = [UserData shared];
    UserInfo *userinfo = userdata.userInfo;
    NSMutableDictionary *parameter = [NSMutableDictionary dictionaryWithObjectsAndKeys:userinfo.userid,@"userid",userinfo.usertoken,@"usertoken", nil];
    NSString *url = [NSString stringWithFormat:@"%@%@",URL_BASE,URL_MESSAGE_REPLYLIST];
    [NetWorking post:url params:parameter success:^(id response) {
        
        if (![Util isEmpty:[response objectForKey:@"data"]]) {
            //解析 获取userid和usertoken
            [array removeAllObjects];
            for (NSDictionary *replyDictionary in [response objectForKey:@"data"]) {
                MessageReplyEntity *reply = [[MessageReplyEntity alloc]init];
                reply.replyContent = [NSString stringWithFormat:@"%@",[replyDictionary objectForKey:@"trendscommentcontent"]];
                reply.replyid = [NSString stringWithFormat:@"%@",[replyDictionary objectForKey:@"trendscommentid"]];
                reply.replyPhoto = [NSString stringWithFormat:@"%@",[replyDictionary objectForKey:@"trendphoto"]];
                reply.replyTime = [NSString stringWithFormat:@"%@",[replyDictionary objectForKey:@"trendscommenttime"]];
                reply.replyType = [NSString stringWithFormat:@"%@",[replyDictionary objectForKey:@"type"]];
                reply.userid = [NSString stringWithFormat:@"%@",[replyDictionary objectForKey:@"userid"]];
                reply.username = [NSString stringWithFormat:@"%@",[replyDictionary objectForKey:@"username"]];
                reply.userPortrait = [NSString stringWithFormat:@"%@",[replyDictionary objectForKey:@"userportrait"]];
                reply.courseid = [NSString stringWithFormat:@"%@",[replyDictionary objectForKey:@"courseid"]];
                reply.courseTitle = [NSString stringWithFormat:@"%@",[replyDictionary objectForKey:@"coursetitle"]];
                reply.trendid = [NSString stringWithFormat:@"%@",[replyDictionary objectForKey:@"trendid"]];
                reply.replyTitle = [NSString stringWithFormat:@"%@", [replyDictionary objectForKey:@"title"]];
                reply.replyTrendType = [NSString stringWithFormat:@"%@", [replyDictionary objectForKey:@"trendstype"]];
                [array addObject:reply];
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


+ (void)favoriteListRefreshWith:(NSMutableArray*)array success:(void(^)(id response))success failure:(void(^)(NSError *error))failure{
    UserData *userdata = [UserData shared];
    UserInfo *userinfo = userdata.userInfo;
    NSMutableDictionary *parameter = [NSMutableDictionary dictionaryWithObjectsAndKeys:userinfo.userid,@"userid",userinfo.usertoken,@"usertoken", nil];
    NSString *url = [NSString stringWithFormat:@"%@%@",URL_BASE,URL_MESSAGE_FAVORITELIST];
    [NetWorking post:url params:parameter success:^(id response) {
        
        if (![Util isEmpty:[response objectForKey:@"data"]]) {
            //解析 获取userid和usertoken
            [array removeAllObjects];
            for (NSDictionary *favoriteDictionary in [response objectForKey:@"data"]) {
                MessageFavoriteEntity *favoriteEntity = [[MessageFavoriteEntity alloc]init];
                favoriteEntity.favoriteTime = [favoriteDictionary objectForKey:@"favoritetime"];
                favoriteEntity.favoriteType = [NSString stringWithFormat:@"%@",[favoriteDictionary objectForKey:@"type"]];
                favoriteEntity.favoriteid = [NSString stringWithFormat:@"%@",[favoriteDictionary objectForKey:@"favoriteid"]];
                favoriteEntity.userid = [NSString stringWithFormat:@"%@",[favoriteDictionary objectForKey:@"userid"]];
                favoriteEntity.username = [NSString stringWithFormat:@"%@",[favoriteDictionary objectForKey:@"username"]];
                favoriteEntity.userPortrait = [NSString stringWithFormat:@"%@",[favoriteDictionary objectForKey:@"userportrait"]];
                favoriteEntity.trendid = [NSString stringWithFormat:@"%@",[favoriteDictionary objectForKey:@"trendid"]];
                favoriteEntity.courseid = [NSString stringWithFormat:@"%@",[favoriteDictionary objectForKey:@"courseid"]];
                favoriteEntity.courseTitle = [NSString stringWithFormat:@"%@",[favoriteDictionary objectForKey:@"coursetitle"]];
                favoriteEntity.replyPhoto = [NSString stringWithFormat:@"%@",[favoriteDictionary objectForKey:@"trendphoto"]];
                favoriteEntity.favoriteTrendsType = [NSString stringWithFormat:@"%@", [favoriteDictionary objectForKey:@"trendstype"]];
                [array addObject:favoriteEntity];
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

+ (void)favoriteListWith:(NSMutableArray*)array success:(void(^)(id response))success failure:(void(^)(NSError *error))failure{
    UserData *userdata = [UserData shared];
    UserInfo *userinfo = userdata.userInfo;
    NSMutableDictionary *parameter = [NSMutableDictionary dictionaryWithObjectsAndKeys:userinfo.userid,@"userid",userinfo.usertoken,@"usertoken", nil];
    if (array.count == 0 || array == nil) {
    }else{
        MessageFavoriteEntity *entity = [array objectAtIndex:array.count-1];
        [parameter setObject:entity.favoriteTime forKey:@"time"];
    }
    NSString *url = [NSString stringWithFormat:@"%@%@",URL_BASE,URL_MESSAGE_FAVORITELIST];
    [NetWorking post:url params:parameter success:^(id response) {
        
        if (![Util isEmpty:[response objectForKey:@"data"]]) {
            //解析 获取userid和usertoken
            for (NSDictionary *favoriteDictionary in [response objectForKey:@"data"]) {
                MessageFavoriteEntity *favoriteEntity = [[MessageFavoriteEntity alloc]init];
                favoriteEntity.favoriteTime = [favoriteDictionary objectForKey:@"favoritetime"];
                favoriteEntity.favoriteType = [NSString stringWithFormat:@"%@",[favoriteDictionary objectForKey:@"type"]];
                favoriteEntity.favoriteid = [NSString stringWithFormat:@"%@",[favoriteDictionary objectForKey:@"favoriteid"]];
                favoriteEntity.userid = [NSString stringWithFormat:@"%@",[favoriteDictionary objectForKey:@"userid"]];
                favoriteEntity.username = [NSString stringWithFormat:@"%@",[favoriteDictionary objectForKey:@"username"]];
                favoriteEntity.userPortrait = [NSString stringWithFormat:@"%@",[favoriteDictionary objectForKey:@"userportrait"]];
                favoriteEntity.trendid = [NSString stringWithFormat:@"%@",[favoriteDictionary objectForKey:@"trendid"]];
                favoriteEntity.courseid = [NSString stringWithFormat:@"%@",[favoriteDictionary objectForKey:@"courseid"]];
                favoriteEntity.courseTitle = [NSString stringWithFormat:@"%@",[favoriteDictionary objectForKey:@"coursetitle"]];
                favoriteEntity.replyPhoto = [NSString stringWithFormat:@"%@",[favoriteDictionary objectForKey:@"trendphoto"]];
                favoriteEntity.favoriteTrendsType = [NSString stringWithFormat:@"%@", [favoriteDictionary objectForKey:@"trendstype"]];
                [array addObject:favoriteEntity];
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

+ (void)notReadWithSuccess:(void(^)(id response))success failure:(void(^)(NSError *error))failure{
    UserData *userdata = [UserData shared];
    UserInfo *userinfo = userdata.userInfo;
    NSDictionary *parameter = [NSDictionary dictionaryWithObjectsAndKeys:userinfo.userid,@"userid",userinfo.usertoken,@"usertoken", nil];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",URL_BASE,URL_MESSAGE_NOTREADNUM];
    [NetWorking post:url params:parameter success:^(id response) {
        
        if (![Util isEmpty:[response objectForKey:@"data"]]) {
            //解析 获取userid和usertoken
            NSDictionary *dataDiction = [response objectForKey:@"data"];
            @try {
                userdata.replyNum = [NSNumber numberWithInt:[[dataDiction objectForKey:@"replynum"] intValue]];
            }
            @catch (NSException *exception) {
                userdata.replyNum = [NSNumber numberWithInt:0];
            }
            @try {
                userdata.favoriteNum = [NSNumber numberWithInt:[[dataDiction objectForKey:@"favoritenum"] intValue]];
            }
            @catch (NSException *exception) {
                userdata.favoriteNum = [NSNumber numberWithInt:0];
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

+ (void)getSystemMessage:(NSDictionary *)parameter success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    NSString *url = [NSString stringWithFormat:@"%@%@", URL_BASE, URL_SYSTEM_MESSAGE];
    [NetWorking post:url params:parameter success:^(id response) {
        if (success) {
            success(response);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure (error);
        }
    }];
}

@end
