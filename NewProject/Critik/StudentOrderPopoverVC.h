//
//  StudentOrderPopoverVC.h
//  Critik
//
//  Created by Dalton Decker on 3/17/14.
//  Copyright (c) 2014 RedVelvet. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DismissPopoverDelegate
- (void) dismissPopover:(NSString *)order;
@end


@interface StudentOrderPopoverVC : UIViewController

@property (nonatomic, assign) id<DismissPopoverDelegate> delegate;

- (IBAction)savePopoverContent:(id)sender;
@end
