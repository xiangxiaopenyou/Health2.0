//
//  UserData.h
//  Health
//
//  Created by cheng on 15/1/23.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfo.h"

@interface UserData : NSObject

@property (nonatomic,strong) NSString *userid;
@property (nonatomic,strong) NSString *userToken;
@property (nonatomic,strong) NSString *userrongyunid;
@property (nonatomic,strong) UserInfo *userInfo;
@property (nonatomic, strong) NSString *deviceToken;
@property (nonatomic,strong) NSNumber *replyNum;
@property (nonatomic,strong) NSNumber *favoriteNum;

+ (UserData*)shared;

@end
