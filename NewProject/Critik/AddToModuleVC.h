//
//  AddToModuleVC.h
//  Critik
//
//  Created by Doug Wettlaufer on 3/1/14.
//  Copyright (c) 2014 RedVelvet. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DismissPopoverDelegate
- (void) dismissPopover:(NSArray *)addContentArray;
@end

@interface AddToModuleVC : UIViewController

@property (nonatomic, assign) id<DismissPopoverDelegate> delegate;
@property NSInteger sendingButtonTag;
@property (weak, nonatomic) IBOutlet UILabel *addLabel;
@property (weak, nonatomic) IBOutlet UITextField *addTF;

- (IBAction)cancelPopover:(id)sender;
- (IBAction)savePopoverContent:(id)sender;

@end
