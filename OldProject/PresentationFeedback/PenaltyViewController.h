//
//  PenaltyViewController.h
//  PresentationFeedback
//
//  Created by Gautham raaz on 11/21/13.
//  Copyright (c) 2013 Gautham raaz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EvaluationViewController.h"
#import "DetailViewController.h"
#import "MasterViewController.h"

@interface PenaltyViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *penaltiesValue;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
- (IBAction)finalizeButtonPressed:(id)sender;
- (IBAction)backButtonPressed:(id)sender;

@end
