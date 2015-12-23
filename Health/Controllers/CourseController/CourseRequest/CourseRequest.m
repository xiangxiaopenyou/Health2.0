//
//  CourseRequest.m
//  Health
//
//  Created by cheng on 15/2/2.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "CourseRequest.h"

@implementation CourseRequest

+ (void)courseListWithSuccess:(void(^)(id response))success failure:(void(^)(NSError *error))failure{
    
    UserData *userdata = [UserData shared];
    UserInfo *userinfo = userdata.userInfo;
    NSDictionary *parameter = [NSDictionary dictionaryWithObjectsAndKeys:userinfo.userid,@"userid",userinfo.usertoken,@"usertoken", nil];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",URL_BASE,URL_COURSE_COURSE_LIST];
    [NetWorking post:url params:parameter success:^(id response) {
        if (![Util isEmpty:[response objectForKey:@"data"]]) {
            //解析 获取userid和usertoken
            NSDictionary *dataDiction = [response objectForKey:@"data"];
            if (![Util isEmpty:[dataDiction objectForKey:@"minecourse"]]) {
                //[self parseMineCourse:[dataDiction objectForKey:@"minecourse"]];
            }
            if (![Util isEmpty:[dataDiction objectForKey:@"recommendcourse"]]) {
                [self parseRecommendCourse:[dataDiction objectForKey:@"recommendcourse"]];
            }
        }
        success(response);
    } failure:^(NSError *error) {
        
    }];
}

+ (void)myCourseListWithSuccess:(void (^)(id))success failure:(void (^)(NSError *))failure{
    UserData *userdata = [UserData shared];
    UserInfo *userinfo = userdata.userInfo;
    NSDictionary *parameter = [NSDictionary dictionaryWithObjectsAndKeys:userinfo.userid,@"userid",userinfo.usertoken,@"usertoken", nil];
    NSString *url = [NSString stringWithFormat:@"%@%@", URL_BASE, URL_COURSE_MYCOURSE_LIST];
    [NetWorking post:url params:parameter success:^(id response) {
        NSDictionary *data = [response objectForKey:@"data"];
        if (![Util isEmpty:data]) {
            if (![Util isEmpty:[data objectForKey:@"Start_were"]]) {
                [self parseMineCourse:[data objectForKey:@"Start_were"] withIndex:1];
            }
            if (![Util isEmpty:[data objectForKey:@"end"]]) {
                [self parseMineCourse:[data objectForKey:@"end"] withIndex:2];
            }
            if (![Util isEmpty:[data objectForKey:@"were"]]) {
                [self parseMineCourse:[data objectForKey:@"were"] withIndex:3];
            }
            
        }
        success(response);
    } failure:^(NSError *error) {
        
    }];
}
+ (void)allCourseListWithSuccess:(void (^)(id))success failure:(void (^)(NSError *))failure{
    UserData *userdata = [UserData shared];
    UserInfo *userinfo = userdata.userInfo;
    NSDictionary *parameter = [NSDictionary dictionaryWithObjectsAndKeys:userinfo.userid,@"userid",userinfo.usertoken,@"usertoken", nil];
    NSString *url = [NSString stringWithFormat:@"%@%@", URL_BASE, URL_COURSE_ALLCOURSE_LIST];
    [NetWorking post:url params:parameter success:^(id response) {
        if (![Util isEmpty:[response objectForKey:@"data"]]) {
            [self parseRecommendCourse:[response objectForKey:@"data"]];
        }
        success(response);
    } failure:^(NSError *error) {
        
    }];
}

