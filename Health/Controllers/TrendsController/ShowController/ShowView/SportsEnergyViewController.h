//
//  SportsEnergyViewController.h
//  Health
//
//  Created by realtech on 15/4/17.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SportsEnergyDelegate<NSObject>
@optional
- (void)clickSave:(NSArray*)selectedSports withSelectedName:(NSArray*)nameArray WithDic:(NSDictionary*)dic withAllEnergy:(NSInteger)allEnergy;
@end

@interface SportsEnergyViewController : UIViewController

@property (nonatomic, strong) NSMutableArray *selectedSportsArray;
@property (nonatomic, strong) NSMutableArray *selectedArray;
@property (nonatomic, strong) NSMutableDictionary *selectDic;
@property (nonatomic, assign) NSInteger countEnergy;

@property (nonatomic, strong) id<SportsEnergyDelegate>delegate;

@end
