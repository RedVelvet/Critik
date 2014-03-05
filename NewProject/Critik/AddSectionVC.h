//
//  AddSectionVC.h
//  Critik
//
//  Created by Doug Wettlaufer on 2/18/14.
//  Copyright (c) 2014 RedVelvet. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DismissPopoverDelegate
- (void) dismissPopover:(NSArray *)addContentArray;
@end

@interface AddSectionVC : UIViewController

@property (nonatomic, assign) id<DismissPopoverDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITextField *sectionTextField;
- (IBAction)cancelPopover:(id)sender;
@end
