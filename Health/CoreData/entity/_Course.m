// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Course.m instead.

#import "_Course.h"

const struct CourseAttributes CourseAttributes = {
	.courseapplynum = @"courseapplynum",
	.coursebody = @"coursebody",
	.coursecount = @"coursecount",
	.coursecreatedtime = @"coursecreatedtime",
	.courseday = @"courseday",
	.coursedetailimgage = @"coursedetailimgage",
	.coursedifficultty = @"coursedifficultty",
	.coursefat = @"coursefat",
	.coursehastake = @"coursehastake",
	.courseid = @"courseid",
	.courseintrduce = @"courseintrduce",
	.courseisappraise = @"courseisappraise",
	.courseisstart = @"courseisstart",
	.courseofclub = @"courseofclub",
	.courseoldprice = @"courseoldprice",
	.courseownerid = @"courseownerid",
	.coursephoto = @"coursephoto",
	.coursepowerdifficulty = @"coursepowerdifficulty",
	.courseprice = @"courseprice",
	.courseshaping = @"courseshaping",
	.coursesign = @"coursesign",
	.coursestarttime = @"coursestarttime",
	.coursestate = @"coursestate",
	.coursestrength = @"coursestrength",
	.coursetarget = @"coursetarget",
	.coursetitle = @"coursetitle",
};

const struct CourseRelationships CourseRelationships = {
	.coursesub = @"coursesub",
	.teacher = @"teacher",
	.userinfo = @"userinfo",
	.userinforecommend = @"userinforecommend",
};

@implementation CourseID
@end

@implementation _Course

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Course" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Course";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Course" inManagedObjectContext:moc_];
}

- (CourseID*)objectID {
	return (CourseID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic courseapplynum;

@dynamic coursebody;

@dynamic coursecount;

@dynamic coursecreatedtime;

@dynamic courseday;

@dynamic coursedetailimgage;

@dynamic coursedifficultty;

@dynamic coursefat;

@dynamic coursehastake;

@dynamic courseid;

@dynamic courseintrduce;

@dynamic courseisappraise;

@dynamic courseisstart;

@dynamic courseofclub;

@dynamic courseoldprice;

@dynamic courseownerid;

@dynamic coursephoto;

@dynamic coursepowerdifficulty;

@dynamic courseprice;

@dynamic courseshaping;

@dynamic coursesign;

@dynamic coursestarttime;

@dynamic coursestate;

@dynamic coursestrength;

@dynamic coursetarget;

@dynamic coursetitle;

@dynamic coursesub;

- (NSMutableSet*)coursesubSet {
	[self willAccessValueForKey:@"coursesub"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"coursesub"];

	[self didAccessValueForKey:@"coursesub"];
	return result;
}

@dynamic teacher;

@dynamic userinfo;

@dynamic userinforecommend;

@end