+ (void)parseMineCourse:(NSDictionary*)arrayCourse withIndex:(NSInteger)index{
    NSMutableArray *mineCourseList = [[NSMutableArray alloc]init];
    for (NSDictionary *courseDiction in arrayCourse ) {
        Course *course = [Course MR_createEntity];
        
        if (![Util isEmpty:[courseDiction objectForKey:@"course"]]) {
            NSDictionary *courseTemp = [courseDiction objectForKey:@"course"];
            course.courseapplynum = [NSString stringWithFormat:@"%@",[courseTemp objectForKey:@"courseapplynum"]];
            course.coursecount = [NSString stringWithFormat:@"%@",[courseTemp objectForKey:@"coursecount"]];
            course.courseday = [NSString stringWithFormat:@"%@",[courseTemp objectForKey:@"courseday"]];
            course.coursedifficultty = [NSString stringWithFormat:@"%@",[courseTemp objectForKey:@"coursedifficulty"]];
            course.coursefat = [NSString stringWithFormat:@"%@",[courseTemp objectForKey:@"coursefat"]];
            course.courseid = [NSString stringWithFormat:@"%@",[courseTemp objectForKey:@"courseid"]];
            course.courseintrduce = [NSString stringWithFormat:@"%@",[courseTemp objectForKey:@"courseintroduce"]];
            course.courseoldprice = [NSString stringWithFormat:@"%@",[courseTemp objectForKey:@"courseoldprice"]];
            course.coursephoto = [NSString stringWithFormat:@"%@",[courseTemp objectForKey:@"coursephoto"]];
            course.coursepowerdifficulty = [NSString stringWithFormat:@"%@",[courseTemp objectForKey:@"coursepowerdifficulty"]];
            course.courseprice = [NSString stringWithFormat:@"%@",[courseTemp objectForKey:@"courseprice"]];
            course.courseshaping = [NSString stringWithFormat:@"%@",[courseTemp objectForKey:@"courseshaping"]];
            course.coursestarttime = [NSString stringWithFormat:@"%@",[courseTemp objectForKey:@"coursestarttime"]];
            course.coursecreatedtime = [NSString stringWithFormat:@"%@", [courseTemp objectForKey:@"created_time"]];
            course.coursestate = [NSString stringWithFormat:@"%@",[courseTemp objectForKey:@"coursestate"]];
            course.coursestrength = [NSString stringWithFormat:@"%@",[courseTemp objectForKey:@"coursestrength"]];
            course.coursetarget = [NSString stringWithFormat:@"%@",[courseTemp objectForKey:@"coursetarget"]];
            course.coursetitle = [NSString stringWithFormat:@"%@",[courseTemp objectForKey:@"coursetitle"]];
            course.coursehastake = [NSString stringWithFormat:@"1"];
            course.courseisstart = [NSString stringWithFormat:@"%@", [courseTemp objectForKey:@"flag"]];
            course.courseisappraise = [NSString stringWithFormat:@"%@", [courseTemp objectForKey:@"seetype"]];
            course.coursebody = [NSString stringWithFormat:@"%@", [courseTemp objectForKey:@"parts"]];
            course.coursedetailimgage = [NSString stringWithFormat:@"%@", [courseTemp objectForKey:@"partsimg"]];
            if (![Util isEmpty:[courseTemp objectForKey:@"clubname"]]) {
                course.courseofclub = [NSString stringWithFormat:@"%@", [courseTemp objectForKey:@"clubname"]];
            }
            else {
                course.courseofclub = @"";
            }
        }
        NSArray *tempArray = [courseDiction objectForKey:@"coursesub"];
        if (tempArray.count > 0) {
            NSMutableArray *array = [[NSMutableArray alloc]init];
            for (NSDictionary *courseSub in [courseDiction objectForKey:@"coursesub"] ) {
                for (NSDictionary *courseSubTemp in [courseSub objectForKey:@"data"]) {
                    CourseSub *courseSub = [CourseSub MR_createEntity];
                    courseSub.coursesubflag = [NSString stringWithFormat:@"%@",[courseSubTemp objectForKey:@"coursesubflag"]];
                    courseSub.coursesubid = [NSString stringWithFormat:@"%@",[courseSubTemp objectForKey:@"coursesubid"]];
                    courseSub.coursesubcontent = [NSString stringWithFormat:@"%@",[courseSubTemp objectForKey:@"coursesubcontent"]];
                    courseSub.coursesubday = [NSString stringWithFormat:@"%@",[courseSubTemp objectForKey:@"coursesubday"]];
                    courseSub.coursesubintrduce = [NSString stringWithFormat:@"%@",[courseSubTemp objectForKey:@"coursesubintroduce"]];
                    courseSub.coursesubtime = [NSString stringWithFormat:@"%@",[courseSubTemp objectForKey:@"coursesubtime"]];
                    courseSub.coursesubtitle = [NSString stringWithFormat:@"%@",[courseSubTemp objectForKey:@"coursesubtitle"]];
                    courseSub.coursesuborder = [NSNumber numberWithInt:[[NSString stringWithFormat:@"%@",[courseSubTemp objectForKey:@"coursesuborder"]]intValue]];
                    courseSub.coursesubtype = [NSString stringWithFormat:@"%@",[courseSubTemp objectForKey:@"coursesubtype"]];
                    [array addObject:courseSub];
                }
                
            }
            course.coursesub = [NSSet setWithArray:array];
        }
        if (![Util isEmpty:[courseDiction objectForKey:@"teacher"]]) {
            FriendInfo *teacher = [FriendInfo MR_createEntity];
            NSDictionary *teacherDic = [courseDiction objectForKey:@"teacher"];
            teacher.friendbirthday = [Util isEmpty:[teacherDic objectForKey:@"teacherbirthday"]]?nil:[teacherDic objectForKey:@"teacherbirthday"];
            teacher.friendpointstudent = [Util isEmpty:[teacherDic objectForKey:@"teacherpointstudent"]]?nil:[teacherDic objectForKey:@"teacherpointstudent"];
            teacher.friendpointsystem = [Util isEmpty:[teacherDic objectForKey:@"teacherpointsystem"]]?nil:[teacherDic objectForKey:@"teacherpointsystem"];
            teacher.friendid = [NSString stringWithFormat:@"%@",[teacherDic objectForKey:@"teacherid"]];
            teacher.friendintrduce = [NSString stringWithFormat:@"%@",[teacherDic objectForKey:@"teacherintrduce"]];
            teacher.friendphoto = [NSString stringWithFormat:@"%@",[teacherDic objectForKey:@"teacherphoto"]];
            teacher.friendsex = [NSString stringWithFormat:@"%@",[teacherDic objectForKey:@"teachersex"]];
            teacher.friendname = [NSString stringWithFormat:@"%@",[teacherDic objectForKey:@"teachernickname"]];
            teacher.friendoverallappraisal = [NSString stringWithFormat:@"%@", [teacherDic objectForKey:@"have"]];
            teacher.friendattitudescore = [NSString stringWithFormat:@"%@", [teacherDic objectForKey:@"teaching_attitude"]];
            teacher.friendskillscore = [NSString stringWithFormat:@"%@", [teacherDic objectForKey:@"expertise"]];
            
            course.teacher = teacher;
        }
        [mineCourseList addObject:course];
    }
    
    UserData *userdata = [UserData shared];
    UserInfo *userinfo = userdata.userInfo;
    if (index == 1) {
        userinfo.minecourse = [NSSet setWithArray:mineCourseList];
        [[NSManagedObjectContext MR_defaultContext]MR_saveToPersistentStoreAndWait];
    }
    else if (index == 2) {
        userinfo.myfinishedcourse = [NSSet setWithArray:mineCourseList];
        [[NSManagedObjectContext MR_defaultContext]MR_saveToPersistentStoreAndWait];
    }
    else {
        userinfo.myevaluatedcourse = [NSSet setWithArray:mineCourseList];
        [[NSManagedObjectContext MR_defaultContext]MR_saveToPersistentStoreAndWait];
    }
    
}

