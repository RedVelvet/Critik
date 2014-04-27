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
#import "QuickGrade.h"
#import "PreDefinedComments.h"
#import "Module.h"
#import "StudentPenaltiesVC.h"
#import "StudentSpeech.h"
#import "Speech.h"
#import <objc/runtime.h>
#import "AdditionalCommentsPopoverVC.h"

@interface StudentEvaluationVC : UIViewController



@property (weak, nonatomic) IBOutlet UILabel * timerLabel;
@property (weak, nonatomic) IBOutlet UIButton * timerButton;
@property (weak, nonatomic) IBOutlet UIButton *timerResetButton;
@property (weak, nonatomic) IBOutlet UILabel * modulePoints;
@property (weak, nonatomic) IBOutlet UITextField * moduleGrade;
@property (weak, nonatomic) IBOutlet UILabel *moduleLabel;

@property (weak, nonatomic) IBOutlet UITableView *leftQuickGradeTable;
@property (weak, nonatomic) IBOutlet UITableView *rightQuickGradeTable;

@property (weak, nonatomic) IBOutlet UITableView * ModuleTable;
@property (weak, nonatomic) IBOutlet UITableView * PreDefinedCommentsTable;

@property NSString * currentSpeechName;
@property Student * currentStudent;
@property StudentSpeech * currentStudentSpeech;
@property Speech * currentSpeech;
@property Module * currentModule;

@property NSMutableArray * SpeechModules;
@property NSMutableArray * QuickGrades;
@property NSMutableArray * leftQuickGrades;
@property NSMutableArray * rightQuickGrades;
@property NSMutableArray * PreDefComments;
@property NSMutableArray * WrittenComments;

- (void) splitQuickGradesArray;
- (IBAction)continueToFinalize:(id)sender;
- (IBAction)startStopTimer:(id)sender;
- (IBAction)resetTimer:(id)sender;
- (void) update;

@end
