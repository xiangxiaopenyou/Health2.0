// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to UserInfo.h instead.

#import <CoreData/CoreData.h>

extern const struct UserInfoAttributes {
	__unsafe_unretained NSString *balance;
	__unsafe_unretained NSString *goodat;
	__unsafe_unretained NSString *isnewuser;
	__unsafe_unretained NSString *myfeans;
	__unsafe_unretained NSString *myfollow;
	__unsafe_unretained NSString *rongyunid;
	__unsafe_unretained NSString *rongyunportrait;
	__unsafe_unretained NSString *skillpoint;
	__unsafe_unretained NSString *teacherpoint;
	__unsafe_unretained NSString *totalmoney;
	__unsafe_unretained NSString *type;
	__unsafe_unretained NSString *userarea;
	__unsafe_unretained NSString *userbirthday;
	__unsafe_unretained NSString *userbodyphoto;
	__unsafe_unretained NSString *userheight;
	__unsafe_unretained NSString *userid;
	__unsafe_unretained NSString *userintrduce;
	__unsafe_unretained NSString *userlike;
	__unsafe_unretained NSString *username;
	__unsafe_unretained NSString *userphoto;
	__unsafe_unretained NSString *usersex;
	__unsafe_unretained NSString *usersycle;
	__unsafe_unretained NSString *usertargetweight;
	__unsafe_unretained NSString *usertelphone;
	__unsafe_unretained NSString *usertoken;
	__unsafe_unretained NSString *usertype;
	__unsafe_unretained NSString *userweight;
} UserInfoAttributes;

extern const struct UserInfoRelationships {
	__unsafe_unretained NSString *alltrends;
	__unsafe_unretained NSString *minecourse;
	__unsafe_unretained NSString *myevaluatedcourse;
	__unsafe_unretained NSString *myfinishedcourse;
	__unsafe_unretained NSString *recommendcourse;
} UserInfoRelationships;

@class Trend;
@class Course;
@class Course;
@class Course;
@class Course;

@interface UserInfoID : NSManagedObjectID {}
@end

@interface _UserInfo : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) UserInfoID* objectID;

@property (nonatomic, strong) NSString* balance;

//- (BOOL)validateBalance:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* goodat;

//- (BOOL)validateGoodat:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* isnewuser;

//- (BOOL)validateIsnewuser:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* myfeans;

//- (BOOL)validateMyfeans:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* myfollow;

//- (BOOL)validateMyfollow:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* rongyunid;

//- (BOOL)validateRongyunid:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* rongyunportrait;

//- (BOOL)validateRongyunportrait:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* skillpoint;

//- (BOOL)validateSkillpoint:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* teacherpoint;

//- (BOOL)validateTeacherpoint:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* totalmoney;

//- (BOOL)validateTotalmoney:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* type;

//- (BOOL)validateType:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* userarea;

//- (BOOL)validateUserarea:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* userbirthday;

//- (BOOL)validateUserbirthday:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* userbodyphoto;

//- (BOOL)validateUserbodyphoto:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* userheight;

//- (BOOL)validateUserheight:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* userid;

//- (BOOL)validateUserid:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* userintrduce;

//- (BOOL)validateUserintrduce:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* userlike;

//- (BOOL)validateUserlike:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* username;

//- (BOOL)validateUsername:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* userphoto;

//- (BOOL)validateUserphoto:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* usersex;

//- (BOOL)validateUsersex:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* usersycle;

//- (BOOL)validateUsersycle:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* usertargetweight;

//- (BOOL)validateUsertargetweight:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* usertelphone;

//- (BOOL)validateUsertelphone:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* usertoken;

//- (BOOL)validateUsertoken:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* usertype;

//- (BOOL)validateUsertype:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* userweight;

//- (BOOL)validateUserweight:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSSet *alltrends;

- (NSMutableSet*)alltrendsSet;

@property (nonatomic, strong) NSSet *minecourse;

- (NSMutableSet*)minecourseSet;

@property (nonatomic, strong) NSSet *myevaluatedcourse;

- (NSMutableSet*)myevaluatedcourseSet;

@property (nonatomic, strong) NSSet *myfinishedcourse;

- (NSMutableSet*)myfinishedcourseSet;

@property (nonatomic, strong) NSSet *recommendcourse;

- (NSMutableSet*)recommendcourseSet;

@end

@interface _UserInfo (AlltrendsCoreDataGeneratedAccessors)
- (void)addAlltrends:(NSSet*)value_;
- (void)removeAlltrends:(NSSet*)value_;
- (void)addAlltrendsObject:(Trend*)value_;
- (void)removeAlltrendsObject:(Trend*)value_;

@end

@interface _UserInfo (MinecourseCoreDataGeneratedAccessors)
- (void)addMinecourse:(NSSet*)value_;
- (void)removeMinecourse:(NSSet*)value_;
- (void)addMinecourseObject:(Course*)value_;
- (void)removeMinecourseObject:(Course*)value_;