+ (void)parseRecommendCourse:(NSArray*)arrayCourse{
    NSMutableArray *recommendCourse = [[NSMutableArray alloc]init];
    for (NSDictionary *courseDiction in arrayCourse ) {
        Course *course = [Course MR_createEntity];
        
        if (![Util isEmpty:[courseDiction objectForKey:@"course"]]) {
            NSDictionary *courseTemp = [courseDiction objectForKey:@"course"];
            course.courseapplynum = [NSString stringWithFormat:@"%@",[courseTemp objectForKey:@"courseapplynum"]];
            course.coursecount = [NSString stringWithFormat:@"%@",[courseTemp objectForKey:@"coursecount"]];
            course.courseday = [NSString stringWithFormat:@"%@",[courseTemp objectForKey:@"courseday"]];
            course.coursedifficultty = [NSString stringWithFormat:@"%@",[courseTemp objectForKey:@"coursedifficulty"]];
            course.coursefat = [NSString stringWithFormat:@"%@",[courseTemp objectForKey:@"coursefat"]];
            course.courseid = [NSString stringWithFormat:@"%@",[courseTemp objectForKey:@"courseid"]];
            course.courseintrduce = [NSString stringWithFormat:@"%@",[courseTemp objectForKey:@"courseintroduce"]];
            course.courseoldprice = [NSString stringWithFormat:@"%@",[courseTemp objectForKey:@"courseoldprice"]];
            course.coursephoto = [NSString stringWithFormat:@"%@",[courseTemp objectForKey:@"coursephoto"]];
            course.coursepowerdifficulty = [NSString stringWithFormat:@"%@",[courseTemp objectForKey:@"coursepowerdifficulty"]];
            course.courseprice = [NSString stringWithFormat:@"%@",[courseTemp objectForKey:@"courseprice"]];
            course.courseshaping = [NSString stringWithFormat:@"%@",[courseTemp objectForKey:@"courseshaping"]];
            course.coursestarttime = [NSString stringWithFormat:@"%@",[courseTemp objectForKey:@"coursestarttime"]];
            course.coursecreatedtime = [NSString stringWithFormat:@"%@", [courseTemp objectForKey:@"created_time"]];
            course.coursestate = [NSString stringWithFormat:@"%@",[courseTemp objectForKey:@"coursestate"]];
            course.coursestrength = [NSString stringWithFormat:@"%@",[courseTemp objectForKey:@"coursestrength"]];
            course.coursetarget = [NSString stringWithFormat:@"%@",[courseTemp objectForKey:@"coursetarget"]];
            course.coursetitle = [NSString stringWithFormat:@"%@",[courseTemp objectForKey:@"coursetitle"]];
            course.coursehastake = [NSString stringWithFormat:@"2"];
            course.coursesign = [NSString stringWithFormat:@"%@", [courseTemp objectForKey:@"coursepayment"]];
            course.courseisstart = [NSString stringWithFormat:@"%@", [courseTemp objectForKey:@"flag"]];
            course.courseisappraise = [NSString stringWithFormat:@"%@", [courseTemp objectForKey:@"seetype"]];
            course.coursebody = [NSString stringWithFormat:@"%@", [courseTemp objectForKey:@"parts"]];
            course.coursedetailimgage = [NSString stringWithFormat:@"%@", [courseTemp objectForKey:@"partsimg"]];
            if (![Util isEmpty:[courseTemp objectForKey:@"clubname"]]) {
                course.courseofclub = [NSString stringWithFormat:@"%@", [courseTemp objectForKey:@"clubname"]];
            }
            else {
                course.courseofclub = @"";
            }
        }
        NSArray *tempArray = [courseDiction objectForKey:@"coursesub"];
        if (tempArray.count > 0) {
            NSMutableArray *array = [[NSMutableArray alloc]init];
            for (NSDictionary *courseSub in [courseDiction objectForKey:@"coursesub"] ) {
                for (NSDictionary *courseSubTemp in [courseSub objectForKey:@"data"]) {
                    CourseSub *courseSub = [CourseSub MR_createEntity];
                    courseSub.coursesubflag = [NSString stringWithFormat:@"%@",[courseSubTemp objectForKey:@"coursesubflag"]];
                    courseSub.coursesubid = [NSString stringWithFormat:@"%@",[courseSubTemp objectForKey:@"coursesubid"]];
                    courseSub.coursesubcontent = [NSString stringWithFormat:@"%@",[courseSubTemp objectForKey:@"coursesubcontent"]];
                    courseSub.coursesubday = [NSString stringWithFormat:@"%@",[courseSubTemp objectForKey:@"coursesubday"]];
                    courseSub.coursesubintrduce = [NSString stringWithFormat:@"%@",[courseSubTemp objectForKey:@"coursesubintroduce"]];
                    courseSub.coursesubtime = [NSString stringWithFormat:@"%@",[courseSubTemp objectForKey:@"coursesubtime"]];
                    courseSub.coursesubtitle = [NSString stringWithFormat:@"%@",[courseSubTemp objectForKey:@"coursesubtitle"]];
                    courseSub.coursesuborder = [NSNumber numberWithInt:[[NSString stringWithFormat:@"%@",[courseSubTemp objectForKey:@"coursesuborder"]]intValue]];
                    courseSub.coursesubtype = [NSString stringWithFormat:@"%@",[courseSubTemp objectForKey:@"coursesubtype"]];
                    
                    [array addObject:courseSub];
                }
                
            }
            course.coursesub = [NSSet setWithArray:array];
        }
        if (![Util isEmpty:[courseDiction objectForKey:@"teacher"]]) {
            FriendInfo *teacher = [FriendInfo MR_createEntity];
            NSDictionary *teacherDic = [courseDiction objectForKey:@"teacher"];
            teacher.friendbirthday = [Util isEmpty:[teacherDic objectForKey:@"teacherbirthday"]]?nil:[teacherDic objectForKey:@"teacherbirthday"];
            teacher.friendpointstudent = [Util isEmpty:[teacherDic objectForKey:@"teacherpointstudent"]]?nil:[teacherDic objectForKey:@"teacherpointstudent"];
            teacher.friendpointsystem = [Util isEmpty:[teacherDic objectForKey:@"teacherpointsystem"]]?nil:[teacherDic objectForKey:@"teacherpointsystem"];
            teacher.friendid = [NSString stringWithFormat:@"%@",[teacherDic objectForKey:@"teacherid"]];
            teacher.friendintrduce = [NSString stringWithFormat:@"%@",[teacherDic objectForKey:@"teacherintrduce"]];
            teacher.friendphoto = [NSString stringWithFormat:@"%@",[teacherDic objectForKey:@"teacherphoto"]];
            teacher.friendsex = [NSString stringWithFormat:@"%@",[teacherDic objectForKey:@"teachersex"]];
            teacher.friendname = [NSString stringWithFormat:@"%@",[teacherDic objectForKey:@"teachernickname"]];
            teacher.friendoverallappraisal = [NSString stringWithFormat:@"%@", [teacherDic objectForKey:@"have"]];
            teacher.friendattitudescore = [NSString stringWithFormat:@"%@", [teacherDic objectForKey:@"teaching_attitude"]];
            teacher.friendskillscore = [NSString stringWithFormat:@"%@", [teacherDic objectForKey:@"expertise"]];
            
            course.teacher = teacher;
        }
        [recommendCourse addObject:course];
    }
    
    UserData *userdata = [UserData shared];
    UserInfo *userinfo = userdata.userInfo;
    userinfo.recommendcourse = [NSSet setWithArray:recommendCourse];
    [[NSManagedObjectContext MR_defaultContext]MR_saveToPersistentStoreAndWait];
}

