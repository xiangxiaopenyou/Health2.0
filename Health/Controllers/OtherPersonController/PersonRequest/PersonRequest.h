//
//  PersonRequest.h
//  Health
//
//  Created by cheng on 15/3/3.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PersonEntity.h"

@interface PersonRequest : NSObject

+ (void)personInfoWith:(PersonEntity*)person success:(void(^)(id response))success failure:(void(^)(NSError *error))failure;


+ (void)pictureListWith:(NSMutableArray*)array PersonID:(NSString*)personID success:(void(^)(id response))success failure:(void(^)(NSError *error))failure;

+ (void)pictureMoreListWith:(NSMutableArray *)array PersonID:(NSString *)personID success:(void(^)(id))success failure:(void(^)(NSError *))failure;

+ (void)courseListWith:(NSMutableArray*)array PersonID:(NSString*)personID success:(void(^)(id response))success failure:(void(^)(NSError *error))failure;

+ (void)courseMoreListWith:(NSMutableArray *)array PersonID:(NSString *)personID success:(void(^)(id))success failure:(void(^)(NSError *))failure;

+ (void)addAttentionWith:(NSString *)friendid success:(void(^)(id))success failure:(void(^)(NSError *))failure;

+ (void)deleteAttentionWith:(NSString *)friendid success:(void(^)(id))success failure:(void(^)(NSError *))failure;

+ (void)personDetailInfoWith:(PersonEntity*)person success:(void(^)(id response))success failure:(void(^)(NSError *error))failure;
@end
