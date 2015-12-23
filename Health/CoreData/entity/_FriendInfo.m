// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to FriendInfo.m instead.

#import "_FriendInfo.h"

const struct FriendInfoAttributes FriendInfoAttributes = {
	.friendattitudescore = @"friendattitudescore",
	.friendbirthday = @"friendbirthday",
	.friendid = @"friendid",
	.friendintrduce = @"friendintrduce",
	.friendname = @"friendname",
	.friendoverallappraisal = @"friendoverallappraisal",
	.friendphoto = @"friendphoto",
	.friendpointstudent = @"friendpointstudent",
	.friendpointsystem = @"friendpointsystem",
	.friendsex = @"friendsex",
	.friendskillscore = @"friendskillscore",
	.friendtype = @"friendtype",
};

const struct FriendInfoRelationships FriendInfoRelationships = {
	.teacherofcourse = @"teacherofcourse",
};

@implementation FriendInfoID
@end

@implementation _FriendInfo

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"FriendInfo" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"FriendInfo";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"FriendInfo" inManagedObjectContext:moc_];
}

- (FriendInfoID*)objectID {
	return (FriendInfoID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic friendattitudescore;

@dynamic friendbirthday;

@dynamic friendid;

@dynamic friendintrduce;

@dynamic friendname;

@dynamic friendoverallappraisal;

@dynamic friendphoto;

@dynamic friendpointstudent;

@dynamic friendpointsystem;

@dynamic friendsex;

@dynamic friendskillscore;

@dynamic friendtype;

@dynamic teacherofcourse;

@end

