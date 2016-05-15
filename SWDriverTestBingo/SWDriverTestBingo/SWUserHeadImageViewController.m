//
//  SWUserHeadImageViewController.m
//  SWDriverTestBingo
//
//  Created by ShiTeng on 16/5/1.
//  Copyright © 2016年 Eren. All rights reserved.
//

#define HEAD_IMAGE_VIEW_MARGIN 80
#import "SWUserHeadImageViewController.h"
#import "SWLoginUser.h"
#import "SWMessageBox.h"

@interface SWUserHeadImageViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property(nonatomic, strong) UIImageView *userHeadImageView;
@property(nonatomic, strong) UIImagePickerController *imagePicker;
@end

@implementation SWUserHeadImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    // set up headimage view
    _userHeadImageView = [[UIImageView alloc] init];
    _userHeadImageView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:_userHeadImageView];
    NSDictionary *viewDict = @{@"UserHeadImageView":_userHeadImageView};
    NSDictionary *metricsDict = @{@"UserHeadImageView_Margin":@HEAD_IMAGE_VIEW_MARGIN};
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[UserHeadImageView]|" options:0 metrics:metricsDict views:viewDict]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(UserHeadImageView_Margin)-[UserHeadImageView]-(UserHeadImageView_Margin)-|" options:0 metrics:metricsDict views:viewDict]];
    
    // set up navigation bar
    self.navigationItem.title = NSLocalizedString(@"MyHeadImage", nil);
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"ChangeMyHeadImage", nil) style:UIBarButtonItemStylePlain target:self action:@selector(didClickChangeMyHeadImageButton:)];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    // set up imagePicker
    _imagePicker = [[UIImagePickerController alloc] init];
    _imagePicker.delegate = self;
    _imagePicker.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    _imagePicker.allowsEditing = YES;
   
    
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _userHeadImageView.image = [SWLoginUser sharedInstance].userImage;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
 
}

#pragma mark UIImagePickerController delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [self dismissViewControllerAnimated:_imagePicker completion:nil];
    UIImage *image=[info objectForKey:UIImagePickerControllerEditedImage];
    
    // update current user headImage
    if([[SWLoginUser sharedInstance] updateUserHeadImage:image])
    {
        _userHeadImageView.image = image;
    }else
    {
        // pop up error message
        UIImage *boxImage = [[SWLoginUser sharedInstance] getUserHeadImage];
        SWMessageBox *messageBox = [[SWMessageBox alloc] initWithTitle:NSLocalizedString(@"ChangeMyHeadImageError", nil) boxImage:boxImage boxType:SWMessageBoxType_OK buttonTitles:@[NSLocalizedString(@"OK", nil)] completeBlock:nil];
        [messageBox showMessageBoxInView:self.view];
    }
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:_imagePicker completion:nil];
}
#pragma mark - Event Response
-(void) didClickChangeMyHeadImageButton:(UIBarButtonItem *) barButtonItem
{
    UIAlertController *alterController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *takeHeadImageByPhoto = [UIAlertAction actionWithTitle:NSLocalizedString(@"TakePhoto", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:_imagePicker animated:YES completion:nil];
        
    }];
    UIAlertAction *takeHeadImageByPhotoLib = [UIAlertAction actionWithTitle:NSLocalizedString(@"TakeFromPhotoLibrary", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:_imagePicker animated:YES completion:nil];
        
    }];
    UIAlertAction *cancelTakeHeadImage = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancle", nil) style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alterController addAction:takeHeadImageByPhoto];
    [alterController addAction:takeHeadImageByPhotoLib];
    [alterController addAction:cancelTakeHeadImage];
    
    [self presentViewController:alterController animated:YES completion:nil];
    
}

@end
