// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to UserInfo.m instead.

#import "_UserInfo.h"

const struct UserInfoAttributes UserInfoAttributes = {
	.balance = @"balance",
	.goodat = @"goodat",
	.isnewuser = @"isnewuser",
	.myfeans = @"myfeans",
	.myfollow = @"myfollow",
	.rongyunid = @"rongyunid",
	.rongyunportrait = @"rongyunportrait",
	.skillpoint = @"skillpoint",
	.teacherpoint = @"teacherpoint",
	.totalmoney = @"totalmoney",
	.type = @"type",
	.userarea = @"userarea",
	.userbirthday = @"userbirthday",
	.userbodyphoto = @"userbodyphoto",
	.userheight = @"userheight",
	.userid = @"userid",
	.userintrduce = @"userintrduce",
	.userlike = @"userlike",
	.username = @"username",
	.userphoto = @"userphoto",
	.usersex = @"usersex",
	.usersycle = @"usersycle",
	.usertargetweight = @"usertargetweight",
	.usertelphone = @"usertelphone",
	.usertoken = @"usertoken",
	.usertype = @"usertype",
	.userweight = @"userweight",
};

const struct UserInfoRelationships UserInfoRelationships = {
	.alltrends = @"alltrends",
	.minecourse = @"minecourse",
	.myevaluatedcourse = @"myevaluatedcourse",
	.myfinishedcourse = @"myfinishedcourse",
	.recommendcourse = @"recommendcourse",
};

@implementation UserInfoID
@end

@implementation _UserInfo

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"UserInfo" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"UserInfo";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"UserInfo" inManagedObjectContext:moc_];
}

- (UserInfoID*)objectID {
	return (UserInfoID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic balance;

@dynamic goodat;

@dynamic isnewuser;

@dynamic myfeans;

@dynamic myfollow;

@dynamic rongyunid;

@dynamic rongyunportrait;

@dynamic skillpoint;

@dynamic teacherpoint;

@dynamic totalmoney;

@dynamic type;

@dynamic userarea;

@dynamic userbirthday;

@dynamic userbodyphoto;

@dynamic userheight;

@dynamic userid;

@dynamic userintrduce;

@dynamic userlike;

@dynamic username;

@dynamic userphoto;

@dynamic usersex;

@dynamic usersycle;

@dynamic usertargetweight;

@dynamic usertelphone;

@dynamic usertoken;

@dynamic usertype;

@dynamic userweight;

@dynamic alltrends;

- (NSMutableSet*)alltrendsSet {
	[self willAccessValueForKey:@"alltrends"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"alltrends"];

	[self didAccessValueForKey:@"alltrends"];
	return result;
}

@dynamic minecourse;

- (NSMutableSet*)minecourseSet {
	[self willAccessValueForKey:@"minecourse"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"minecourse"];

	[self didAccessValueForKey:@"minecourse"];
	return result;
}

@dynamic myevaluatedcourse;

- (NSMutableSet*)myevaluatedcourseSet {
	[self willAccessValueForKey:@"myevaluatedcourse"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"myevaluatedcourse"];

	[self didAccessValueForKey:@"myevaluatedcourse"];
	return result;
}

@dynamic myfinishedcourse;

- (NSMutableSet*)myfinishedcourseSet {
	[self willAccessValueForKey:@"myfinishedcourse"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"myfinishedcourse"];

	[self didAccessValueForKey:@"myfinishedcourse"];
	return result;
}

@dynamic recommendcourse;

- (NSMutableSet*)recommendcourseSet {
	[self willAccessValueForKey:@"recommendcourse"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"recommendcourse"];

	[self didAccessValueForKey:@"recommendcourse"];
	return result;
}

@end

