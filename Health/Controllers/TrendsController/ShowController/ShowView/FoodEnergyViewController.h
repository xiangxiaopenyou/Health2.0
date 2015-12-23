//
//  FoodEnergyViewController.h
//  Health
//
//  Created by realtech on 15/4/17.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol FoodEnergyDelegate<NSObject>
@optional
- (void)clickFoodSave:(NSArray*)selectedFood withSelectedName:(NSArray*)nameArray withDic:(NSDictionary *)dic withAllEnergy:(NSInteger)allEnergy;
@end

@interface FoodEnergyViewController : UIViewController

@property (nonatomic, strong) NSMutableArray *selectedFoodArray;
@property (nonatomic, strong) NSMutableArray *selectedArray;
@property (nonatomic, strong) NSMutableDictionary *selectDic;
@property (nonatomic, assign) NSInteger countEnergy;

@property (nonatomic, strong) id<FoodEnergyDelegate>delegate;

@end
