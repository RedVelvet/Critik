//
//  StudentEvaluationVC.h
//  Critik
//
//  Created by Dalton Decker on 3/1/14.
//  Copyright (c) 2014 RedVelvet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Student.h"

@interface StudentEvaluationVC : UIViewController

@property (weak, nonatomic) IBOutlet UISegmentedControl *mySegmentedControl;

@property (weak, nonatomic) IBOutlet UILabel *moduleTitle;
@property (weak, nonatomic) IBOutlet UILabel *modulePoints;
@property (weak, nonatomic) IBOutlet UITextField *moduleGrade;
@property (weak, nonatomic) IBOutlet UILabel *quickGradeTitle;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITableView *leftQuickGrade;
@property (weak, nonatomic) IBOutlet UITableView *rightQuickGrade;

@property (weak, nonatomic) IBOutlet UITableView * ModuleTable;

@property Student * currentStudent;
@property NSString * currentSpeech;

@property NSArray * SpeechSections;
@property NSArray * QuickGrades;
@property NSArray * PreDefStatements;
@property NSArray * WrittenComments;

@end
