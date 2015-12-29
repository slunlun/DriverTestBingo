//
//  SWMainContentViewController.h
//  SWDriverTestBingo
//
//  Created by EShi on 12/10/15.
//  Copyright © 2015 Eren. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWDrag2ShowMenuViewController.h"

@interface SWMainContentTabBarController : UITabBarController
@property(nonatomic, weak) SWDrag2ShowMenuViewController *drag2ShowMenuVC;
@end
