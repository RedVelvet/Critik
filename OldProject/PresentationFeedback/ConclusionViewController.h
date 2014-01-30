//
//  ConclusionViewController.h
//  PresentationFeedback
//
//  Created by Gautham raaz on 7/28/13.
//  Copyright (c) 2013 Gautham raaz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "EvaluationViewController.h"

@interface ConclusionViewController : UIViewController
{
    NSMutableArray *quickGrades;
    BOOL checked;
}


@property (weak, nonatomic) IBOutlet UILabel *QuickGradeLabel;
@property (nonatomic, strong) NSMutableArray *quickGrades;

- (IBAction)checkButton:(id)sender;
- (IBAction)checkQuickGrade:(id)sender;
- (IBAction)saveAndContinue:(id)sender;


@property (weak, nonatomic) IBOutlet UILabel *lable1;



@end
