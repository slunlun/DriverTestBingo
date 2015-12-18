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

#import "SWDriverTestQuestionView.h"
static NSString *QUESTION_DESC_CELL_IDENTITY = @"QUESTION_DESC_CELL_IDENTITY";
static NSString *IMG_CELL_IDENTITY = @"IMG_CELL_IDENTITY";
static NSString *QUESTION_ANSWERS_CELL_IDENTITY = @"QUESTION_ANSWERS_CELL_IDENTITY";



@interface SWDriverTestQuestionView()<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, strong) UITableView *questionTableView;
@end
@implementation SWDriverTestQuestionView

#pragma mark INIT/SETTER/GETTER
- (instancetype) initWithQuestion:(SWDriverTestQuestion *) question
{
    self = [super init];
    if (self) {
        _questionTableView = [[UITableView alloc] init];
        _questionTableView.delegate = self;
        _questionTableView.dataSource = self;
        _questionTableView.translatesAutoresizingMaskIntoConstraints = NO;
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
                    cell = [tableView dequeueReusableCellWithIdentifier:IMG_CELL_IDENTITY];
                    if (tableView) {
                        
                    }
                }
                    break;
                case 1:  // Question Image (may nil)
                {
                    
                }
                default:
                    break;
            }
        }
            break;
        case SECTION_QUESTION_ANSWERS:
        {
        }
            break;
        case SECTION_RIGHT_ANSWER:
        {
        }
            break;
        default:
            break;
    }
   
    return cell;
}
#pragma mark UITableViewDelegate

@end
