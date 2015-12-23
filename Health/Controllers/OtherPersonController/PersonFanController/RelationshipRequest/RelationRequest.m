//
//  RelationRequest.m
//  Health
//
//  Created by cheng on 15/3/4.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "RelationRequest.h"
#import "MyFuns.h"

@implementation RelationRequest

+ (void)fansListWith:(NSMutableArray*)array parameter:(NSDictionary*)parameter URL:(NSString*)url success:(void(^)(id response))success failure:(void(^)(NSError *error))failure{
    [NetWorking post:url params:parameter success:^(id response) {
        
        if (![Util isEmpty:[response objectForKey:@"data"]]) {
            //解析 获取userid和usertoken
            [array removeAllObjects];
            for (NSDictionary *tempDictionary in [response objectForKey:@"data"]) {
                MyFuns *entity = [[MyFuns alloc]init];
                entity.birthday = [NSString stringWithFormat:@"%@",[tempDictionary objectForKey:@"birthday"]];
                entity.created_time = [NSString stringWithFormat:@"%@",[tempDictionary objectForKey:@"created_time"]];
                entity.flag = [NSString stringWithFormat:@"%@",[tempDictionary objectForKey:@"flag"]];
                entity.ID = [NSString stringWithFormat:@"%@",[tempDictionary objectForKey:@"id"]];
                entity.introduce = [NSString stringWithFormat:@"%@",[tempDictionary objectForKey:@"introduce"]];
                entity.name = [NSString stringWithFormat:@"%@",[tempDictionary objectForKey:@"name"]];
                entity.nickname = [NSString stringWithFormat:@"%@",[tempDictionary objectForKey:@"nickname"]];
                entity.portrait = [NSString stringWithFormat:@"%@",[tempDictionary objectForKey:@"portrait"]];
                entity.sex = [NSString stringWithFormat:@"%@",[tempDictionary objectForKey:@"sex"]];
                entity.time = [NSString stringWithFormat:@"%@",[tempDictionary objectForKey:@"time"]];
                entity.type = [NSString stringWithFormat:@"%@",[tempDictionary objectForKey:@"type"]];
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

+ (void)fansMoreListWith:(NSMutableArray*)array parameter:(NSDictionary*)parameter URL:(NSString*)url success:(void(^)(id response))success failure:(void(^)(NSError *error))failure{
    [NetWorking post:url params:parameter success:^(id response) {
        
        if (![Util isEmpty:[response objectForKey:@"data"]]) {
            //解析 获取userid和usertoken
            for (NSDictionary *tempDictionary in [response objectForKey:@"data"]) {
            MyFuns *entity = [[MyFuns alloc]init];
            entity.birthday = [NSString stringWithFormat:@"%@",[tempDictionary objectForKey:@"birthday"]];
            entity.created_time = [NSString stringWithFormat:@"%@",[tempDictionary objectForKey:@"created_time"]];
            entity.flag = [NSString stringWithFormat:@"%@",[tempDictionary objectForKey:@"flag"]];
            entity.ID = [NSString stringWithFormat:@"%@",[tempDictionary objectForKey:@"id"]];
            entity.introduce = [NSString stringWithFormat:@"%@",[tempDictionary objectForKey:@"introduce"]];
            entity.name = [NSString stringWithFormat:@"%@",[tempDictionary objectForKey:@"name"]];
            entity.nickname = [NSString stringWithFormat:@"%@",[tempDictionary objectForKey:@"nickname"]];
            entity.portrait = [NSString stringWithFormat:@"%@",[tempDictionary objectForKey:@"portrait"]];
            entity.sex = [NSString stringWithFormat:@"%@",[tempDictionary objectForKey:@"sex"]];
            entity.time = [NSString stringWithFormat:@"%@",[tempDictionary objectForKey:@"time"]];
            entity.type = [NSString stringWithFormat:@"%@",[tempDictionary objectForKey:@"type"]];
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
@end
