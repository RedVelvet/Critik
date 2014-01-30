//
//  DetailViewController.h
//  PresentationFeedback
//
//  Created by Gautham on 7/28/13.
//  Copyright (c) 2013 Gautham. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

@interface DetailViewController : UIViewController
{
    NSMutableArray *quickGrades;
    BOOL checked;
    UILabel *label;    
}
@property (weak, nonatomic) IBOutlet UILabel *QuickGradeLabel;
@property (nonatomic, strong) NSMutableArray *quickGrades;

- (IBAction)checkCommentButton:(id)sender;
- (IBAction)checkQuickGrade:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *lable1;




@end
