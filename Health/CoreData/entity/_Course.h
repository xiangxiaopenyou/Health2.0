// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Course.h instead.

#import <CoreData/CoreData.h>

extern const struct CourseAttributes {
	__unsafe_unretained NSString *courseapplynum;
	__unsafe_unretained NSString *coursebody;
	__unsafe_unretained NSString *coursecount;
	__unsafe_unretained NSString *coursecreatedtime;
	__unsafe_unretained NSString *courseday;
	__unsafe_unretained NSString *coursedetailimgage;
	__unsafe_unretained NSString *coursedifficultty;
	__unsafe_unretained NSString *coursefat;
	__unsafe_unretained NSString *coursehastake;
	__unsafe_unretained NSString *courseid;
	__unsafe_unretained NSString *courseintrduce;
	__unsafe_unretained NSString *courseisappraise;
	__unsafe_unretained NSString *courseisstart;
	__unsafe_unretained NSString *courseofclub;
	__unsafe_unretained NSString *courseoldprice;
	__unsafe_unretained NSString *courseownerid;
	__unsafe_unretained NSString *coursephoto;
	__unsafe_unretained NSString *coursepowerdifficulty;
	__unsafe_unretained NSString *courseprice;
	__unsafe_unretained NSString *courseshaping;
	__unsafe_unretained NSString *coursesign;
	__unsafe_unretained NSString *coursestarttime;
	__unsafe_unretained NSString *coursestate;
	__unsafe_unretained NSString *coursestrength;
	__unsafe_unretained NSString *coursetarget;
	__unsafe_unretained NSString *coursetitle;
} CourseAttributes;

extern const struct CourseRelationships {
	__unsafe_unretained NSString *coursesub;
	__unsafe_unretained NSString *teacher;
	__unsafe_unretained NSString *userinfo;
	__unsafe_unretained NSString *userinforecommend;
} CourseRelationships;

@class CourseSub;
@class FriendInfo;
@class UserInfo;
@class UserInfo;

@interface CourseID : NSManagedObjectID {}
@end

@interface _Course : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) CourseID* objectID;

@property (nonatomic, strong) NSString* courseapplynum;

//- (BOOL)validateCourseapplynum:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* coursebody;

//- (BOOL)validateCoursebody:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* coursecount;

//- (BOOL)validateCoursecount:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* coursecreatedtime;

//- (BOOL)validateCoursecreatedtime:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* courseday;

//- (BOOL)validateCourseday:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* coursedetailimgage;

//- (BOOL)validateCoursedetailimgage:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* coursedifficultty;

//- (BOOL)validateCoursedifficultty:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* coursefat;

//- (BOOL)validateCoursefat:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* coursehastake;

//- (BOOL)validateCoursehastake:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* courseid;

//- (BOOL)validateCourseid:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* courseintrduce;

//- (BOOL)validateCourseintrduce:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* courseisappraise;

//- (BOOL)validateCourseisappraise:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* courseisstart;

//- (BOOL)validateCourseisstart:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* courseofclub;

//- (BOOL)validateCourseofclub:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* courseoldprice;

//- (BOOL)validateCourseoldprice:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* courseownerid;

//- (BOOL)validateCourseownerid:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* coursephoto;

//- (BOOL)validateCoursephoto:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* coursepowerdifficulty;

//- (BOOL)validateCoursepowerdifficulty:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* courseprice;

//- (BOOL)validateCourseprice:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* courseshaping;

//- (BOOL)validateCourseshaping:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* coursesign;

//- (BOOL)validateCoursesign:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* coursestarttime;

//- (BOOL)validateCoursestarttime:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* coursestate;

//- (BOOL)validateCoursestate:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* coursestrength;

//- (BOOL)validateCoursestrength:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* coursetarget;

//- (BOOL)validateCoursetarget:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* coursetitle;

//- (BOOL)validateCoursetitle:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSSet *coursesub;

- (NSMutableSet*)coursesubSet;

@property (nonatomic, strong) FriendInfo *teacher;

//- (BOOL)validateTeacher:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) UserInfo *userinfo;

