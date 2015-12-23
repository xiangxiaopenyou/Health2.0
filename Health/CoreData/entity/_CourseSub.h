// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CourseSub.h instead.

#import <CoreData/CoreData.h>

extern const struct CourseSubAttributes {
	__unsafe_unretained NSString *coursesubaddress;
	__unsafe_unretained NSString *coursesubbegintime;
	__unsafe_unretained NSString *coursesubcontact;
	__unsafe_unretained NSString *coursesubcontent;
	__unsafe_unretained NSString *coursesubday;
	__unsafe_unretained NSString *coursesubflag;
	__unsafe_unretained NSString *coursesubid;
	__unsafe_unretained NSString *coursesubintrduce;
	__unsafe_unretained NSString *coursesuborder;
	__unsafe_unretained NSString *coursesubpositionX;
	__unsafe_unretained NSString *coursesubpositionY;
	__unsafe_unretained NSString *coursesubtelphone;
	__unsafe_unretained NSString *coursesubtime;
	__unsafe_unretained NSString *coursesubtitle;
	__unsafe_unretained NSString *coursesubtype;
} CourseSubAttributes;

extern const struct CourseSubRelationships {
	__unsafe_unretained NSString *course;
} CourseSubRelationships;

@class Course;

@interface CourseSubID : NSManagedObjectID {}
@end

@interface _CourseSub : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) CourseSubID* objectID;

@property (nonatomic, strong) NSString* coursesubaddress;

//- (BOOL)validateCoursesubaddress:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* coursesubbegintime;

//- (BOOL)validateCoursesubbegintime:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* coursesubcontact;

//- (BOOL)validateCoursesubcontact:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* coursesubcontent;

//- (BOOL)validateCoursesubcontent:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* coursesubday;

//- (BOOL)validateCoursesubday:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* coursesubflag;

//- (BOOL)validateCoursesubflag:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* coursesubid;

//- (BOOL)validateCoursesubid:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* coursesubintrduce;

//- (BOOL)validateCoursesubintrduce:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* coursesuborder;

@property (atomic) int16_t coursesuborderValue;
- (int16_t)coursesuborderValue;
- (void)setCoursesuborderValue:(int16_t)value_;

//- (BOOL)validateCoursesuborder:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* coursesubpositionX;

@property (atomic) float coursesubpositionXValue;
- (float)coursesubpositionXValue;
- (void)setCoursesubpositionXValue:(float)value_;

//- (BOOL)validateCoursesubpositionX:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* coursesubpositionY;

@property (atomic) float coursesubpositionYValue;
- (float)coursesubpositionYValue;
- (void)setCoursesubpositionYValue:(float)value_;

//- (BOOL)validateCoursesubpositionY:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* coursesubtelphone;

//- (BOOL)validateCoursesubtelphone:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* coursesubtime;

//- (BOOL)validateCoursesubtime:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* coursesubtitle;

//- (BOOL)validateCoursesubtitle:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* coursesubtype;

//- (BOOL)validateCoursesubtype:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) Course *course;

//- (BOOL)validateCourse:(id*)value_ error:(NSError**)error_;

@end

@interface _CourseSub (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveCoursesubaddress;
- (void)setPrimitiveCoursesubaddress:(NSString*)value;

- (NSString*)primitiveCoursesubbegintime;
- (void)setPrimitiveCoursesubbegintime:(NSString*)value;

- (NSString*)primitiveCoursesubcontact;
- (void)setPrimitiveCoursesubcontact:(NSString*)value;

- (NSString*)primitiveCoursesubcontent;
- (void)setPrimitiveCoursesubcontent:(NSString*)value;

- (NSString*)primitiveCoursesubday;
- (void)setPrimitiveCoursesubday:(NSString*)value;

- (NSString*)primitiveCoursesubflag;
- (void)setPrimitiveCoursesubflag:(NSString*)value;

- (NSString*)primitiveCoursesubid;
- (void)setPrimitiveCoursesubid:(NSString*)value;

- (NSString*)primitiveCoursesubintrduce;
- (void)setPrimitiveCoursesubintrduce:(NSString*)value;

- (NSNumber*)primitiveCoursesuborder;
- (void)setPrimitiveCoursesuborder:(NSNumber*)value;

- (int16_t)primitiveCoursesuborderValue;
- (void)setPrimitiveCoursesuborderValue:(int16_t)value_;

- (NSNumber*)primitiveCoursesubpositionX;
- (void)setPrimitiveCoursesubpositionX:(NSNumber*)value;

- (float)primitiveCoursesubpositionXValue;
- (void)setPrimitiveCoursesubpositionXValue:(float)value_;

- (NSNumber*)primitiveCoursesubpositionY;
- (void)setPrimitiveCoursesubpositionY:(NSNumber*)value;

- (float)primitiveCoursesubpositionYValue;
- (void)setPrimitiveCoursesubpositionYValue:(float)value_;

- (NSString*)primitiveCoursesubtelphone;
- (void)setPrimitiveCoursesubtelphone:(NSString*)value;

- (NSString*)primitiveCoursesubtime;
- (void)setPrimitiveCoursesubtime:(NSString*)value;

- (NSString*)primitiveCoursesubtitle;
- (void)setPrimitiveCoursesubtitle:(NSString*)value;

- (NSString*)primitiveCoursesubtype;
- (void)setPrimitiveCoursesubtype:(NSString*)value;

- (Course*)primitiveCourse;
- (void)setPrimitiveCourse:(Course*)value;

@end
