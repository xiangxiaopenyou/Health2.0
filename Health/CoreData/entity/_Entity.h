// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Entity.h instead.

#import <CoreData/CoreData.h>

extern const struct EntityAttributes {
	__unsafe_unretained NSString *commentcontent;
	__unsafe_unretained NSString *commentid;
	__unsafe_unretained NSString *commentuserid;
	__unsafe_unretained NSString *commentusernickname;
	__unsafe_unretained NSString *userheadphoto;
	__unsafe_unretained NSString *userid;
	__unsafe_unretained NSString *usernickname;
} EntityAttributes;

extern const struct EntityRelationships {
	__unsafe_unretained NSString *commentoftrend;
} EntityRelationships;

@class Trend;

@interface EntityID : NSManagedObjectID {}
@end

@interface _Entity : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) EntityID* objectID;

@property (nonatomic, strong) NSString* commentcontent;

//- (BOOL)validateCommentcontent:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* commentid;

//- (BOOL)validateCommentid:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* commentuserid;

//- (BOOL)validateCommentuserid:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* commentusernickname;

//- (BOOL)validateCommentusernickname:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* userheadphoto;

//- (BOOL)validateUserheadphoto:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* userid;

//- (BOOL)validateUserid:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* usernickname;

//- (BOOL)validateUsernickname:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) Trend *commentoftrend;

//- (BOOL)validateCommentoftrend:(id*)value_ error:(NSError**)error_;

@end

@interface _Entity (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveCommentcontent;
- (void)setPrimitiveCommentcontent:(NSString*)value;

- (NSString*)primitiveCommentid;
- (void)setPrimitiveCommentid:(NSString*)value;

- (NSString*)primitiveCommentuserid;
- (void)setPrimitiveCommentuserid:(NSString*)value;

- (NSString*)primitiveCommentusernickname;
- (void)setPrimitiveCommentusernickname:(NSString*)value;

- (NSString*)primitiveUserheadphoto;
- (void)setPrimitiveUserheadphoto:(NSString*)value;

- (NSString*)primitiveUserid;
- (void)setPrimitiveUserid:(NSString*)value;

- (NSString*)primitiveUsernickname;
- (void)setPrimitiveUsernickname:(NSString*)value;

- (Trend*)primitiveCommentoftrend;
- (void)setPrimitiveCommentoftrend:(Trend*)value;

@end
