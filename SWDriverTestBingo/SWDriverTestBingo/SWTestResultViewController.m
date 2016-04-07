//
//  SWTestResultViewController.m
//  SWDriverTestBingo
//
//  Created by EShi on 4/7/16.
//  Copyright © 2016 Eren. All rights reserved.
//

#import "SWTestResultViewController.h"

@interface SWTestResultViewController ()
@property(nonatomic) NSInteger testScore;
@property(nonatomic, strong) UILabel *scoreLabel;
@property(nonatomic, strong) UILabel *scoreCommentLabel;
@end

@implementation SWTestResultViewController

-(instancetype) initWithUserTestScore:(NSInteger) testScore
{
    self = [super init];
    if (self) {
        _testScore = testScore;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _scoreLabel = [[UILabel alloc] init];
    
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    self.navigationController.navigationBarHidden = NO;
    [self setupUIs];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) setupUIs
{
    _scoreLabel = [[UILabel alloc] init];
    _scoreLabel.translatesAutoresizingMaskIntoConstraints = NO;
   // _scoreLabel.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:_scoreLabel];
    
    _scoreCommentLabel = [[UILabel alloc] init];
    _scoreCommentLabel.translatesAutoresizingMaskIntoConstraints = NO;
  //  _scoreCommentLabel.backgroundColor = [UIColor redColor];
    [self.view addSubview:_scoreCommentLabel];
    
    NSInteger scoreLabelHeight = self.view.frame.size.height / 2;
    NSInteger scoreCommentLabelHeight = self.view.frame.size.height / 4;
    
    NSDictionary *viewsSizeDic = @{@"scoreLabelHeight":[[NSNumber alloc ]initWithInteger:scoreLabelHeight], @"scoreCommentLabelHeight":[[NSNumber alloc]initWithInteger:scoreCommentLabelHeight]};
    NSDictionary *viewsDic = @{@"scoreLabel":_scoreLabel, @"scoreCommentLabel":_scoreCommentLabel};
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[scoreLabel]|" options:0 metrics:viewsSizeDic views:viewsDic]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[scoreCommentLabel]-|" options:0 metrics:viewsSizeDic views:viewsDic]];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(20)-[scoreLabel(==scoreLabelHeight)][scoreCommentLabel(==scoreCommentLabelHeight)]" options:0 metrics:viewsSizeDic views:viewsDic]];
    
    [self setupLabelContents];
    
}

-(void) setupLabelContents
{
    _scoreLabel.text = [NSString stringWithFormat:@"%ld分", self.testScore];
    _scoreLabel.textColor = [UIColor redColor];
    _scoreLabel.font = [UIFont fontWithName:@"DBLCDTempBlack" size:60];
    _scoreLabel.textAlignment = NSTextAlignmentCenter;
    if (self.testScore < 60) {
        _scoreCommentLabel.text = @"NO";
    }else if(self.testScore >= 60 && self.testScore < 90)
    {
        _scoreCommentLabel.text = @"Do again";
        
    }else if(self.testScore >= 90 && self.testScore < 95)
    {
        _scoreCommentLabel.text = @"Do better!";
        
    }else
    {
        _scoreCommentLabel.text = @"Great!!";
    }
    _scoreCommentLabel.textAlignment = NSTextAlignmentCenter;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
