//
//  SWDriverTestMainViewController.m
//  SWDriverTestBingo
//
//  Created by EShi on 12/10/15.
//  Copyright © 2015 Eren. All rights reserved.
//

#import "SWDriverTestMainViewController.h"
#import "CollectionLayoutForDriverTestMain.h"
#import "SWDriverTestMainCollectionViewCell.h"
#import "SWDriverTestCellView.h"
#define NAV_BAR_HEIGHT 60
static NSString *IMG_COL_CELL_IDENTITY = @"IMG_COL_CELL_IDENTITY";

@interface SWDriverTestMainViewController ()<UICollectionViewDataSource, UICollectionViewDelegate>
@property(nonatomic, strong) UICollectionView *collectionView;
@end

@implementation SWDriverTestMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // set collectionView and layout
    [self makeUpCollectionView];
    // makeup navigationbar
    [self makeUpNavigationBar];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

#pragma mark INIT/Set up UI
-(void) makeUpCollectionView
{
    CollectionLayoutForDriverTestMain *layout = [[CollectionLayoutForDriverTestMain alloc] init];
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) collectionViewLayout:layout];
    _collectionView.dataSource =self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor lightGrayColor];
    [_collectionView registerClass:[SWDriverTestMainCollectionViewCell class] forCellWithReuseIdentifier:IMG_COL_CELL_IDENTITY];
    [self.view addSubview:_collectionView];
}

-(void) makeUpNavigationBar
{
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
    NSLog(@"Now select %@", indexPath);
}

@end
