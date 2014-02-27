//
//  EvaluateInformativeVC.h
//  Critik
//
//  Created by Dalton Decker on 2/25/14.
//  Copyright (c) 2014 RedVelvet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Student.h"

@interface EvaluateInformativeVC : UIViewController
@property (weak, nonatomic) IBOutlet UISegmentedControl *mySegmentedControl;

@property (weak, nonatomic) IBOutlet UIScrollView *ScrollView;
@property (weak, nonatomic) IBOutlet UITableView *SpeechSectionsTable;
@property Student * currentStudent;
@property NSArray * SpeechSections;
@property NSArray * QuickGrades;
@property NSArray * PreDefStatements;
@property NSArray * WrittenComments;

@end
