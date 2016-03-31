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
#import "SWLoginUser.h"


static NSString *QUESTION_DESC_CELL_IDENTITY = @"QUESTION_DESC_CELL_IDENTITY";
static NSString *QUESTION_IMG_CELL_IDENTITY = @"QUESTION_IMG_CELL_IDENTITY";
static NSString *QUESTION_ANSWERS_CELL_IDENTITY = @"QUESTION_ANSWERS_CELL_IDENTITY";
static NSString *QUESTION_RIGHT_ANSWER_CELL_IDENTITY = @"QUESTION_RIGHT_ANSWER_CELL_IDENTITY";


@interface SWDriverTestQuestionView()<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, strong) UITableView *questionTableView;
@property(nonatomic, strong) UIColor *deepBackgroundColor;
@property(nonatomic, strong) UIColor *tinyBackgroundColor;
@property(nonatomic) BOOL didUserSelectedAnswer;
@property(nonatomic) BOOL didSelectedRightAnswer;
@property(nonatomic) TestQuestionViewType questionViewType;
@property(nonatomic) NSInteger pageNum;
@end
@implementation SWDriverTestQuestionView

#pragma mark INIT/SETTER/GETTER
- (instancetype) initWithQuestion:(SWQuestionItems *) question viewType:(TestQuestionViewType) viewType
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
        _questionViewType = viewType;
        
       
    }
    return self;
}