+ (void)courseDetailMineWith:(Course*)course success:(void(^)(id response))success failure:(void(^)(NSError *error))failure{
    
    UserData *userdata = [UserData shared];
    UserInfo *userinfo = userdata.userInfo;
    NSDictionary *parameter = [NSDictionary dictionaryWithObjectsAndKeys:userinfo.userid,@"userid",userinfo.usertoken,@"usertoken",course.courseid,@"courseid", nil];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",URL_BASE,URL_COURSE_COURSE_DETAILMINE];
    [NetWorking post:url params:parameter success:^(id response) {
        if (![Util isEmpty:[response objectForKey:@"data"]]) {
            //解析 获取userid和usertoken
            NSDictionary *courseDiction = [response objectForKey:@"data"];
            
            if (![Util isEmpty:[courseDiction objectForKey:@"course"]]) {
                NSDictionary *courseTemp = [courseDiction objectForKey:@"course"];
                course.courseapplynum = [NSString stringWithFormat:@"%@",[courseTemp objectForKey:@"courseapplynum"]];
                course.coursecount = [NSString stringWithFormat:@"%@",[courseTemp objectForKey:@"coursecount"]];
                course.courseday = [NSString stringWithFormat:@"%@",[courseTemp objectForKey:@"courseday"]];
                course.coursedifficultty = [NSString stringWithFormat:@"%@",[courseTemp objectForKey:@"coursedifficulty"]];
                course.coursefat = [NSString stringWithFormat:@"%@",[courseTemp objectForKey:@"coursefat"]];
                course.courseid = [NSString stringWithFormat:@"%@",[courseTemp objectForKey:@"courseid"]];
                course.courseintrduce = [NSString stringWithFormat:@"%@",[courseTemp objectForKey:@"courseintroduce"]];
                course.courseoldprice = [NSString stringWithFormat:@"%@",[courseTemp objectForKey:@"courseoldprice"]];
                course.coursephoto = [NSString stringWithFormat:@"%@",[courseTemp objectForKey:@"coursephoto"]];
                course.coursepowerdifficulty = [NSString stringWithFormat:@"%@",[courseTemp objectForKey:@"coursepowerdifficulty"]];
                course.courseprice = [NSString stringWithFormat:@"%@",[courseTemp objectForKey:@"courseprice"]];
                course.courseshaping = [NSString stringWithFormat:@"%@",[courseTemp objectForKey:@"courseshaping"]];
                course.coursestarttime = [NSString stringWithFormat:@"%@",[courseTemp objectForKey:@"coursestarttime"]];
                course.coursecreatedtime = [NSString stringWithFormat:@"%@", [courseTemp objectForKey:@"created_time"]];
                course.coursestate = [NSString stringWithFormat:@"%@",[courseTemp objectForKey:@"coursestate"]];
                course.coursestrength = [NSString stringWithFormat:@"%@",[courseTemp objectForKey:@"coursestrength"]];
                course.coursetarget = [NSString stringWithFormat:@"%@",[courseTemp objectForKey:@"coursetarget"]];
                course.coursetitle = [NSString stringWithFormat:@"%@",[courseTemp objectForKey:@"coursetitle"]];
                course.coursehastake = [NSString stringWithFormat:@"%@",[courseTemp objectForKey:@"coursehastake"]];
                course.courseisstart = [NSString stringWithFormat:@"%@", [courseTemp objectForKey:@"flag"]];
                course.courseisappraise = [NSString stringWithFormat:@"%@", [courseTemp objectForKey:@"seetype"]];
                course.coursebody = [NSString stringWithFormat:@"%@", [courseTemp objectForKey:@"parts"]];
                course.coursedetailimgage = [NSString stringWithFormat:@"%@", [courseTemp objectForKey:@"partsimg"]];
                if (![Util isEmpty:[courseTemp objectForKey:@"clubname"]]) {
                    course.courseofclub = [NSString stringWithFormat:@"%@", [courseTemp objectForKey:@"clubname"]];
                }
                else {
                    course.courseofclub = @"";
                }
            }
            NSArray *tempArray = [courseDiction objectForKey:@"coursesub"];
            if (tempArray.count > 0) {
                NSMutableArray *array = [[NSMutableArray alloc]init];
                for (NSDictionary *courseSub in [[courseDiction objectForKey:@"coursesub"] objectForKey:@"data"] ) {
                    for (NSDictionary *courseSubTemp in [courseSub objectForKey:@"data"]) {
                        CourseSub *courseSub = [CourseSub MR_createEntity];
                        courseSub.coursesubflag = [NSString stringWithFormat:@"%@",[courseSubTemp objectForKey:@"coursesubflag"]];
                        courseSub.coursesubid = [NSString stringWithFormat:@"%@",[courseSubTemp objectForKey:@"coursesubid"]];
                        courseSub.coursesubcontent = [NSString stringWithFormat:@"%@",[courseSubTemp objectForKey:@"coursesubcontent"]];
                        courseSub.coursesubday = [NSString stringWithFormat:@"%@",[courseSubTemp objectForKey:@"coursesubday"]];
                        courseSub.coursesubintrduce = [NSString stringWithFormat:@"%@",[courseSubTemp objectForKey:@"coursesubintroduce"]];
                        courseSub.coursesubtime = [NSString stringWithFormat:@"%@",[courseSubTemp objectForKey:@"coursesubtime"]];
                        courseSub.coursesubtitle = [NSString stringWithFormat:@"%@",[courseSubTemp objectForKey:@"coursesubtitle"]];
                        courseSub.coursesuborder = [NSNumber numberWithInt:[[NSString stringWithFormat:@"%@",[courseSubTemp objectForKey:@"coursesuborder"]]intValue]];
                        courseSub.coursesubtype = [NSString stringWithFormat:@"%@",[courseSubTemp objectForKey:@"coursesubtype"]];
                        
                        [array addObject:courseSub];
                    }

                }
                course.coursesub = [NSSet setWithArray:array];
            }
            if (![Util isEmpty:[courseDiction objectForKey:@"teacher"]]) {
                FriendInfo *teacher = [FriendInfo MR_createEntity];
                NSDictionary *teacherDic = [courseDiction objectForKey:@"teacher"];
                teacher.friendbirthday = [Util isEmpty:[teacherDic objectForKey:@"teacherbirthday"]]?nil:[teacherDic objectForKey:@"teacherbirthday"];
                teacher.friendpointstudent = [Util isEmpty:[teacherDic objectForKey:@"teacherpointstudent"]]?nil:[teacherDic objectForKey:@"teacherpointstudent"];
                teacher.friendpointsystem = [Util isEmpty:[teacherDic objectForKey:@"teacherpointsystem"]]?nil:[teacherDic objectForKey:@"teacherpointsystem"];
                teacher.friendid = [NSString stringWithFormat:@"%@",[teacherDic objectForKey:@"teacherid"]];
                teacher.friendintrduce = [NSString stringWithFormat:@"%@",[teacherDic objectForKey:@"teacherintrduce"]];
                teacher.friendphoto = [NSString stringWithFormat:@"%@",[teacherDic objectForKey:@"teacherphoto"]];
                teacher.friendsex = [NSString stringWithFormat:@"%@",[teacherDic objectForKey:@"teachersex"]];
                teacher.friendname = [NSString stringWithFormat:@"%@",[teacherDic objectForKey:@"teachernickname"]];
                teacher.friendoverallappraisal = [NSString stringWithFormat:@"%@", [teacherDic objectForKey:@"have"]];
                teacher.friendattitudescore = [NSString stringWithFormat:@"%@", [teacherDic objectForKey:@"teaching_attitude"]];
                teacher.friendskillscore = [NSString stringWithFormat:@"%@", [teacherDic objectForKey:@"expertise"]];
                
                course.teacher = teacher;
            }
            [[NSManagedObjectContext MR_defaultContext]MR_saveToPersistentStoreAndWait];
        }
        success(response);
    } failure:^(NSError *error) {
        
    }];
}

