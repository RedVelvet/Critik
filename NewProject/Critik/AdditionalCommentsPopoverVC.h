//
//  AdditionalCommentsPopoverViewController.h
//  Critik
//
//  Created by Dalton Decker on 4/21/14.
//  Copyright (c) 2014 RedVelvet. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DismissPopoverDelegate
- (void) dismissPopover:(NSString *)additionalComments;
@end

@interface AdditionalCommentsPopoverVC : UIViewController

@property (weak, nonatomic) IBOutlet UITextView *comments;
@property (nonatomic, assign) id<DismissPopoverDelegate> delegate;

@end
