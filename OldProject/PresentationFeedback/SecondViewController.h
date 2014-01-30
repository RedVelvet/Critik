//
//  SecondViewController.h
//  PresentationFeedback
//
//  Created by Gautham on 7/28/13.
//  Copyright (c) 2013 Gautham. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

@interface SecondViewController : UIViewController
{
    NSMutableArray *quickGrades;
    BOOL checked;
}

@property (weak, nonatomic) IBOutlet UILabel *QuickGradeLabel;
@property (nonatomic, strong) NSMutableArray *quickGrades;

- (IBAction)checkButton:(id)sender;
- (IBAction)checkQuickGrade:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *lable1;

@property (strong, nonatomic) IBOutlet UITextView *textViewDidBeginEditing;



@end