+ (void)applyCourseWith:(NSString*)courseid success:(void(^)(id response))success failure:(void(^)(NSError *error))failure{
    
    UserData *userdata = [UserData shared];
    UserInfo *userinfo = userdata.userInfo;
    NSDictionary *parameter = [NSDictionary dictionaryWithObjectsAndKeys:userinfo.userid,@"userid",userinfo.usertoken,@"usertoken",courseid,@"courseid", nil];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",URL_BASE,URL_COURSE_COURSE_APPLY];
    [NetWorking post:url params:parameter success:^(id response) {
        if (success) {
            success(response);
        }
    } failure:^(NSError *error) {
        if (error) {
            failure(error);
        }
    }];
}
+ (void)applyCourse:(NSDictionary*)parameter success:(void(^)(id response))success failure:(void(^)(NSError *error))failure{
    
    NSString *url = [NSString stringWithFormat:@"%@%@",URL_BASE,URL_COURSE_COURSE_APPLY_REAL];
    [NetWorking post:url params:parameter success:^(id response) {
        if (success) {
            success(response);
        }
    } failure:^(NSError *error) {
        if (error) {
            failure(error);
        }
    }];
}
+ (void)finishCourseSubWith:(NSDictionary*)parameter success:(void(^)(id response))success failure:(void(^)(NSError *error))failure{
    NSString *url = [NSString stringWithFormat:@"%@%@",URL_BASE,URL_COURSE_COURSESUB_FINISH];
    [NetWorking post:url params:parameter success:^(id response) {
        if (success) {
            success(response);
        }
    } failure:^(NSError *error) {
        if (error) {
            failure(error);
        }
    }];
}

