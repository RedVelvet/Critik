//
//  StudentPenaltiesVC.m
//  Critik
//
//  Created by Dalton Decker on 3/2/14.
//  Copyright (c) 2014 RedVelvet. All rights reserved.
//

#import "StudentPenaltiesVC.h"

@interface StudentPenaltiesVC ()
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@end

@implementation StudentPenaltiesVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //set title of page
    self.navigationItem.title = @"Penalties";
    
    //print out the duration of the presentation
    NSNumber * duration = self.currentStudentSpeech.duration;
    int minutes = [duration intValue]/60;
    int seconds = [duration intValue] - (minutes * 60);
    self.duration.text = [NSString stringWithFormat:@"%d:%d",minutes,seconds];
    
    //set app delegate and managedObject
    AppDelegate * appDelegate = [UIApplication sharedApplication].delegate;
    self.managedObjectContext = [appDelegate managedObjectContext];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)Finalize:(id)sender
{
    //Create error variable to use for saving to core data
    NSError * error;
    //Save duration, comments and penalty points to core data
    self.currentStudentSpeech.duration = [NSNumber numberWithInt:[self.penaltyPoints.text intValue]];
    self.currentStudentSpeech.comments = self.additionalComments.text;
    self.currentStudentSpeech.penaltyPoints = [NSNumber numberWithInt:[self.penaltyPoints.text intValue]];
//    [self.currentStudentSpeech setValue: [NSNumber numberWithInt:[self.penaltyPoints.text intValue]]  forKey:@"duration"];
//    [self.currentStudentSpeech setValue:self.additionalComments.text forKey:@"comments"];
    
    //if switch is selected for late presentation, store true in core data for speech being late
    if(self.latePresentation.isOn){
        self.currentStudentSpeech.isLate = @"true";
//        [self.currentStudentSpeech setValue:[NSString stringWithFormat:@"%@",@"true"] forKeyPath:@"isLate"];
    }
    //if switch is selected for over time, store true in core data for speech not meeting time constraints
    if(self.overTime.isOn){
        self.currentStudentSpeech.overTime = @"true";
//        [self.currentStudentSpeech setValue:[NSString stringWithFormat:@"%@",@"true"] forKeyPath:@"overTime"];
    }
    
    //Takes addtional comments professor types in and stores in core data with speech
    self.currentStudentSpeech.comments = self.additionalComments.text;
//    [self.currentStudentSpeech setValue: self.additionalComments.text forKeyPath:@"comments"];
    
    //save managagedObjectContext
    if(![self.managedObjectContext save:&error])
    {
        NSLog(@"Can't Save duration %@",[error localizedDescription]);
    }
    
    
    //Create new Finalize view controller and push to view with currentStudent and currentStudentSpeech
    SpeechFinalizeVC * finalize = [self.storyboard instantiateViewControllerWithIdentifier:@"Finalize"];
    finalize.currentStudent = self.currentStudent;
    finalize.currentStudentSpeech = self.currentStudentSpeech;
    [self.navigationController pushViewController:finalize animated:YES];
}

@end
