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

@property (weak, nonatomic) IBOutlet UITableView *SpeechSections;
@property Student * currentStudent;
@property NSArray * sections; 

@end
