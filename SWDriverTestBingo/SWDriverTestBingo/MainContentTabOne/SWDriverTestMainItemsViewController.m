//
//  SWDriverTestMainItemsViewController.m
//  SWDriverTestBingo
//
//  Created by EShi on 12/18/15.
//  Copyright © 2015 Eren. All rights reserved.
//

#import "SWDriverTestMainItemsViewController.h"
#import "CollectionLayoutForDriverTestMain.h"
#import "SWDriverTestMainCollectionViewCell.h"
#import "SWDriverTestCellView.h"
#import "SWQuestionPageViewController.h"

#import "SWDriverTestQuestionView.h"
#import "SWDriverTestQuestion.h"

#import "SWQuestionItems+CoreDataProperties.h"
#import "SWMarkItems+CoreDataProperties.h"

#import "AppDelegate.h"


static NSString *IMG_COL_CELL_IDENTITY = @"IMG_COL_CELL_IDENTITY";
@interface SWDriverTestMainItemsViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
@property(nonatomic, strong) UICollectionView *collectionView;
@end

@implementation SWDriverTestMainItemsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Note ! since we set autolayout ,so we can disable the bellow property
    // refer: http://stackoverflow.com/questions/23786198/uicollectionview-how-can-i-remove-the-space-on-top-first-cells-row
    
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    [self makeUpCollectionView];
    
    // JUST FOR TEST!!!!!!
    [self genTestData];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setTranslucent:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) makeUpCollectionView
{
    CollectionLayoutForDriverTestMain *layout = [[CollectionLayoutForDriverTestMain alloc] init];
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:layout];
    _collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_collectionView];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_collectionView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_collectionView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_collectionView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0.0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_collectionView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1.0 constant:0.0]];
    _collectionView.dataSource =self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor blackColor];
    [_collectionView registerClass:[SWDriverTestMainCollectionViewCell class] forCellWithReuseIdentifier:IMG_COL_CELL_IDENTITY];
    
}

#pragma mark UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return 4;
    }else
    {
        return 2;
    }
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}
// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SWDriverTestMainCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:IMG_COL_CELL_IDENTITY forIndexPath:indexPath];
    UIImageView *imageView = [[UIImageView alloc] init];
    UILabel *titleLab = [[UILabel alloc] init];
    
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
            {
                imageView.image = [UIImage imageNamed:@"list"];
                titleLab.text = NSLocalizedString(@"SequenAnswer", nil);
            }
                break;
            case 1:
            {
                imageView.image = [UIImage imageNamed:@"exam"];
                titleLab.text = NSLocalizedString(@"SimExam", nil);
            }
                break;
            case 2:
            {
                imageView.image = [UIImage imageNamed:@"study"];
                titleLab.text = NSLocalizedString(@"ScanQuestions", nil);
            }
                break;
            case 3:
            {
                imageView.image = [UIImage imageNamed:@"wrongQuestions"];
                titleLab.text = NSLocalizedString(@"WrongAnswers", nil);
            }
                break;
            default:
                break;
        }
    }else if(indexPath.section == 1)
    {
        switch (indexPath.row) {
            case 0:
            {
                imageView.image = [UIImage imageNamed:@"markQuestions"];
                titleLab.text = NSLocalizedString(@"MarkQuestions", nil);
            }
                break;
            case 1:
            {
                imageView.image = [UIImage imageNamed:@"statistics"];
                titleLab.text = NSLocalizedString(@"MyStatistics", nil);
            }
                break;
            default:
                break;
        }
        
    }
    
    SWDriverTestCellView * cellView = [[SWDriverTestCellView alloc] initWithCellImage:imageView cellTitle:titleLab];
    cellView.tag = SW_DRIVER_TEST_CELL_VIEW_TAG;
    cellView.frame = cell.contentView.frame;
    UIView *preView = [cell.contentView viewWithTag:SW_DRIVER_TEST_CELL_VIEW_TAG];
    if (preView) {
        [preView removeFromSuperview];
    }
    
    [cell.contentView addSubview:cellView];
    [cellView layoutCellView];
    
    return cell;
}

