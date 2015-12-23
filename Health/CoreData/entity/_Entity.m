// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Entity.m instead.

#import "_Entity.h"

const struct EntityAttributes EntityAttributes = {
	.commentcontent = @"commentcontent",
	.commentid = @"commentid",
	.commentuserid = @"commentuserid",
	.commentusernickname = @"commentusernickname",
	.userheadphoto = @"userheadphoto",
	.userid = @"userid",
	.usernickname = @"usernickname",
};

const struct EntityRelationships EntityRelationships = {
	.commentoftrend = @"commentoftrend",
};

@implementation EntityID
@end

@implementation _Entity

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"TrendComment" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"TrendComment";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"TrendComment" inManagedObjectContext:moc_];
}

- (EntityID*)objectID {
	return (EntityID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic commentcontent;

@dynamic commentid;

@dynamic commentuserid;

@dynamic commentusernickname;

@dynamic userheadphoto;

@dynamic userid;

@dynamic usernickname;

@dynamic commentoftrend;

@end

