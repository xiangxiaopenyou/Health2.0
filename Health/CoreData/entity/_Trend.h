// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Trend.h instead.

#import <CoreData/CoreData.h>

extern const struct TrendAttributes {
	__unsafe_unretained NSString *couseid;
	__unsafe_unretained NSString *islike;
	__unsafe_unretained NSString *ispublic;
	__unsafe_unretained NSString *picTag;
	__unsafe_unretained NSString *trendcommentnumber;
	__unsafe_unretained NSString *trendcomments;
	__unsafe_unretained NSString *trendcontent;
	__unsafe_unretained NSString *trendid;
	__unsafe_unretained NSString *trendlikemember;
	__unsafe_unretained NSString *trendlikenumber;
	__unsafe_unretained NSString *trendphoto;
	__unsafe_unretained NSString *trendsportstype;
	__unsafe_unretained NSString *trendtime;
	__unsafe_unretained NSString *trendtype;
	__unsafe_unretained NSString *useraddress;
	__unsafe_unretained NSString *userheaderphoto;
	__unsafe_unretained NSString *userid;
	__unsafe_unretained NSString *usernickname;
	__unsafe_unretained NSString *usersex;
	__unsafe_unretained NSString *usertype;
} TrendAttributes;

extern const struct TrendRelationships {
	__unsafe_unretained NSString *trendcomment;
	__unsafe_unretained NSString *trendsofall;
} TrendRelationships;

@class TrendComment;
@class UserInfo;

@interface TrendID : NSManagedObjectID {}
@end

@interface _Trend : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) TrendID* objectID;

@property (nonatomic, strong) NSString* couseid;

//- (BOOL)validateCouseid:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* islike;

//- (BOOL)validateIslike:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* ispublic;

//- (BOOL)validateIspublic:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* picTag;

//- (BOOL)validatePicTag:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* trendcommentnumber;

//- (BOOL)validateTrendcommentnumber:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* trendcomments;

//- (BOOL)validateTrendcomments:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* trendcontent;

//- (BOOL)validateTrendcontent:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* trendid;

//- (BOOL)validateTrendid:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* trendlikemember;

//- (BOOL)validateTrendlikemember:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* trendlikenumber;

//- (BOOL)validateTrendlikenumber:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* trendphoto;

//- (BOOL)validateTrendphoto:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* trendsportstype;

//- (BOOL)validateTrendsportstype:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* trendtime;

//- (BOOL)validateTrendtime:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* trendtype;

//- (BOOL)validateTrendtype:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* useraddress;

//- (BOOL)validateUseraddress:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* userheaderphoto;

//- (BOOL)validateUserheaderphoto:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* userid;

//- (BOOL)validateUserid:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* usernickname;

//- (BOOL)validateUsernickname:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* usersex;

//- (BOOL)validateUsersex:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* usertype;

//- (BOOL)validateUsertype:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSSet *trendcomment;

- (NSMutableSet*)trendcommentSet;

@property (nonatomic, strong) UserInfo *trendsofall;

//- (BOOL)validateTrendsofall:(id*)value_ error:(NSError**)error_;

@end

@interface _Trend (TrendcommentCoreDataGeneratedAccessors)
- (void)addTrendcomment:(NSSet*)value_;
- (void)removeTrendcomment:(NSSet*)value_;
- (void)addTrendcommentObject:(TrendComment*)value_;
- (void)removeTrendcommentObject:(TrendComment*)value_;

@end

@interface _Trend (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveCouseid;
- (void)setPrimitiveCouseid:(NSString*)value;

- (NSString*)primitiveIslike;
- (void)setPrimitiveIslike:(NSString*)value;

- (NSString*)primitiveIspublic;
- (void)setPrimitiveIspublic:(NSString*)value;

- (NSString*)primitivePicTag;
- (void)setPrimitivePicTag:(NSString*)value;

- (NSString*)primitiveTrendcommentnumber;
- (void)setPrimitiveTrendcommentnumber:(NSString*)value;

- (NSString*)primitiveTrendcomments;
- (void)setPrimitiveTrendcomments:(NSString*)value;

- (NSString*)primitiveTrendcontent;
- (void)setPrimitiveTrendcontent:(NSString*)value;

- (NSString*)primitiveTrendid;
- (void)setPrimitiveTrendid:(NSString*)value;

- (NSString*)primitiveTrendlikemember;
- (void)setPrimitiveTrendlikemember:(NSString*)value;

- (NSString*)primitiveTrendlikenumber;
- (void)setPrimitiveTrendlikenumber:(NSString*)value;

- (NSString*)primitiveTrendphoto;
- (void)setPrimitiveTrendphoto:(NSString*)value;

- (NSString*)primitiveTrendsportstype;
- (void)setPrimitiveTrendsportstype:(NSString*)value;

- (NSString*)primitiveTrendtime;
- (void)setPrimitiveTrendtime:(NSString*)value;

- (NSString*)primitiveTrendtype;
- (void)setPrimitiveTrendtype:(NSString*)value;

- (NSString*)primitiveUseraddress;
- (void)setPrimitiveUseraddress:(NSString*)value;

- (NSString*)primitiveUserheaderphoto;
- (void)setPrimitiveUserheaderphoto:(NSString*)value;

- (NSString*)primitiveUserid;
- (void)setPrimitiveUserid:(NSString*)value;

- (NSString*)primitiveUsernickname;
- (void)setPrimitiveUsernickname:(NSString*)value;

- (NSString*)primitiveUsersex;
- (void)setPrimitiveUsersex:(NSString*)value;

- (NSString*)primitiveUsertype;
- (void)setPrimitiveUsertype:(NSString*)value;

- (NSMutableSet*)primitiveTrendcomment;
- (void)setPrimitiveTrendcomment:(NSMutableSet*)value;

- (UserInfo*)primitiveTrendsofall;
- (void)setPrimitiveTrendsofall:(UserInfo*)value;

@end