#pragma mark UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:  // 顺序答题
            {
                NSArray *answers = @[@"A.这是错误答案", @"B.也许我是对的？我是对的就没错的了", @"C.我才是正宗的答案",@"D.别听他们胡叨叨"];
                NSArray *justAnswers =@[@"A.正确", @"B.错误"];
                SWDriverTestQuestion *questionOne = [[SWDriverTestQuestion alloc]initWithQuestionImage:[UIImage imageNamed:@"qImg1"] questionDescp:@"当行人在穿越人行横道时，司机可以加速行驶来躲开行人，这是可行的，哈哈哈哈哈哈哈哈哈，李逍遥弥月大家好，我是夜月神" answers:answers rightIndex:2];
                SWDriverTestQuestion *questionTwo = [[SWDriverTestQuestion alloc]initWithQuestionImage:[UIImage imageNamed:@"qImg2"] questionDescp:@"当行人在穿越人行横道时，司机可以加速行驶来躲开行人，这是可行的，哈哈哈哈哈哈哈哈哈，李逍遥弥月大家好，我是夜月神" answers:justAnswers rightIndex:1];

                
                SWDriverTestQuestionView *question1 = [[SWDriverTestQuestionView alloc] initWithQuestion:questionOne];
              
                SWDriverTestQuestionView *question2 = [[SWDriverTestQuestionView alloc] initWithQuestion:questionTwo];
                NSMutableArray *questionItemViews = [[NSMutableArray alloc] init];
                [questionItemViews addObject:question1];
                [questionItemViews addObject:question2];
                SWQuestionPageViewController *pagesVC = [[SWQuestionPageViewController alloc] initWithContentViews:questionItemViews];
                
                [self.navigationController pushViewController:pagesVC animated:YES];
            }
                break;
            case 1:  // 模拟练习
            {}
                break;
            case 2:  // 浏览题库
            {}
                break;
            case 3:  // 错题集
            {}
                break;
            default:
                break;
        }
    }else if(indexPath.section == 1)
    {
        switch (indexPath.row) {
            case 0:  // 我的收藏
            {}
                break;
            case 1:  // 做题统计
            {}
                break;
            default:
                break;
        }
    }
    NSLog(@"Now select %@", indexPath);
}

#pragma mark JUST FOR TEST
- (NSMutableArray *) genTestData
{
    NSMutableArray *testViews = [[NSMutableArray alloc] init];
    
    NSFetchRequest *fetch = [NSFetchRequest fetchRequestWithEntityName:@"SWUserInfo"];
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    NSArray *result = [appDelegate.managedObjectContext executeFetchRequest:fetch error:nil];
    NSLog(@"the user is %@", result);
    
    SWQuestionItems *questionItem = [NSEntityDescription insertNewObjectForEntityForName:@"SWQuestionItems" inManagedObjectContext:appDelegate.managedObjectContext];
    questionItem.questionDesc = @"当前方有人行横道时，应该加速行驶。";
    questionItem.questionAnswerA = @"正确";
    questionItem.questionAnswerB = @"错误";
    questionItem.questionRightAnswer = [NSNumber numberWithInteger:0];
    questionItem.questionType = [NSNumber]
    
    SWQuestionItems *questionItem2 = [NSEntityDescription insertNewObjectForEntityForName:@"SWQuestionItems" inManagedObjectContext:appDelegate.managedObjectContext];
    questionItem2.questionDesc = @"当机动车驾驶人驾驶没有牌照的车子上路时，交警可以做出如下那种处罚";
    questionItem2.questionAnswerA = @"吊销驾照";
    questionItem2.questionAnswerB = @"罚款500元以上 1000元以下";
    questionItem2.questionAnswerC = @"拘禁四个月";
    questionItem2.questionAnswerD = @"在规定的30个工作日内，向当地车管所备案";
    questionItem2.questionRightAnswer = [NSNumber numberWithInteger:2];
    questionItem2.questionImageTitle = @"abc";
    questionItem2.questionType = [NSNumber numberWithInteger:1];

    return testViews;
}

@end
