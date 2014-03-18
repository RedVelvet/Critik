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

@interface StudentEvaluationVC : UIViewController


@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
@property (weak, nonatomic) IBOutlet UIButton *startTimer;
@property (weak, nonatomic) IBOutlet UILabel *modulePoints;
@property (weak, nonatomic) IBOutlet UITextField *moduleGrade;
@property (weak, nonatomic) IBOutlet UIButton * continueButton;

@property (weak, nonatomic) IBOutlet UITableView *leftQuickGradeTable;
@property (weak, nonatomic) IBOutlet UITableView *rightQuickGradeTable;

@property (weak, nonatomic) IBOutlet UITableView * ModuleTable;
@property (weak, nonatomic) IBOutlet UITableView * PreDefinedCommentsTable;

@property NSString * currentSpeechName;
@property Student * currentStudent;
@property StudentSpeech * currentStudentSpeech;
@property Speech * currentSpeech;
@property Module * currentModule;

@property NSArray * SpeechModules;
@property NSArray * QuickGrades;
@property NSArray * leftQuickGrades;
@property NSArray * rightQuickGrades;
@property NSArray * PreDefComments;
@property NSArray * WrittenComments;

-(void) splitQuickGradesArray;
- (IBAction)continueToFinalize:(id)sender;
//- (IBAction)startTimer:(id)sender;
//- (IBAction)resetTimer:(id)sender;

@end