+ (void)studentCourseWith:(NSString*)courseid success:(void(^)(id response))success failure:(void(^)(NSError *error))failure{
    UserData *userdata = [UserData shared];
    UserInfo *userinfo = userdata.userInfo;
    NSDictionary *parameter = [NSDictionary dictionaryWithObjectsAndKeys:userinfo.userid,@"userid",userinfo.usertoken,@"usertoken",courseid,@"courseid", nil];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",URL_BASE,URL_COURSE_STUDENT_LIST];
    [NetWorking post:url params:parameter success:^(id response) {
        
        if (![Util isEmpty:[response objectForKey:@"data"]]) {
                
                NSMutableArray *studentArray = [[NSMutableArray alloc]init];
                for (NSDictionary *studentDiction in [response objectForKey:@"data"]) {
                    StudentEntity *entity = [[StudentEntity alloc]init];
                    entity.studentid = [studentDiction objectForKey:@"id"];
                    entity.studentbirthday = [studentDiction objectForKey:@"birthday"];
                    entity.studentintrduce = [studentDiction objectForKey:@"introduce"];
                    entity.studentname = [studentDiction objectForKey:@"nickname"];
                    entity.studentphoto = [studentDiction objectForKey:@"portrait"];
                    entity.studentsex = [studentDiction objectForKey:@"sex"];
                    [studentArray addObject:entity];
                }
                if (success) {
                    success(studentArray);
                }
        }
    } failure:^(NSError *error) {
        if (error) {
            failure(error);
        }
    }];
}

