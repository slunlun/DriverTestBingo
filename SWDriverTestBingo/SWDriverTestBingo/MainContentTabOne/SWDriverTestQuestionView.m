//
//  SWDriverTestQuestionView.m
//  SWDriverTestBingo
//
//  Created by EShi on 12/18/15.
//  Copyright © 2015 Eren. All rights reserved.
//
#define SECTION_QUESTION_DESC_IMG 0
#define SECTION_QUESTION_ANSWERS 1
#define SECTION_RIGHT_ANSWER 2

#define CELL_IMG_VIEW_TAG 90000

#import "SWDriverTestQuestionView.h"
static NSString *QUESTION_DESC_CELL_IDENTITY = @"QUESTION_DESC_CELL_IDENTITY";
static NSString *QUESTION_IMG_CELL_IDENTITY = @"QUESTION_IMG_CELL_IDENTITY";
static NSString *QUESTION_ANSWERS_CELL_IDENTITY = @"QUESTION_ANSWERS_CELL_IDENTITY";
static NSString *QUESTION_RIGHT_ANSWER_CELL_IDENTITY = @"QUESTION_RIGHT_ANSWER_CELL_IDENTITY";


@interface SWDriverTestQuestionView()<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, strong) UITableView *questionTableView;
@property(nonatomic, strong) UIColor *deepBackgroundColor;
@property(nonatomic, strong) UIColor *tinyBackgroundColor;
@end
@implementation SWDriverTestQuestionView

#pragma mark INIT/SETTER/GETTER
- (instancetype) initWithQuestion:(SWDriverTestQuestion *) question
{
    self = [super init];
    if (self) {
        _deepBackgroundColor = [UIColor colorWithRed:0.95 green:0.91 blue:0.86 alpha:1.0];
        _tinyBackgroundColor = [UIColor colorWithRed:0.964 green:0.95 blue:0.91 alpha:1.0];
        
        _questionTableView = [[UITableView alloc] init];
        _questionTableView.delegate = self;
        _questionTableView.dataSource = self;
        _questionTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _questionTableView.translatesAutoresizingMaskIntoConstraints = NO;
        _questionTableView.backgroundColor = _tinyBackgroundColor;
        [self addSubview:_questionTableView];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_questionTableView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_questionTableView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_questionTableView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_questionTableView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:0.0]];
        
         _question = question;
        
       
    }
    return self;
}
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case SECTION_QUESTION_DESC_IMG:
        {
            if (self.question.questionImage) {
                return 2;
            }else
            {
                return 1;
            }
        }
            break;
        case SECTION_QUESTION_ANSWERS:
        {
            return self.question.questionAnswers.count;
        }
            break;
        case SECTION_RIGHT_ANSWER:
        {
            return 1;
        }
            break;
        default:
            break;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // 0 question desc and image 1 select items 2 rightAnswers
    return 3;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    switch (indexPath.section) {
        case SECTION_QUESTION_DESC_IMG:
        {
            switch (indexPath.row) {
                case 0:  // Question Description
                {
                    cell = [tableView dequeueReusableCellWithIdentifier:QUESTION_DESC_CELL_IDENTITY];
                    if (cell == nil) {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:QUESTION_DESC_CELL_IDENTITY];
                    }
                    
                    cell.textLabel.numberOfLines = 0;
                    cell.textLabel.text = self.question.questionDescp;
                    cell.textLabel.lineBreakMode = NSLineBreakByCharWrapping;
                    
                    CGSize textSize = [cell.textLabel sizeThatFits:CGSizeMake(cell.frame.size.width, MAXFLOAT)];
                    cell.textLabel.textColor = [UIColor blackColor];
                    cell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, textSize.height + 24);
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.backgroundColor = self.tinyBackgroundColor;
                }
                    break;
                case 1:  // Question Image (may nil)
                {
                    cell = [tableView dequeueReusableCellWithIdentifier:QUESTION_IMG_CELL_IDENTITY];
                    if (cell == nil) {
                        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:QUESTION_IMG_CELL_IDENTITY];
                    }
                    // there cell.contentView. width must equal self.questionTableView.width, for cell in init width 320 not equal to tableView width
                    cell.contentView.frame = CGRectMake(cell.contentView.frame.origin.x, cell.contentView.frame.origin.y, self.questionTableView.frame.size.width, cell.contentView.frame.size.height * 3);
                    cell.frame = cell.contentView.frame;
                    
                    UIImageView *questionImgView = [cell.contentView viewWithTag:CELL_IMG_VIEW_TAG];
                    if (questionImgView == nil) {
                        questionImgView = [[UIImageView alloc] initWithFrame:CGRectMake(cell.contentView.frame.origin.x + 2, cell.contentView.frame.origin.y + 2, cell.contentView.frame.size.width - 4, cell.contentView.frame.size.height - 4)];
                        questionImgView.tag = CELL_IMG_VIEW_TAG;
                        questionImgView.contentMode = UIViewContentModeScaleToFill;
                        [cell.contentView addSubview:questionImgView];
                    }
                    questionImgView.image = self.question.questionImage;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    cell.backgroundColor = self.tinyBackgroundColor;
                    cell.contentView.backgroundColor = self.tinyBackgroundColor;
                }
                default:
                    break;
            }
        }
            break;
        case SECTION_QUESTION_ANSWERS:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:QUESTION_ANSWERS_CELL_IDENTITY];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:QUESTION_ANSWERS_CELL_IDENTITY];
            }
            
            cell.textLabel.numberOfLines = 0;
            cell.textLabel.text = self.question.questionAnswers[indexPath.row];
            cell.textLabel.lineBreakMode = NSLineBreakByCharWrapping;
            
            CGSize textSize = [cell.textLabel sizeThatFits:CGSizeMake(cell.frame.size.width, MAXFLOAT)];
            cell.textLabel.textColor = [UIColor blackColor];
            cell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, textSize.height + 24);
            if (indexPath.row %2 == 0) {
                cell.backgroundColor = self.deepBackgroundColor;
            }else
            {
                cell.backgroundColor = self.tinyBackgroundColor;
            }
        }
            break;
        case SECTION_RIGHT_ANSWER:
        {
            cell = [tableView dequeueReusableCellWithIdentifier:QUESTION_RIGHT_ANSWER_CELL_IDENTITY];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:QUESTION_RIGHT_ANSWER_CELL_IDENTITY];
            }
            
            cell.textLabel.numberOfLines = 0;
            cell.textLabel.text = @"A";
            cell.textLabel.lineBreakMode = NSLineBreakByCharWrapping;
            CGSize textSize = [cell.textLabel sizeThatFits:CGSizeMake(cell.frame.size.width, MAXFLOAT)];
            cell.textLabel.textColor = [UIColor blackColor];
            cell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, textSize.height + 24);
            cell.backgroundColor = self.deepBackgroundColor;
            
        }
            break;
        default:
            break;
    }
   
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}
#pragma mark UITableViewDelegate

@end