//- (BOOL)validateUserinfo:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) UserInfo *userinforecommend;

//- (BOOL)validateUserinforecommend:(id*)value_ error:(NSError**)error_;

@end

@interface _Course (CoursesubCoreDataGeneratedAccessors)
- (void)addCoursesub:(NSSet*)value_;
- (void)removeCoursesub:(NSSet*)value_;
- (void)addCoursesubObject:(CourseSub*)value_;
- (void)removeCoursesubObject:(CourseSub*)value_;

@end

@interface _Course (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveCourseapplynum;
- (void)setPrimitiveCourseapplynum:(NSString*)value;

- (NSString*)primitiveCoursebody;
- (void)setPrimitiveCoursebody:(NSString*)value;

- (NSString*)primitiveCoursecount;
- (void)setPrimitiveCoursecount:(NSString*)value;

- (NSString*)primitiveCoursecreatedtime;
- (void)setPrimitiveCoursecreatedtime:(NSString*)value;

- (NSString*)primitiveCourseday;
- (void)setPrimitiveCourseday:(NSString*)value;

- (NSString*)primitiveCoursedetailimgage;
- (void)setPrimitiveCoursedetailimgage:(NSString*)value;

- (NSString*)primitiveCoursedifficultty;
- (void)setPrimitiveCoursedifficultty:(NSString*)value;

- (NSString*)primitiveCoursefat;
- (void)setPrimitiveCoursefat:(NSString*)value;

- (NSString*)primitiveCoursehastake;
- (void)setPrimitiveCoursehastake:(NSString*)value;

- (NSString*)primitiveCourseid;
- (void)setPrimitiveCourseid:(NSString*)value;

- (NSString*)primitiveCourseintrduce;
- (void)setPrimitiveCourseintrduce:(NSString*)value;

- (NSString*)primitiveCourseisappraise;
- (void)setPrimitiveCourseisappraise:(NSString*)value;

- (NSString*)primitiveCourseisstart;
- (void)setPrimitiveCourseisstart:(NSString*)value;

- (NSString*)primitiveCourseofclub;
- (void)setPrimitiveCourseofclub:(NSString*)value;

- (NSString*)primitiveCourseoldprice;
- (void)setPrimitiveCourseoldprice:(NSString*)value;

- (NSString*)primitiveCourseownerid;
- (void)setPrimitiveCourseownerid:(NSString*)value;

- (NSString*)primitiveCoursephoto;
- (void)setPrimitiveCoursephoto:(NSString*)value;

- (NSString*)primitiveCoursepowerdifficulty;
- (void)setPrimitiveCoursepowerdifficulty:(NSString*)value;

- (NSString*)primitiveCourseprice;
- (void)setPrimitiveCourseprice:(NSString*)value;

- (NSString*)primitiveCourseshaping;
- (void)setPrimitiveCourseshaping:(NSString*)value;

- (NSString*)primitiveCoursesign;
- (void)setPrimitiveCoursesign:(NSString*)value;

- (NSString*)primitiveCoursestarttime;
- (void)setPrimitiveCoursestarttime:(NSString*)value;

- (NSString*)primitiveCoursestate;
- (void)setPrimitiveCoursestate:(NSString*)value;

- (NSString*)primitiveCoursestrength;
- (void)setPrimitiveCoursestrength:(NSString*)value;

- (NSString*)primitiveCoursetarget;
- (void)setPrimitiveCoursetarget:(NSString*)value;

- (NSString*)primitiveCoursetitle;
- (void)setPrimitiveCoursetitle:(NSString*)value;

- (NSMutableSet*)primitiveCoursesub;
- (void)setPrimitiveCoursesub:(NSMutableSet*)value;

- (FriendInfo*)primitiveTeacher;
- (void)setPrimitiveTeacher:(FriendInfo*)value;

- (UserInfo*)primitiveUserinfo;
- (void)setPrimitiveUserinfo:(UserInfo*)value;

- (UserInfo*)primitiveUserinforecommend;
- (void)setPrimitiveUserinforecommend:(UserInfo*)value;

@end
