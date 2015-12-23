//
//  ClubStarsViewController.h
//  Health
//
//  Created by realtech on 15/5/21.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClubStarsViewController : UIViewController {
    UITableView *starsTableView;
}

@property (nonatomic, strong) UIImageView *firstHeadImage;
@property (nonatomic, strong) UILabel *firstNickname;
@property (nonatomic, strong) UIImageView *secondHeadImage;
@property (nonatomic, strong) UILabel *secondNickname;
@property (nonatomic, strong) UIImageView *thirdHeadImage;
@property (nonatomic, strong) UILabel *thirdNickname;
@property (nonatomic, strong) NSString *club_id;


@end
