//
//  StudentSelectionVC.h
//  Critik
//
//  Created by Dalton Decker on 3/1/14.
//  Copyright (c) 2014 RedVelvet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Section.h"
#import "Student.h"
#import "AppDelegate.h"
#import "StudentEvaluationVC.h"
#import "StudentOrderPopoverVC.h"

@interface StudentSelectionVC : UIViewController

@property NSMutableArray * sections;
@property NSMutableArray * students;

@property NSString * currSpeech;
@property Boolean isRandom;

@property (weak, nonatomic) IBOutlet UIPickerView *SectionPicker;
@property (weak, nonatomic) IBOutlet UITableView *StudentTable;



- (IBAction)setStudentOrder:(id)sender;

@end
