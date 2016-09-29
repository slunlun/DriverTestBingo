//
//  SWQuestionStatisticsPageViewController.m
//  SWDriverTestBingo
//
//  Created by ShiTeng on 16/9/27.
//  Copyright © 2016年 Eren. All rights reserved.
//

#import "SWQuestionStatisticsPageViewController.h"
#import "SWLoginUser.h"
@interface SWQuestionStatisticsPageViewController() <UITableViewDelegate, UITableViewDataSource>
@property(nonatomic) NSInteger totalQuestions;
@property(nonatomic) NSInteger wrongQustions;
@property(nonatomic, strong) UITableView *statisticTableView;
@end

@implementation SWQuestionStatisticsPageViewController

- (instancetype) initWithTotalQuestionCount:(NSInteger) totalQustionCount wrongQustionCount:(NSInteger) wrongQustionCount
{
    self = [super init];
    if (self) {
        _statisticTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _statisticTableView.delegate = self;
        _statisticTableView.dataSource = self;
        _totalQuestions = totalQustionCount;
        _wrongQustions = wrongQustionCount;
    }
    return self;
}
- (void) viewDidLoad
{
    [super viewDidLoad];
    _statisticTableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_statisticTableView];
    NSDictionary *viewDict = @{@"statisticTableView":_statisticTableView};
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[statisticTableView]-|" options:0 metrics:nil views:viewDict]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[statisticTableView]|" options:0 metrics:nil views:viewDict]];

}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && indexPath.row == 0) {
        [[SWLoginUser sharedInstance] cleanUpAnswerStatistic];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 3;
    }else{
        return 1;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
       if (indexPath.section == 0) {
           static NSString *CELL_IDENTITY_1 = @"CELL_IDENTITY_1";
           cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTITY_1];
           if (cell == nil) {
               cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CELL_IDENTITY_1];
           }
           

        if (indexPath.row == 0) {
            cell.textLabel.text = [NSString stringWithFormat:@"总答题数:%ld", self.totalQuestions];
            cell.imageView.image = [UIImage imageNamed:@"paper"];
            
        }else if(indexPath.row == 1){
            cell.textLabel.text = [NSString stringWithFormat:@"错误题数:%ld", self.wrongQustions];
            cell.imageView.image = [UIImage imageNamed:@"paper"];
            
        }else if(indexPath.row == 2){
            cell.textLabel.text = [NSString stringWithFormat:@"正确率:%ld%%", (long)(((float)(self.totalQuestions - self.wrongQustions) / (float)self.totalQuestions)*100)];
            cell.imageView.image = [UIImage imageNamed:@"paper"];
        }
        
    }else if(indexPath.section == 1)
    {
        static NSString *CELL_IDENTITY_2 = @"CELL_IDENTITY_2";
        cell = [tableView dequeueReusableCellWithIdentifier:CELL_IDENTITY_2];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CELL_IDENTITY_2];
        }
        

        cell.textLabel.text = @"重  置";
        cell.textLabel.textColor = [UIColor redColor];
        cell.imageView.image = nil;
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    return cell;
}
@end
