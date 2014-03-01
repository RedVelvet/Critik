//
//  AddToModuleVC.h
//  Critik
//
//  Created by Doug Wettlaufer on 3/1/14.
//  Copyright (c) 2014 RedVelvet. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DismissPopoverDelegate
- (void) dismissPopover:(NSObject *)yourDataToTransfer;
@end

@interface AddToModuleVC : UIViewController

@property (weak) id<DismissPopoverDelegate> delegate;
@property NSInteger sendingButtonTag;
@end
