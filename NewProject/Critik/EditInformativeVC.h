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

@interface EditInformativeVC : UIViewController <UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *SpeechSectionsTable;

@property (weak, nonatomic) IBOutlet UITableView *QuickGradeTable1;
@property (weak, nonatomic) IBOutlet UITableView *QuickGradeTable2;

@property (weak, nonatomic) IBOutlet UITableView *PreDefTable1;


@property NSArray * quickGrades;
@property NSArray * preDefinedComments;
@property NSArray * SpeechSections;



@end
