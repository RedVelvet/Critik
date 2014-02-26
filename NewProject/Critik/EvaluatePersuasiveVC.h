//
//  EvaluatePersuasiveVC.h
//  Critik
//
//  Created by Dalton Decker on 2/25/14.
//  Copyright (c) 2014 RedVelvet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Student.h"

@interface EvaluatePersuasiveVC : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *SpeechSectionsTable;
@property Student * currentStudent;
@property NSArray * SpeechSections;

@end
