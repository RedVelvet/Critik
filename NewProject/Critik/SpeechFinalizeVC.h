//
//  SpeechFinalizeVC.h
//  Critik
//
//  Created by Dalton Decker on 3/3/14.
//  Copyright (c) 2014 RedVelvet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>
#import "AppDelegate.h"
#import "StudentSelectionVC.h"
#import "PDFHelper.h"
#import "HomeVC.h"
#import "StudentSelectionVC.h"

@interface SpeechFinalizeVC : UIViewController 

@property Student * currentStudent;
@property StudentSpeech * currentStudentSpeech;

- (IBAction)homepageButton:(id)sender;
- (IBAction)evaluateStudents:(id)sender;
-(IBAction)generatePDF:(id)sender;


@end
