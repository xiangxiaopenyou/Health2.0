//
//  CourseQAEntity.m
//  Health
//
//  Created by cheng on 15/2/4.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "CourseQAEntity.h"

@implementation CourseQAEntity

- (instancetype)init{
    self  = [super init];
    if (self) {
        self.answerArray = [[NSMutableArray alloc]init];
    }
    return self;
}
@end


@implementation AnswerEntity

@end

