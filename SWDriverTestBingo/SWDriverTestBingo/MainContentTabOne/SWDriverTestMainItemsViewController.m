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
#import "SWLoginUser.h"
#import "AppDelegate.h"
#import "SWDriverTestBigoDef.h"
#import "SWDriverTestCustomLibCellView.h"


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
    [SWLoginUser loginWithUserName:@"John" PassWord:@"123"];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.collectionView reloadData];
    
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
    UILabel *subTitleLab = [[UILabel alloc] init];
    
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
                subTitleLab.text = [NSString stringWithFormat:@"(%ld)", [SWLoginUser getUserWrongQuestions].count];
                subTitleLab.textColor = [UIColor orangeColor];
                subTitleLab.font = [UIFont systemFontOfSize:12];
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
                subTitleLab.text = [NSString stringWithFormat:@"(%ld)", [SWLoginUser getUserMarkedQuestions].count];
                subTitleLab.textColor = [UIColor orangeColor];
                subTitleLab.font = [UIFont systemFontOfSize:12];
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
    
    if (indexPath.section == 0) {
        if (indexPath.row != 3) {
            SWDriverTestCellView * cellView = [[SWDriverTestCellView alloc] initWithCellImage:imageView cellTitle:titleLab];
            cellView.tag = SW_DRIVER_TEST_CELL_VIEW_TAG;
            cellView.frame = cell.contentView.frame;
            UIView *preView = [cell.contentView viewWithTag:SW_DRIVER_TEST_CELL_VIEW_TAG];
            if (preView) {
                [preView removeFromSuperview];
            }
            
            [cell.contentView addSubview:cellView];
            [cellView layoutCellView];
        }else if(indexPath.row == 3) // 错题集
        {
            SWDriverTestCustomLibCellView *cellView = [[SWDriverTestCustomLibCellView alloc] initWithImageView:imageView TitleLabel:titleLab SubtitleLabel:subTitleLab];
            cellView.tag = SW_DRIVER_TEST_CUSTOM_LIB_CELL_VIEW_TAG;
            cellView.frame = cell.contentView.frame;
            UIView *preView = [cell.contentView viewWithTag:SW_DRIVER_TEST_CUSTOM_LIB_CELL_VIEW_TAG];
            if (preView) {
                [preView removeFromSuperview];
            }
            
            [cell.contentView addSubview:cellView];
            [cellView layoutLibCellView];
        }
    
    }else if(indexPath.section == 1)
    {
        if (indexPath.row == 0) { // 我的收藏
            SWDriverTestCustomLibCellView *cellView = [[SWDriverTestCustomLibCellView alloc] initWithImageView:imageView TitleLabel:titleLab SubtitleLabel:subTitleLab];
            cellView.tag = SW_DRIVER_TEST_CUSTOM_LIB_CELL_VIEW_TAG;
            cellView.frame = cell.contentView.frame;
            UIView *preView = [cell.contentView viewWithTag:SW_DRIVER_TEST_CUSTOM_LIB_CELL_VIEW_TAG];
            if (preView) {
                [preView removeFromSuperview];
            }
            
            [cell.contentView addSubview:cellView];
            [cellView layoutLibCellView];
        }else if(indexPath.row == 1) { // 做题统计
            SWDriverTestCellView * cellView = [[SWDriverTestCellView alloc] initWithCellImage:imageView cellTitle:titleLab];
            cellView.tag = SW_DRIVER_TEST_CELL_VIEW_TAG;
            cellView.frame = cell.contentView.frame;
            UIView *preView = [cell.contentView viewWithTag:SW_DRIVER_TEST_CELL_VIEW_TAG];
            if (preView) {
                [preView removeFromSuperview];
            }
            
            [cell.contentView addSubview:cellView];
            [cellView layoutCellView];
        }
       
    }
  
    
    return cell;
}

#pragma mark UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        NSMutableArray *questionItemViews = nil;
        switch (indexPath.row) {
            case 0:  // 顺序答题
            {
                questionItemViews = [self genSequenceQuestionViews];
               
            }
                break;
            case 1:  // 模拟练习
            {}
                break;
            case 2:  // 浏览题库
            {}
                break;
            case 3:  // 错题集
            {
                questionItemViews = [self genWrongQuestionViews];
            }
                break;
            default:
                break;
        }
        SWQuestionPageViewController *pagesVC = [[SWQuestionPageViewController alloc] initWithContentViews:questionItemViews];
        [self.navigationController pushViewController:pagesVC animated:YES];
        
    }else if(indexPath.section == 1)
    {
        switch (indexPath.row) {
            case 0:  // 我的收藏
            {
                NSMutableArray *markedQuestionViews = [self genMarkedQuestionViews];
                if (markedQuestionViews.count == 0) {
                    return;
                }
                SWQuestionPageViewController *pagesVC = [[SWQuestionPageViewController alloc] initWithContentViews:markedQuestionViews];
                [self.navigationController pushViewController:pagesVC animated:YES];
                
            }
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

#pragma mark Question Data provider
- (NSMutableArray *) genSequenceQuestionViews
{
    NSMutableArray *sequenceQuestionViews = [[NSMutableArray alloc] init];
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SWQuestionItems" inManagedObjectContext:appDelegate.managedObjectContext];
    [fetchRequest setEntity:entity];

    NSError *error = nil;
    NSArray *fetchedObjects = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects.count > 0) {
        for (SWQuestionItems *question in fetchedObjects) {
            SWDriverTestQuestionView *questionView = [[SWDriverTestQuestionView alloc] initWithQuestion:question viewType:kTestQuestionViewSequence];
            [sequenceQuestionViews addObject:questionView];
        }
    }
    return sequenceQuestionViews;
}

- (NSMutableArray *) genMarkedQuestionViews
{
    NSSet * userMarkedQuestionsSet = [SWLoginUser getUserMarkedQuestions];
    NSMutableArray *markedQuestionViews = [[NSMutableArray alloc] init];
    for (SWQuestionItems *question in userMarkedQuestionsSet) {
        SWDriverTestQuestionView *questionView = [[SWDriverTestQuestionView alloc] initWithQuestion:question viewType:kTestQuestionViewMark];
        [markedQuestionViews addObject:questionView];
    }
    return markedQuestionViews;
}

- (NSMutableArray *) genWrongQuestionViews
{
    NSSet * userWrongQuestionsSet = [SWLoginUser getUserWrongQuestions];
    NSMutableArray *wrongQuestionViews = [[NSMutableArray alloc] init];
    for (SWQuestionItems *question in userWrongQuestionsSet) {
        SWDriverTestQuestionView *questionView = [[SWDriverTestQuestionView alloc] initWithQuestion:question viewType:kTestQuestionViewWrongQuestions];
        [wrongQuestionViews addObject:questionView];
    }
    return wrongQuestionViews;
}

@end
