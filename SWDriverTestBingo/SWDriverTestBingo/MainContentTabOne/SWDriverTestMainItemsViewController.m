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
#import "SWUserInfoConfigViewController.h"


static NSString *IMG_COL_CELL_IDENTITY = @"IMG_COL_CELL_IDENTITY";
@interface SWDriverTestMainItemsViewController () <UICollectionViewDataSource, UICollectionViewDelegate, SWPageViewControllerDelegate>
@property(nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, strong) NSArray *pageDataArray;
@end

@implementation SWDriverTestMainItemsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Note ! since we set autolayout ,so we can disable the bellow property
    // refer: http://stackoverflow.com/questions/23786198/uicollectionview-how-can-i-remove-the-space-on-top-first-cells-row
    
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    [self makeUpCollectionView];
    
     UIBarButtonItem *showSlideMenuBarButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"slideMenu"] style:UIBarButtonItemStylePlain target:self action:@selector(showSlideMenuBtnPressed:)];
    showSlideMenuBarButton.tintColor = [UIColor blackColor];
    self.navigationItem.leftBarButtonItem = showSlideMenuBarButton;
    
    UIImageView *userPic = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"testUserHead"]];
    userPic.frame = CGRectMake(0, 0, 35, 35);
    userPic.layer.cornerRadius = userPic.frame.size.width / 2;
    userPic.clipsToBounds = YES;
    userPic.layer.borderWidth = 1.0f;
    userPic.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userInfoBtnPressed:)];
    [userPic addGestureRecognizer:tapRecognizer];
    
    
    UIBarButtonItem *userInfoBtn = [[UIBarButtonItem alloc] initWithCustomView:userPic];
    self.navigationItem.rightBarButtonItem = userInfoBtn;
    
    // JUST FOR TEST!!!!!!
    [SWLoginUser loginWithUserName:@"John" PassWord:@"123"];
    [SWLoginUser sharedInstance].userImage = [UIImage imageNamed:@"testUserHead"];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.collectionView reloadData];
    
    [self.navigationController.navigationBar setTranslucent:NO];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
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
                subTitleLab.text = [NSString stringWithFormat:@"(%ld)", (unsigned long)[SWLoginUser getUserWrongQuestions].count];
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
                subTitleLab.text = [NSString stringWithFormat:@"(%ld)", (unsigned long)[SWLoginUser getUserMarkedQuestions].count];
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
        TestQuestionViewType viewType;
        switch (indexPath.row) {
            case 0:  // 顺序答题
            {
                [self genSequenceQuestionDatas];
                viewType = kTestQuestionViewSequence;
            }
                break;
            case 1:  // 模拟练习
            {
                viewType = kTestQuestionViewTest;
            }
                break;
            case 2:  // 浏览题库
            {
                [self genGlanceDatas];
                viewType = kTestQuestionViewGlance;
            }
                break;
            case 3:  // 错题集
            {
                [self genWrongQuestionDatas];
                viewType = kTestQuestionViewWrongQuestions;
            }
                break;
            default:
                break;
        }
        SWQuestionPageViewController *pagesVC = nil;
        if (indexPath.row == 0) {
            pagesVC = [[SWQuestionPageViewController alloc] initWithContentViewsCount:self.pageDataArray.count type:kOptimizedPageController switchToPage:[SWLoginUser loadUserQuestionIndex].integerValue];
        }else
        {
            pagesVC = [[SWQuestionPageViewController alloc] initWithContentViewsCount:self.pageDataArray.count type:kOptimizedPageController];
        }
        
        pagesVC.delegate = self;
        pagesVC.questionPageType = viewType;
        
        [self.navigationController pushViewController:pagesVC animated:YES];
        
    }else if(indexPath.section == 1)
    {
        switch (indexPath.row) {
            case 0:  // 我的收藏
            {
                NSInteger markCount = [self genMarkedQuestionDatas];
                if (markCount == 0) {
                    return;
                }
                SWQuestionPageViewController *pagesVC = [[SWQuestionPageViewController alloc] initWithContentViewsCount:self.pageDataArray.count type:kOptimizedPageController];
                pagesVC.delegate = self;
                pagesVC.questionPageType = kTestQuestionViewMark;
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
-(NSArray *) genTestViews
{
    UIView *redView = [[UIView alloc] init];
    redView.backgroundColor = [UIColor redColor];
    
    UIView *yellowView = [[UIView alloc] init];
    yellowView.backgroundColor = [UIColor yellowColor];
    
    UIView *brownView = [[UIView alloc] init];
    brownView.backgroundColor = [UIColor brownColor];
    
    UIView *greenView = [[UIView alloc] init];
    greenView.backgroundColor = [UIColor greenColor];
    
    UIView *grayView = [[UIView alloc] init];
    grayView.backgroundColor = [UIColor grayColor];
    
    UIView *blueView = [[UIView alloc] init];
    blueView.backgroundColor = [UIColor blueColor];
    
    NSArray *retArray = @[redView, yellowView, brownView, greenView, grayView, blueView];
    return retArray;
}
- (NSInteger) genSequenceQuestionDatas
{
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SWQuestionItems" inManagedObjectContext:appDelegate.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Specify how the fetched objects should be sorted
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"questionID"
                                                                   ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];


    NSError *error = nil;
    NSArray *fetchedObjects = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    self.pageDataArray = fetchedObjects;
    return self.pageDataArray.count;
}

- (NSInteger) genMarkedQuestionDatas
{
    NSSet * userMarkedQuestionsSet = [SWLoginUser getUserMarkedQuestions];
    NSMutableArray *markedQuestionDatas = [[NSMutableArray alloc] init];
    for (SWQuestionItems *question in userMarkedQuestionsSet) {
        [markedQuestionDatas addObject:question];
    }
    self.pageDataArray = markedQuestionDatas;
    return self.pageDataArray.count;
}

- (NSInteger) genWrongQuestionDatas
{
    NSSet * userWrongQuestionsSet = [SWLoginUser getUserWrongQuestions];
    NSMutableArray *wrongQuestionDatas = [[NSMutableArray alloc] init];
    for (SWQuestionItems *question in userWrongQuestionsSet) {
        [wrongQuestionDatas addObject:question];
    }
    self.pageDataArray = wrongQuestionDatas;
    return self.pageDataArray.count;
}

- (NSInteger) genGlanceDatas
{
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"SWQuestionItems" inManagedObjectContext:appDelegate.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"questionID"
                                                                   ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptor, nil]];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [appDelegate.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    self.pageDataArray = fetchedObjects;
    return self.pageDataArray.count;
}


#pragma mark NavigationItem Response
- (void) showSlideMenuBtnPressed:(UIBarButtonItem *) barItem
{
    [[NSNotificationCenter defaultCenter] postNotificationName:USER_PRESS_SHOW_SIDE_MENU_BTN object:nil];
}

- (void) userInfoBtnPressed:(UIGestureRecognizer *) gestureRec
{
    SWUserInfoConfigViewController *configViewController = [[SWUserInfoConfigViewController alloc] init];
    configViewController.view.backgroundColor = [UIColor blueColor];
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate.rootNavigationController pushViewController:configViewController animated:YES];
    
}

#pragma mark - SWPageViewControllerDelegate

-(UIView *) swpageViewController:(SWPageViewController *)pageViewController pageForIndex:(NSInteger)pageNum
{
    if (pageNum < self.pageDataArray.count) {
        SWQuestionItems *question = self.pageDataArray[pageNum];
        SWQuestionPageViewController* questionPageVC = (SWQuestionPageViewController *)pageViewController;
         SWDriverTestQuestionView *questionView = [[SWDriverTestQuestionView alloc] initWithQuestion:question viewType:questionPageVC.questionPageType];
        return questionView;
    }
    
    return nil;
}

-(id) swpageViewController:(SWPageViewController *) pageViewController pageDataForIndex:(NSInteger) pageNum
{
    if (pageNum < self.pageDataArray.count) {
        return self.pageDataArray[pageNum];
    }
    return nil;
}


@end
