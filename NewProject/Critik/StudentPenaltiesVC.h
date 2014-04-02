//
//  StudentPenaltiesVC.h
//  Critik
//
//  Created by Dalton Decker on 3/2/14.
//  Copyright (c) 2014 RedVelvet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpeechFinalizeVC.h"
#import "AppDelegate.h"

@interface StudentPenaltiesVC : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *duration;
@property (weak, nonatomic) IBOutlet UITextField *penaltyPoints;
@property (weak, nonatomic) IBOutlet UISwitch *overTime;
@property (weak, nonatomic) IBOutlet UISwitch *latePresentation;
@property (weak, nonatomic) IBOutlet UITextView *additionalComments;

@property Student * currentStudent;
@property StudentSpeech * currentStudentSpeech;

@end
