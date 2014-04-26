//
//  MenuPopoverVC.h
//  Critik
//
//  Created by Doug Wettlaufer on 4/26/14.
//  Copyright (c) 2014 RedVelvet. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol DismissPopoverDelegate
- (void) dismissPopover:(NSArray *)addContentArray;
@end

@interface MenuPopoverVC : UIViewController

@property (nonatomic, assign) id<DismissPopoverDelegate> delegate;
@property NSInteger sendingButtonTag;
@property (weak, nonatomic) IBOutlet UIButton *dropboxBtn;

@end
