//
//  CourseQAEntity.h
//  Health
//
//  Created by cheng on 15/2/4.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CourseQAEntity : NSObject

@property (nonatomic,strong) NSString *questionid;
@property (nonatomic,strong) NSString *questionusername;
@property (nonatomic,strong) NSString *questionuserid;
@property (nonatomic,strong) NSString *questioncontent;
@property (nonatomic,strong) NSString *questiontime;
@property (nonatomic,strong) NSString *questionhasanswer;
@property (nonatomic,strong) NSMutableArray *answerArray;

@end


@interface AnswerEntity : NSObject

@property (nonatomic,strong) NSString *answerContent;
@property (nonatomic,strong) NSString *answerTime;
@property (nonatomic,strong) NSString *answerid;


@end

