//
//  EditInformativeVC.h
//  Critik
//
//  Created by Dalton Decker on 2/27/14.
//  Copyright (c) 2014 RedVelvet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DualColumnCell.h"
#import "AppDelegate.h"
#import "PreDefinedComments.h"
#import "QuickGrade.h"

@interface EditInformativeVC : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *QuickGradeTable;
@property (weak, nonatomic) IBOutlet UIScrollView *ScrollView;

@property NSArray * quickGrades;
@property NSArray * preDefinedComments;



@end
