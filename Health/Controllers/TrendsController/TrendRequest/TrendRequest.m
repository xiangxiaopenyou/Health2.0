//
//  TrendRequest.m
//  Health
//
//  Created by 项小盆友 on 15/2/2.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "TrendRequest.h"

@implementation TrendRequest

+ (void)writeTrendsWith:(NSDictionary *)parameter success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    NSString *url = [NSString stringWithFormat:@"%@%@", URL_BASE, URL_WRITETRENDS];
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

+ (void)getTrendsListWith:(NSDictionary *)parameter success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    NSString *url = [NSString stringWithFormat:@"%@%@", URL_BASE, URL_GETTRENDLIST];
    [NetWorking post:url params:parameter success:^(id response) {
        if (success) {
            if ([[response objectForKey:@"state"]  integerValue] == 1000) {
                UserData *userData = [UserData shared];
                UserInfo *userInfo = userData.userInfo;
                NSMutableArray *array = [[NSMutableArray alloc] init];
                NSArray *tempArray = [response objectForKey:@"data"];
                for(NSDictionary *tempDic in tempArray){
                    Trend *trend = [Trend MR_createEntity];
                    trend.trendid = [tempDic objectForKey:@"id"];
                    trend.trendcontent = [Util isEmpty:[tempDic objectForKey:@"trendcontent"]]? @"":[tempDic objectForKey:@"trendcontent"];
                    trend.trendphoto = [Util isEmpty:[tempDic objectForKey:@"trendpicture"]]? @"":[tempDic objectForKey:@"trendpicture"];
                    trend.trendtime = [tempDic objectForKey:@"created_time"];
                    trend.userid = [tempDic objectForKey:@"userid"];
                    trend.usernickname = [Util isEmpty:[tempDic objectForKey:@"usernickname"]]?@"":[tempDic objectForKey:@"usernickname"];
                    trend.userheaderphoto = [Util isEmpty:[tempDic objectForKey:@"userheadportrait"]]?@"":[tempDic objectForKey:@"userheadportrait"];
                    trend.islike = [tempDic objectForKey:@"isfavorite"];
                    trend.ispublic = [tempDic objectForKey:@"ispublic"];
                    NSInteger likeNumber = [[tempDic objectForKey:@"likenumber"] integerValue];
                    trend.trendlikenumber = [NSString stringWithFormat:@"%04ld", (long)likeNumber];
                    trend.trendcommentnumber = [tempDic objectForKey:@"commentnumber"];
                    trend.couseid = [Util isEmpty:[tempDic objectForKey:@"courseid"]]?@"":[tempDic objectForKey:@"courseid"];
                    trend.usersex = [Util isEmpty:[tempDic objectForKey:@"usersex"]]?@"":[tempDic objectForKey:@"usersex"];
                    trend.usertype = [tempDic objectForKey:@"usernicktype"];
                    trend.useraddress = [Util isEmpty:[tempDic objectForKey:@"trendaddress"]]?@"":[tempDic objectForKey:@"trendaddress"];
                    trend.picTag = [Util isEmpty:[tempDic objectForKey:@"picTag"]]?@"":[tempDic objectForKey:@"picTag"];
                    if (![Util isEmpty:[tempDic objectForKey:@"comments"]]) {
                        NSMutableArray *commentsArray = [[NSMutableArray alloc] init];
                        NSArray *tempCommentsArray = [tempDic objectForKey:@"comments"];
                        for(NSDictionary *tempCommentsDic in tempCommentsArray){
                            TrendComment *comment = [TrendComment MR_createEntity];
                            if ([[tempCommentsDic objectForKey:@"type"] integerValue] == 1) {
                                comment.commenttype = [tempCommentsDic objectForKey:@"type"];
                                comment.usernickname = [Util isEmpty:[tempCommentsDic objectForKey:@"commentusernickname"]]?@"":[tempCommentsDic objectForKey:@"commentusernickname"];
                                if (![Util isEmpty:[tempCommentsDic objectForKey:@"userheadportrait"]]) {
                                    comment.userheadphoto = [tempCommentsDic objectForKey:@"userheadportrait"];
                                }
                                else{
                                    comment.userheadphoto = @"";
                                }
                                
                                comment.commentcontent = [tempCommentsDic objectForKey:@"commentcontent"];
                                [commentsArray addObject:comment];
                            }
                        }
                        [trend.trendcommentSet addObjectsFromArray:commentsArray];
                        [[NSManagedObjectContext MR_defaultContext]MR_saveToPersistentStoreAndWait];
                    }
                    if(![Util isEmpty:[tempDic objectForKey:@"favorite"]]){
                        NSMutableArray *likeMemberArray = [tempDic objectForKey:@"favorite"];
                        NSString *likeMemberHeadString = @"";
                        for(NSDictionary *tempLikeDic in likeMemberArray){
                            if (![Util isEmpty:[tempLikeDic objectForKey:@"portrait"]]){
                                likeMemberHeadString = [likeMemberHeadString stringByAppendingString:[tempLikeDic objectForKey:@"portrait"]];
                                likeMemberHeadString = [likeMemberHeadString
                                                        stringByAppendingString:@";"];
                            }
                            
                        }
                        trend.trendlikemember = likeMemberHeadString;
                        
                    }
                    [array addObject:trend];
                    
                }
                [userInfo.alltrendsSet addObjectsFromArray:array];
                [[NSManagedObjectContext MR_defaultContext]MR_saveToPersistentStoreAndWait];
            }
            else{}
            
            success(response);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)getAttentionTrendsListWith:(NSDictionary *)parameter success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    NSString *url = [NSString stringWithFormat:@"%@%@", URL_BASE, URL_GETATTENTIONTRENDLIST];
    [NetWorking post:url params:parameter success:^(id response) {
        if (success) {
            if ([[response objectForKey:@"state"]  integerValue] == 1000) {
                UserData *userData = [UserData shared];
                UserInfo *userInfo = userData.userInfo;
                NSMutableArray *array = [[NSMutableArray alloc] init];
                NSArray *tempArray = [response objectForKey:@"data"];
                for(NSDictionary *tempDic in tempArray){
                    Trend *trend = [Trend MR_createEntity];
                    trend.trendid = [tempDic objectForKey:@"id"];
                    trend.trendcontent = [Util isEmpty:[tempDic objectForKey:@"trendcontent"]]? @"":[tempDic objectForKey:@"trendcontent"];
                    trend.trendphoto = [Util isEmpty:[tempDic objectForKey:@"trendpicture"]]? @"":[tempDic objectForKey:@"trendpicture"];
                    trend.trendtime = [tempDic objectForKey:@"created_time"];
                    trend.userid = [tempDic objectForKey:@"userid"];
                    trend.usernickname = [Util isEmpty:[tempDic objectForKey:@"usernickname"]]?@"":[tempDic objectForKey:@"usernickname"];
                    trend.userheaderphoto = [Util isEmpty:[tempDic objectForKey:@"userheadportrait"]]?@"":[tempDic objectForKey:@"userheadportrait"];
                    trend.islike = [tempDic objectForKey:@"isfavorite"];
                    trend.ispublic = [tempDic objectForKey:@"ispublic"];
                    NSInteger likeNumber = [[tempDic objectForKey:@"likenumber"] integerValue];
                    trend.trendlikenumber = [NSString stringWithFormat:@"%04ld", (long)likeNumber];
                    trend.trendcommentnumber = [tempDic objectForKey:@"commentnumber"];
                    trend.couseid = [Util isEmpty:[tempDic objectForKey:@"courseid"]]?@"":[tempDic objectForKey:@"courseid"];
                    trend.usersex = [tempDic objectForKey:@"usersex"];
                    trend.usertype = [tempDic objectForKey:@"usernicktype"];
                    trend.useraddress = [Util isEmpty:[tempDic objectForKey:@"trendaddress"]]?@"":[tempDic objectForKey:@"trendaddress"];
                    trend.picTag = [Util isEmpty:[tempDic objectForKey:@"picTag"]]?@"":[tempDic objectForKey:@"picTag"];
                    if (![Util isEmpty:[tempDic objectForKey:@"comments"]]) {
                        NSMutableArray *commentsArray = [[NSMutableArray alloc] init];
                        NSArray *tempCommentsArray = [tempDic objectForKey:@"comments"];
                        for(NSDictionary *tempCommentsDic in tempCommentsArray){
                            TrendComment *comment = [TrendComment MR_createEntity];
                            if ([[tempCommentsDic objectForKey:@"type"] integerValue] == 1) {
                                comment.commenttype = [tempCommentsDic objectForKey:@"type"];
                                comment.usernickname = [Util isEmpty:[tempCommentsDic objectForKey:@"commentusernickname"]]?@"":[tempCommentsDic objectForKey:@"commentusernickname"];
                                comment.userheadphoto = [tempCommentsDic objectForKey:@"userheadportrait"];
                                comment.commentcontent = [tempCommentsDic objectForKey:@"commentcontent"];
                                [commentsArray addObject:comment];
                            }
                        }
                        [trend.trendcommentSet addObjectsFromArray:commentsArray];
                        [[NSManagedObjectContext MR_defaultContext]MR_saveToPersistentStoreAndWait];
                        
                    }
                    if(![Util isEmpty:[tempDic objectForKey:@"favorite"]]){
                        NSMutableArray *likeMemberArray = [tempDic objectForKey:@"favorite"];
                        NSString *likeMemberHeadString = @"";
                        for(NSDictionary *tempLikeDic in likeMemberArray){
                            likeMemberHeadString = [likeMemberHeadString stringByAppendingString:[tempLikeDic objectForKey:@"portrait"]];
                            likeMemberHeadString = [likeMemberHeadString
                                                    stringByAppendingString:@";"];
                        }
                        trend.trendlikemember = likeMemberHeadString;
                    }
                    [array addObject:trend];
                    
                }
                [userInfo.alltrendsSet addObjectsFromArray:array];
                [[NSManagedObjectContext MR_defaultContext]MR_saveToPersistentStoreAndWait];
            }
            else{}
            
            success(response);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];

}

+ (void)trendDetailWtih:(NSDictionary *)parameter success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    NSString *url = [NSString stringWithFormat:@"%@%@", URL_BASE, URL_TRENDDETAIL];
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

+ (void)commentTrendWith:(NSDictionary *)parameter success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    NSString *url = [NSString stringWithFormat:@"%@%@", URL_BASE, URL_TRENDCOMMENT];
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

+ (void)replyTrendWith:(NSDictionary *)parameter success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    NSString *url = [NSString stringWithFormat:@"%@%@", URL_BASE, URL_TRENDREPLY];
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
+ (void)likeTrendWith:(NSDictionary *)parameter success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    NSString *url = [NSString stringWithFormat:@"%@%@", URL_BASE, URL_LIKETREND];
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
+ (void)cancelLikeTrendWith:(NSDictionary *)parameter success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    NSString *url = [NSString stringWithFormat:@"%@%@", URL_BASE, URL_DISLIKETREND];
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

+ (void)likeMemberWith:(NSDictionary *)parameter success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    NSString *url = [NSString stringWithFormat:@"%@%@", URL_BASE, URL_LIKEMEMBERLIST];
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

+ (void)deleteTrendWith:(NSDictionary *)parameter success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    NSString *url = [NSString stringWithFormat:@"%@%@", URL_BASE, URL_DELETETREND];
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

+ (void)payAttentionWith:(NSDictionary *)parameter success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    NSString *url = [NSString stringWithFormat:@"%@%@", URL_BASE, URL_PAYATTENTION];
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

+ (void)cancelAttentionWith:(NSDictionary *)parameter success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    NSString *url = [NSString stringWithFormat:@"%@%@", URL_BASE, URL_CANCELATTENTION];
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

+ (void)reportWith:(NSDictionary *)parameter success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    NSString *url = [NSString stringWithFormat:@"%@%@", URL_BASE, URL_REPORT];
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

+ (void)tagListWith:(NSDictionary *)parameter success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    NSString *url = [NSString stringWithFormat:@"%@%@", URL_BASE, URL_TAG_LIST];
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

+ (void)tagCreateWith:(NSDictionary *)parameter success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    NSString *url = [NSString stringWithFormat:@"%@%@", URL_BASE, URL_TAG_CREATE];
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

+ (void)foodListWith:(NSDictionary *)parameter success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    NSString *url = [NSString stringWithFormat:@"%@%@", URL_BASE, URL_FOOD_LIST];
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

+ (void)sportsListWith:(NSDictionary *)parameter success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    NSString *url = [NSString stringWithFormat:@"%@%@", URL_BASE, URL_SPORTS_LIST];
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

+ (void)clockinListWith:(NSDictionary *)parameter success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    NSString *url = [NSString stringWithFormat:@"%@%@", URL_BASE, URL_CLOCKIN_LIST];
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
+ (void)recommendUsersWith:(NSDictionary *)parameter success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    NSString *url = [NSString stringWithFormat:@"%@%@", URL_BASE, URL_RECOMMENDUSERS];
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
+ (void)recommendUserListWith:(NSDictionary *)parameter success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    NSString *url = [NSString stringWithFormat:@"%@%@", URL_BASE, URL_RECOMMENDUSERLIST];
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
+ (void)recommendPhotosListWith:(NSDictionary *)parameter success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    NSString *url = [NSString stringWithFormat:@"%@%@", URL_BASE, URL_RECOMMENDPHOTOSLIST];
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
+(void)focusImageWith:(NSDictionary *)parameter success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    NSString *url = [NSString stringWithFormat:@"%@%@", URL_BASE, URL_FOCUSIMAGE];
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
