//
//  UserData.m
//  Health
//
//  Created by cheng on 15/1/23.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "UserData.h"

static UserData *userData;

@implementation UserData

- (id)init{
    self = [super init];
    if (self) {
        self.favoriteNum = [NSNumber numberWithInt:0];
        self.replyNum = [NSNumber numberWithInt:0];
    }
    return self;
}

+ (UserData*)shared{
    @synchronized([UserData class]){
        if (userData == nil) {
            userData = [[self alloc ] init];
        }return userData;
    }
    return nil;
}
@end