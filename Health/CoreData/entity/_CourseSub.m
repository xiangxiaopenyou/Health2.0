// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CourseSub.m instead.

#import "_CourseSub.h"

const struct CourseSubAttributes CourseSubAttributes = {
	.coursesubaddress = @"coursesubaddress",
	.coursesubbegintime = @"coursesubbegintime",
	.coursesubcontact = @"coursesubcontact",
	.coursesubcontent = @"coursesubcontent",
	.coursesubday = @"coursesubday",
	.coursesubflag = @"coursesubflag",
	.coursesubid = @"coursesubid",
	.coursesubintrduce = @"coursesubintrduce",
	.coursesuborder = @"coursesuborder",
	.coursesubpositionX = @"coursesubpositionX",
	.coursesubpositionY = @"coursesubpositionY",
	.coursesubtelphone = @"coursesubtelphone",
	.coursesubtime = @"coursesubtime",
	.coursesubtitle = @"coursesubtitle",
	.coursesubtype = @"coursesubtype",
};

const struct CourseSubRelationships CourseSubRelationships = {
	.course = @"course",
};

@implementation CourseSubID
@end

@implementation _CourseSub

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"CourseSub" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"CourseSub";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"CourseSub" inManagedObjectContext:moc_];
}

- (CourseSubID*)objectID {
	return (CourseSubID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"coursesuborderValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"coursesuborder"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"coursesubpositionXValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"coursesubpositionX"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"coursesubpositionYValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"coursesubpositionY"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic coursesubaddress;

@dynamic coursesubbegintime;

@dynamic coursesubcontact;

@dynamic coursesubcontent;

@dynamic coursesubday;

@dynamic coursesubflag;

@dynamic coursesubid;

@dynamic coursesubintrduce;

@dynamic coursesuborder;

- (int16_t)coursesuborderValue {
	NSNumber *result = [self coursesuborder];
	return [result shortValue];
}

- (void)setCoursesuborderValue:(int16_t)value_ {
	[self setCoursesuborder:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveCoursesuborderValue {
	NSNumber *result = [self primitiveCoursesuborder];
	return [result shortValue];
}

- (void)setPrimitiveCoursesuborderValue:(int16_t)value_ {
	[self setPrimitiveCoursesuborder:[NSNumber numberWithShort:value_]];
}

@dynamic coursesubpositionX;

- (float)coursesubpositionXValue {
	NSNumber *result = [self coursesubpositionX];
	return [result floatValue];
}

- (void)setCoursesubpositionXValue:(float)value_ {
	[self setCoursesubpositionX:[NSNumber numberWithFloat:value_]];
}

- (float)primitiveCoursesubpositionXValue {
	NSNumber *result = [self primitiveCoursesubpositionX];
	return [result floatValue];
}

- (void)setPrimitiveCoursesubpositionXValue:(float)value_ {
	[self setPrimitiveCoursesubpositionX:[NSNumber numberWithFloat:value_]];
}

@dynamic coursesubpositionY;

- (float)coursesubpositionYValue {
	NSNumber *result = [self coursesubpositionY];
	return [result floatValue];
}

- (void)setCoursesubpositionYValue:(float)value_ {
	[self setCoursesubpositionY:[NSNumber numberWithFloat:value_]];
}

- (float)primitiveCoursesubpositionYValue {
	NSNumber *result = [self primitiveCoursesubpositionY];
	return [result floatValue];
}

- (void)setPrimitiveCoursesubpositionYValue:(float)value_ {
	[self setPrimitiveCoursesubpositionY:[NSNumber numberWithFloat:value_]];
}

@dynamic coursesubtelphone;

@dynamic coursesubtime;

@dynamic coursesubtitle;

@dynamic coursesubtype;

@dynamic course;

@end