- (instancetype) initWithQuestion:(SWQuestionItems *)question viewType:(TestQuestionViewType)viewType pageNum:(NSInteger) pageNum
{
    _pageNum = pageNum;
    return [self initWithQuestion:question viewType:viewType];
}
#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case SECTION_QUESTION_DESC_IMG:
        {
            if (![self.question.questionImageTitle isEqualToString:@""]) {
                return 2;
            }else
            {
                return 1;
            }
        }
            break;
        case SECTION_QUESTION_ANSWERS:
        {
            if (self.question.questionType.integerValue == 1) { // 4 chose
                return 4;
            }else
            {
                return 2;
            }
        }
            break;
        case SECTION_RIGHT_ANSWER:
        {
            if ([self isUserSelectedAnswer]) {
                if ([self isUserSelectedRightAnswer]) {
                    return 1;
                }else
                {
                    return 2;
                }
               
            }else if(self.questionViewType == kTestQuestionViewGlance)
            {
                return 2;
            }else
            {
                return 0;
            }
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
                    NSString *cellContent = [NSString stringWithFormat:@"%ld. %@", self.question.questionID.integerValue, self.question.questionDesc];
                    cell.textLabel.text = cellContent;
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
                    
                    UIImageView *questionImgView = (UIImageView *)[cell.contentView viewWithTag:CELL_IMG_VIEW_TAG];
                    if (questionImgView == nil) {
                        questionImgView = [[UIImageView alloc] initWithFrame:CGRectMake(cell.contentView.frame.origin.x + 2, cell.contentView.frame.origin.y + 2, cell.contentView.frame.size.width - 4, cell.contentView.frame.size.height - 4)];
                        questionImgView.tag = CELL_IMG_VIEW_TAG;
                        questionImgView.contentMode = UIViewContentModeScaleToFill;
                        [cell.contentView addSubview:questionImgView];
                    }
                    questionImgView.image = [UIImage imageNamed:self.question.questionImageTitle inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil];                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
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
            switch (indexPath.row) {
                case 0:
                {
                    cell.textLabel.text = self.question.questionAnswerA;
                }
                    break;
                case 1:
                {
                    cell.textLabel.text = self.question.questionAnswerB;

                }
                    break;
                case 2:
                {
                    cell.textLabel.text = self.question.questionAnswerC;
                }
                    break;
                case 3:
                {
                    cell.textLabel.text = self.question.questionAnswerD;
                }
                    break;
                default:
                    break;
            }
            
            cell.textLabel.lineBreakMode = NSLineBreakByCharWrapping;
            
            CGSize textSize = [cell.textLabel sizeThatFits:CGSizeMake(cell.frame.size.width, MAXFLOAT)];
            cell.textLabel.textColor = [UIColor blackColor];
            
            if (self.question.questionSelectedIndex.integerValue == indexPath.row + 1 && self.questionViewType == kTestQuestionViewSequence) {
                if ([self isUserSelectedRightAnswer]) {
                    cell.textLabel.textColor = [UIColor greenColor];
                }else
                {
                    cell.textLabel.textColor = [UIColor redColor];
                }
            }
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
            
            if (indexPath.row == 0) {
                if ([self isUserSelectedRightAnswer]) {
                    cell.textLabel.text = self.question.questionExplain;
                    cell.textLabel.textColor = [UIColor blueColor];
                    
                }else{
                    
                    switch (self.question.questionRightAnswer.integerValue) {
                        case 1:
                        {
                            cell.textLabel.text = [NSString stringWithFormat:@"正确答案：%@", @"A"];
                        }
                            break;
                        case 2:
                        {
                            cell.textLabel.text = [NSString stringWithFormat:@"正确答案：%@", @"B"];
                        }
                            break;
                        case 3:
                        {
                            cell.textLabel.text = [NSString stringWithFormat:@"正确答案：%@", @"C"];
                        }
                            break;
                        case 4:
                        {
                            cell.textLabel.text = [NSString stringWithFormat:@"正确答案：%@", @"D"];
                        }
                            break;
                            
                        default:
                            break;
                    }
                    cell.textLabel.textColor = [UIColor greenColor];
                }
                
            }else
            {
                cell.textLabel.text = self.question.questionExplain;
                cell.textLabel.textColor = [UIColor blueColor];
            }
           
            
            cell.textLabel.lineBreakMode = NSLineBreakByCharWrapping;
            
            CGSize textSize = [cell.textLabel sizeThatFits:CGSizeMake(cell.frame.size.width, MAXFLOAT)];
            cell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, textSize.height + 24);
            cell.backgroundColor = self.deepBackgroundColor;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
           
            
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
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (![self canUserSelecteAnswer]){
        return;
    }
    
    if (self.questionViewType != kTestQuestionViewGlance) {
        if (indexPath.section == SECTION_QUESTION_ANSWERS) {
            
            self.didUserSelectedAnswer = YES;
            
            if (self.questionViewType == kTestQuestionViewSequence) {
                self.question.questionSelectedIndex = [NSNumber numberWithInteger:(indexPath.row + 1)];
                [SWLoginUser saveUserAnsweredQuestion:self.question];
            }
            
            
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            if (indexPath.row + 1 == self.question.questionRightAnswer.integerValue) {  // select right answer
                self.didSelectedRightAnswer = YES;
                cell.textLabel.textColor = [UIColor greenColor];
                if (self.questionViewType == kTestQuestionViewWrongQuestions) {
                    [SWLoginUser removeWrongQuestion:self.question];
                }
                NSIndexPath *explansPath = [NSIndexPath indexPathForRow:0 inSection:SECTION_RIGHT_ANSWER];
                [tableView insertRowsAtIndexPaths:@[explansPath] withRowAnimation:YES];
                
               
                NSDictionary *userInfo = @{SELECTED_ANSWER__USERINFO_IS_RIGHT_KEY:@"RIGHT"};
                [[NSNotificationCenter defaultCenter] postNotificationName:USER_SELECTED_TEST_ANSWER_NOTIFICATION object:nil userInfo:userInfo];
                
            }else  // select wrong answer
            {
                cell.textLabel.textColor = [UIColor redColor];
                // Show right Answer
                NSIndexPath *rightIndexPath = [NSIndexPath indexPathForRow:0 inSection:SECTION_RIGHT_ANSWER];
                NSIndexPath *explansPath = [NSIndexPath indexPathForRow:1 inSection:SECTION_RIGHT_ANSWER];
                [tableView insertRowsAtIndexPaths:@[rightIndexPath, explansPath] withRowAnimation:YES];
                // Auto store into user's wrong lib
                [SWLoginUser addWrongQuestion:self.question];
                NSDictionary *userInfo = @{SELECTED_ANSWER__USERINFO_IS_RIGHT_KEY:@"WRONG"};
                [[NSNotificationCenter defaultCenter] postNotificationName:USER_SELECTED_TEST_ANSWER_NOTIFICATION object:nil userInfo:userInfo];
            }
        }
    }
}

#pragma mark - private method
-(BOOL) isUserSelectedRightAnswer
{
    if (self.questionViewType == kTestQuestionViewSequence) {
        return (self.question.questionSelectedIndex.integerValue == self.question.questionRightAnswer.integerValue || self.didSelectedRightAnswer);

    }else
    {
         return (self.didSelectedRightAnswer);
    }
}

-(BOOL) canUserSelecteAnswer
{
    if (self.didUserSelectedAnswer || self.questionViewType == kTestQuestionViewGlance || (self.questionViewType == kTestQuestionViewSequence && self.questionViewType ==  self.question.questionSelectedIndex.integerValue != 0)) {
        return NO;
    }
    
    return YES;
}

-(BOOL) isUserSelectedAnswer
{
    if ((self.questionViewType == kTestQuestionViewSequence && self.self.question.questionSelectedIndex.integerValue != 0) || self.didUserSelectedAnswer) {
        return YES;
    }else
    {
        return NO;
    }
}
@end
