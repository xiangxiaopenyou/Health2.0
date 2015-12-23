//
//  ClubDetailViewController.h
//  Health
//
//  Created by jason on 15/3/5.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ClubDetailViewDelegate<NSObject>
@optional
- (void)signSuccess;
@end

@interface ClubDetailViewController : UIViewController

@property (nonatomic, strong) UIButton *recentButton;
@property (nonatomic, strong) UIButton *hottestButton;
@property (nonatomic, strong) UIButton *creamButton;
@property (nonatomic, strong) NSString *clubId;
@property (nonatomic, strong) NSString *clubNameString;
@property (nonatomic, strong) UIButton *createDiscussionButton;

@property (nonatomic, strong) UIImageView *clubTagImage;
@property (nonatomic, strong) UILabel *joinClubAgeLabel;
@property (nonatomic, strong) UIButton *signButton;
@property (nonatomic, strong) UIButton *clubCampButton;
@property (nonatomic, strong) UIButton *clubCurriculumButton;
@property (nonatomic, strong) UIButton *clubActivityButton;
@property (nonatomic, strong) UIButton *clubstarsButton;

@property (nonatomic, strong) id<ClubDetailViewDelegate>delegate;

@end