+ (void)createCourseInteractionWith:(NSDictionary *)parameter success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    NSString *url = [NSString stringWithFormat:@"%@%@", URL_BASE,URL_CREATEINTERACTION];
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
+ (void)courseInteractionListWith:(NSDictionary *)parameter success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    NSString *url = [NSString stringWithFormat:@"%@%@", URL_BASE,URL_COURSEINTERACTIONLIST];
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

+ (void)deleteCourseInteractionWith:(NSDictionary *)parameter success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    NSString *url = [NSString stringWithFormat:@"%@%@", URL_BASE,URL_DELETECOURSEINTERACTION];
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

+ (void)courseInteractionDetailWith:(NSDictionary *)parameter success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    NSString *url = [NSString stringWithFormat:@"%@%@", URL_BASE,URL_COURSEINTERACTIONDETAIL];
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

+ (void)courseInteractionCommentWith:(NSDictionary *)parameter success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    NSString *url = [NSString stringWithFormat:@"%@%@", URL_BASE,URL_COURSEINTERACTIONCOMMENT];
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
+ (void)courseInteractionReplyWith:(NSDictionary *)parameter success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    NSString *url = [NSString stringWithFormat:@"%@%@", URL_BASE,URL_COURSEINTERACTIONREPLY];
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

+ (void)myCourseInteractionsWith:(NSDictionary *)parameter success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    NSString *url = [NSString stringWithFormat:@"%@%@", URL_BASE, URL_MYCOURSEINTERACTIONS];
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

