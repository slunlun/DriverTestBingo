//
//  SWDrag2ShowMenuViewController.h
//  SWDriverTestBingo
//
//  Created by EShi on 12/10/15.
//  Copyright © 2015 Eren. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SWDrag2ShowMenuViewController : UIViewController
@property(nonatomic, weak) UIViewController *contentViewController;
@property(nonatomic, weak) UIViewController *menuContentViewController;

@property(nonatomic) CGFloat menuViewWidth;
@property(nonatomic) CGFloat menuViewSlideInWidth;

-(void) showSlideMenu;
- (void) closeSideMenu;
//-(void) switchSlideBarState;
-(instancetype) initWithContentView:(UIViewController *) contentViewController sideMenuView:(UIViewController *) sideMenuViewController;
@end
