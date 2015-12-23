// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TrendComment.m instead.

#import "_TrendComment.h"

const struct TrendCommentAttributes TrendCommentAttributes = {
	.commentcontent = @"commentcontent",
	.commentid = @"commentid",
	.commenttype = @"commenttype",
	.commentuserid = @"commentuserid",
	.commentusernickname = @"commentusernickname",
	.userheadphoto = @"userheadphoto",
	.userid = @"userid",
	.usernickname = @"usernickname",
};

const struct TrendCommentRelationships TrendCommentRelationships = {
	.commentoftrend = @"commentoftrend",
};

@implementation TrendCommentID
@end

@implementation _TrendComment

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

- (TrendCommentID*)objectID {
	return (TrendCommentID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic commentcontent;

@dynamic commentid;

@dynamic commenttype;

@dynamic commentuserid;

@dynamic commentusernickname;

@dynamic userheadphoto;

@dynamic userid;

@dynamic usernickname;

@dynamic commentoftrend;

@end

