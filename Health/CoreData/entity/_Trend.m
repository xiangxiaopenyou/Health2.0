// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Trend.m instead.

#import "_Trend.h"

const struct TrendAttributes TrendAttributes = {
	.couseid = @"couseid",
	.islike = @"islike",
	.ispublic = @"ispublic",
	.picTag = @"picTag",
	.trendcommentnumber = @"trendcommentnumber",
	.trendcomments = @"trendcomments",
	.trendcontent = @"trendcontent",
	.trendid = @"trendid",
	.trendlikemember = @"trendlikemember",
	.trendlikenumber = @"trendlikenumber",
	.trendphoto = @"trendphoto",
	.trendsportstype = @"trendsportstype",
	.trendtime = @"trendtime",
	.trendtype = @"trendtype",
	.useraddress = @"useraddress",
	.userheaderphoto = @"userheaderphoto",
	.userid = @"userid",
	.usernickname = @"usernickname",
	.usersex = @"usersex",
	.usertype = @"usertype",
};

const struct TrendRelationships TrendRelationships = {
	.trendcomment = @"trendcomment",
	.trendsofall = @"trendsofall",
};

@implementation TrendID
@end

@implementation _Trend

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Trend" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Trend";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Trend" inManagedObjectContext:moc_];
}

- (TrendID*)objectID {
	return (TrendID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic couseid;

@dynamic islike;

@dynamic ispublic;

@dynamic picTag;

@dynamic trendcommentnumber;

@dynamic trendcomments;

@dynamic trendcontent;

@dynamic trendid;

@dynamic trendlikemember;

@dynamic trendlikenumber;

@dynamic trendphoto;

@dynamic trendsportstype;

@dynamic trendtime;

@dynamic trendtype;

@dynamic useraddress;

@dynamic userheaderphoto;

@dynamic userid;

@dynamic usernickname;

@dynamic usersex;

@dynamic usertype;

@dynamic trendcomment;

- (NSMutableSet*)trendcommentSet {
	[self willAccessValueForKey:@"trendcomment"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"trendcomment"];

	[self didAccessValueForKey:@"trendcomment"];
	return result;
}

@dynamic trendsofall;

@end