+ (void)courseQAListWith:(NSString*)courseid success:(void(^)(id response))success failure:(void(^)(NSError *error))failure{
    UserData *userdata = [UserData shared];
    UserInfo *userinfo = userdata.userInfo;
    NSDictionary *parameter = [NSDictionary dictionaryWithObjectsAndKeys:userinfo.userid,@"userid",userinfo.usertoken,@"usertoken",courseid,@"courseid", nil];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",URL_BASE,URL_COURSE_QA_LIST];
    [NetWorking post:url params:parameter success:^(id response) {
        if (![Util isEmpty:[response objectForKey:@"data"]]) {
            NSMutableArray *qalist = [[NSMutableArray alloc]init];
            for (NSDictionary *tempDic in [response objectForKey:@"data"]) {
                CourseQAEntity *entity = [[CourseQAEntity alloc]init];
                NSDictionary *questionDiction = [tempDic objectForKey:@"consult"];
                
                entity.questionid = [NSString stringWithFormat:@"%@",[questionDiction objectForKey:@"id"]];
                entity.questioncontent = [NSString stringWithFormat:@"%@",[questionDiction objectForKey:@"consultcontent"]];
                entity.questiontime = [questionDiction objectForKey:@"created_time"];
                entity.questionuserid = [NSString stringWithFormat:@"%@",[questionDiction objectForKey:@"consultuserid"]];
                entity.questionusername = [NSString stringWithFormat:@"%@",[questionDiction objectForKey:@"nickname"]];
                
                NSArray *answerArray = [tempDic objectForKey:@"cpartak"];
                if ([answerArray isEqual:[NSNull null]] || answerArray.count == 0) {
                    entity.questionhasanswer = @"2";
                }else{
                    entity.questionhasanswer = @"1";
                }
                for (NSDictionary *answerDictionary in answerArray) {
                    
                    AnswerEntity *answer = [[AnswerEntity alloc]init];
                    answer.answerContent = [NSString stringWithFormat:@"%@",[answerDictionary objectForKey:@"answercontent"]];
                    answer.answerTime = [NSString stringWithFormat:@"%@",[answerDictionary objectForKey:@"created_time"]];
                    answer.answerid = [NSString stringWithFormat:@"%@",[answerDictionary objectForKey:@"answerid"]];
                    [entity.answerArray addObject:answer];
                }
                [qalist addObject:entity];
            }
            if (success) {
                success(qalist);
            }
        }
    } failure:^(NSError *error) {
        if (error) {
            failure(error);
        }
    }];
}

+ (void)courseQuestionWith:(NSDictionary*)parameter success:(void(^)(id response))success failure:(void(^)(NSError *error))failure{
    NSString *url = [NSString stringWithFormat:@"%@%@",URL_BASE,URL_COURSE_QA_QUESTION];
    [NetWorking post:url params:parameter success:^(id response) {
        if (![Util isEmpty:[response objectForKey:@"data"]]) {
            
        }if (success) {
            success(response);
        }
    } failure:^(NSError *error) {
        if (error) {
            failure(error);
        }
    }];
}


+ (void)courseAnswerWith:(NSDictionary*)parameter success:(void(^)(id response))success failure:(void(^)(NSError *error))failure{
    NSString *url = [NSString stringWithFormat:@"%@%@",URL_BASE,URL_COURSE_QA_ANSWER];
    [NetWorking post:url params:parameter success:^(id response) {
        if (![Util isEmpty:[response objectForKey:@"data"]]) {
            
        }if (success) {
            success(response);
        }
    } failure:^(NSError *error) {
        if (error) {
            failure(error);
        }
    }];
}

@end
