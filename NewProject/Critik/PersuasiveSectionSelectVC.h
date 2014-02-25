//
//  PersuasiveSectionSelectVC.h
//  Critik
//
//  Created by Dalton Decker on 2/21/14.
//  Copyright (c) 2014 RedVelvet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Section.h"
#import "Student.h"
#import "AppDelegate.h"


@interface PersuasiveSectionSelectVC : UIViewController

@property NSArray * sections;
@property NSArray * students;

@property (weak, nonatomic) IBOutlet UIPickerView *SectionPicker;
@property (weak, nonatomic) IBOutlet UITableView *StudentTable;

@end
