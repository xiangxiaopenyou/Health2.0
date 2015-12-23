// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to FriendInfo.h instead.

#import <CoreData/CoreData.h>

extern const struct FriendInfoAttributes {
	__unsafe_unretained NSString *friendattitudescore;
	__unsafe_unretained NSString *friendbirthday;
	__unsafe_unretained NSString *friendid;
	__unsafe_unretained NSString *friendintrduce;
	__unsafe_unretained NSString *friendname;
	__unsafe_unretained NSString *friendoverallappraisal;
	__unsafe_unretained NSString *friendphoto;
	__unsafe_unretained NSString *friendpointstudent;
	__unsafe_unretained NSString *friendpointsystem;
	__unsafe_unretained NSString *friendsex;
	__unsafe_unretained NSString *friendskillscore;
	__unsafe_unretained NSString *friendtype;
} FriendInfoAttributes;

extern const struct FriendInfoRelationships {
	__unsafe_unretained NSString *teacherofcourse;
} FriendInfoRelationships;

@class Course;

@interface FriendInfoID : NSManagedObjectID {}
@end

@interface _FriendInfo : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) FriendInfoID* objectID;

@property (nonatomic, strong) NSString* friendattitudescore;

//- (BOOL)validateFriendattitudescore:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* friendbirthday;

//- (BOOL)validateFriendbirthday:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* friendid;

//- (BOOL)validateFriendid:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* friendintrduce;

//- (BOOL)validateFriendintrduce:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* friendname;

//- (BOOL)validateFriendname:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* friendoverallappraisal;

//- (BOOL)validateFriendoverallappraisal:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* friendphoto;

//- (BOOL)validateFriendphoto:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* friendpointstudent;

//- (BOOL)validateFriendpointstudent:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* friendpointsystem;

//- (BOOL)validateFriendpointsystem:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* friendsex;

//- (BOOL)validateFriendsex:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* friendskillscore;

//- (BOOL)validateFriendskillscore:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* friendtype;

//- (BOOL)validateFriendtype:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) Course *teacherofcourse;

//- (BOOL)validateTeacherofcourse:(id*)value_ error:(NSError**)error_;

@end

@interface _FriendInfo (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveFriendattitudescore;
- (void)setPrimitiveFriendattitudescore:(NSString*)value;

- (NSString*)primitiveFriendbirthday;
- (void)setPrimitiveFriendbirthday:(NSString*)value;

- (NSString*)primitiveFriendid;
- (void)setPrimitiveFriendid:(NSString*)value;

- (NSString*)primitiveFriendintrduce;
- (void)setPrimitiveFriendintrduce:(NSString*)value;

- (NSString*)primitiveFriendname;
- (void)setPrimitiveFriendname:(NSString*)value;

- (NSString*)primitiveFriendoverallappraisal;
- (void)setPrimitiveFriendoverallappraisal:(NSString*)value;

- (NSString*)primitiveFriendphoto;
- (void)setPrimitiveFriendphoto:(NSString*)value;

- (NSString*)primitiveFriendpointstudent;
- (void)setPrimitiveFriendpointstudent:(NSString*)value;

- (NSString*)primitiveFriendpointsystem;
- (void)setPrimitiveFriendpointsystem:(NSString*)value;

- (NSString*)primitiveFriendsex;
- (void)setPrimitiveFriendsex:(NSString*)value;

- (NSString*)primitiveFriendskillscore;
- (void)setPrimitiveFriendskillscore:(NSString*)value;

- (NSString*)primitiveFriendtype;
- (void)setPrimitiveFriendtype:(NSString*)value;

- (Course*)primitiveTeacherofcourse;
- (void)setPrimitiveTeacherofcourse:(Course*)value;

@end
