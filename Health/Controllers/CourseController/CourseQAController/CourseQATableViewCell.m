//
//  CourseQATableViewCell.m
//  Health
//
//  Created by cheng on 15/2/4.
//  Copyright (c) 2015年 realtech. All rights reserved.
//

#import "CourseQATableViewCell.h"

#define textColor_label [UIColor colorWithRed:189/255.0 green:189/255.0 blue:189/255.0 alpha:1.0]

@implementation CourseQATableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier Data:(CourseQAEntity *)entity{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        courseQAEntity = entity;
        
        UILabel *namelabel = [[UILabel alloc]initWithFrame:CGRectMake(16, 8, SCREEN_WIDTH-32-60, 21)];
        namelabel.text = [NSString stringWithFormat:@"%@:",courseQAEntity.questionusername];
        namelabel.font = [UIFont boldSystemFontOfSize:16.0];
        namelabel.textColor = [UIColor whiteColor];
        [self addSubview:namelabel];
        
        questionLabel = [[UILabel alloc]initWithFrame:CGRectMake(25, 35, SCREEN_WIDTH - 33, 21)];
        questionLabel.font = [UIFont boldSystemFontOfSize:14.0];
        questionLabel.numberOfLines = 0;
        questionLabel.text = courseQAEntity.questioncontent;
        questionLabel.textColor = textColor_label;
        [questionLabel sizeToFit];
        [self addSubview:questionLabel];
        
        UILabel *questionTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-32-80, 8, 80, 21)];
        questionTimeLabel.textAlignment = NSTextAlignmentRight;
        if (courseQAEntity.questiontime != nil) {
            questionTimeLabel.text = [CustomDate getDateStringToDete:courseQAEntity.questiontime];
        }else{
            questionTimeLabel.text = @"未知";
        }
        questionTimeLabel.textColor = textColor_label;
        questionTimeLabel.font = [UIFont boldSystemFontOfSize:12.0];
        [self addSubview:questionTimeLabel];
        
        if ([courseQAEntity.questionhasanswer intValue] == 1) {
            UILabel *answerlabel = [[UILabel alloc]initWithFrame:CGRectMake(16, questionLabel.frame.origin.y+questionLabel.frame.size.height+8, 60, 21)];
            answerlabel.text = @"答:";
            answerlabel.font = [UIFont boldSystemFontOfSize:16.0];
            answerlabel.textColor = [UIColor whiteColor];
            [self addSubview:answerlabel];
            
            answerContent = [[UILabel alloc]initWithFrame:CGRectMake(25, answerlabel.frame.origin.y+answerlabel.frame.size.height, SCREEN_WIDTH - 33, 21)];
            answerContent.font = [UIFont boldSystemFontOfSize:14.0];
            answerContent.numberOfLines = 0;
            AnswerEntity *answerEntity = [courseQAEntity.answerArray objectAtIndex:0];
            answerContent.text = answerEntity.answerContent;
            answerContent.textColor = textColor_label;
            [answerContent sizeToFit];
            [self addSubview:answerContent];
        }
    }
    return self;
}

- (float)getHeight{
    if ([courseQAEntity.questionhasanswer intValue] != 2) {
        return answerContent.frame.origin.y+answerContent.frame.size.height+5;
    }else{
        return questionLabel.frame.origin.y+questionLabel.frame.size.height+5;
    }
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