@end

@interface _UserInfo (MyevaluatedcourseCoreDataGeneratedAccessors)
- (void)addMyevaluatedcourse:(NSSet*)value_;
- (void)removeMyevaluatedcourse:(NSSet*)value_;
- (void)addMyevaluatedcourseObject:(Course*)value_;
- (void)removeMyevaluatedcourseObject:(Course*)value_;

@end

@interface _UserInfo (MyfinishedcourseCoreDataGeneratedAccessors)
- (void)addMyfinishedcourse:(NSSet*)value_;
- (void)removeMyfinishedcourse:(NSSet*)value_;
- (void)addMyfinishedcourseObject:(Course*)value_;
- (void)removeMyfinishedcourseObject:(Course*)value_;

@end

@interface _UserInfo (RecommendcourseCoreDataGeneratedAccessors)
- (void)addRecommendcourse:(NSSet*)value_;
- (void)removeRecommendcourse:(NSSet*)value_;
- (void)addRecommendcourseObject:(Course*)value_;
- (void)removeRecommendcourseObject:(Course*)value_;

@end

@interface _UserInfo (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveBalance;
- (void)setPrimitiveBalance:(NSString*)value;

- (NSString*)primitiveGoodat;
- (void)setPrimitiveGoodat:(NSString*)value;

- (NSString*)primitiveIsnewuser;
- (void)setPrimitiveIsnewuser:(NSString*)value;

- (NSString*)primitiveMyfeans;
- (void)setPrimitiveMyfeans:(NSString*)value;

- (NSString*)primitiveMyfollow;
- (void)setPrimitiveMyfollow:(NSString*)value;

- (NSString*)primitiveRongyunid;
- (void)setPrimitiveRongyunid:(NSString*)value;

- (NSString*)primitiveRongyunportrait;
- (void)setPrimitiveRongyunportrait:(NSString*)value;

- (NSString*)primitiveSkillpoint;
- (void)setPrimitiveSkillpoint:(NSString*)value;

- (NSString*)primitiveTeacherpoint;
- (void)setPrimitiveTeacherpoint:(NSString*)value;

- (NSString*)primitiveTotalmoney;
- (void)setPrimitiveTotalmoney:(NSString*)value;

- (NSString*)primitiveUserarea;
- (void)setPrimitiveUserarea:(NSString*)value;

- (NSString*)primitiveUserbirthday;
- (void)setPrimitiveUserbirthday:(NSString*)value;

- (NSString*)primitiveUserbodyphoto;
- (void)setPrimitiveUserbodyphoto:(NSString*)value;

- (NSString*)primitiveUserheight;
- (void)setPrimitiveUserheight:(NSString*)value;

- (NSString*)primitiveUserid;
- (void)setPrimitiveUserid:(NSString*)value;

- (NSString*)primitiveUserintrduce;
- (void)setPrimitiveUserintrduce:(NSString*)value;

- (NSString*)primitiveUserlike;
- (void)setPrimitiveUserlike:(NSString*)value;

- (NSString*)primitiveUsername;
- (void)setPrimitiveUsername:(NSString*)value;

- (NSString*)primitiveUserphoto;
- (void)setPrimitiveUserphoto:(NSString*)value;

- (NSString*)primitiveUsersex;
- (void)setPrimitiveUsersex:(NSString*)value;

- (NSString*)primitiveUsersycle;
- (void)setPrimitiveUsersycle:(NSString*)value;

- (NSString*)primitiveUsertargetweight;
- (void)setPrimitiveUsertargetweight:(NSString*)value;

- (NSString*)primitiveUsertelphone;
- (void)setPrimitiveUsertelphone:(NSString*)value;

- (NSString*)primitiveUsertoken;
- (void)setPrimitiveUsertoken:(NSString*)value;

- (NSString*)primitiveUsertype;
- (void)setPrimitiveUsertype:(NSString*)value;

- (NSString*)primitiveUserweight;
- (void)setPrimitiveUserweight:(NSString*)value;

- (NSMutableSet*)primitiveAlltrends;
- (void)setPrimitiveAlltrends:(NSMutableSet*)value;

- (NSMutableSet*)primitiveMinecourse;
- (void)setPrimitiveMinecourse:(NSMutableSet*)value;

- (NSMutableSet*)primitiveMyevaluatedcourse;
- (void)setPrimitiveMyevaluatedcourse:(NSMutableSet*)value;

- (NSMutableSet*)primitiveMyfinishedcourse;
- (void)setPrimitiveMyfinishedcourse:(NSMutableSet*)value;

- (NSMutableSet*)primitiveRecommendcourse;
- (void)setPrimitiveRecommendcourse:(NSMutableSet*)value;

@end
