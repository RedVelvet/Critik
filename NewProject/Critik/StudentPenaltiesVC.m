//
//  StudentPenaltiesVC.m
//  Critik
//
//  Created by Dalton Decker on 3/2/14.
//  Copyright (c) 2014 RedVelvet. All rights reserved.
//

#import "StudentPenaltiesVC.h"
#define kOFFSET_FOR_KEYBOARD 352.0

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
    self.penaltyPoints.text = [NSString stringWithFormat:@"%@",self.currentStudentSpeech.penaltyPoints];
    self.additionalComments.text = self.currentStudentSpeech.comments;
    
    if([self.currentStudentSpeech.isLate isEqualToString:@"true"]){
        [self.latePresentation setOn:YES];
    }
    if([self.currentStudentSpeech.overTime isEqualToString:@"true"]){
        [self.overTime setOn:YES];
    }
    
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
    
    //Create new Finalize view controller and push to view with currentStudent and currentStudentSpeech
    SpeechFinalizeVC * finalize = [self.storyboard instantiateViewControllerWithIdentifier:@"Finalize"];
    finalize.currentStudent = self.currentStudent;
    finalize.currentStudentSpeech = self.currentStudentSpeech;
    [self.navigationController pushViewController:finalize animated:YES];
}

#pragma mark Keyboard
-(void)keyboardWillShow {
    // Animate the current view out of the way
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

-(void)keyboardWillHide {
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)sender
{
    if ([sender tag] == 1)
    {
        //move the main view, so that the keyboard does not hide it.
        if  (self.view.frame.origin.y >= 0 )
        {
            [self setViewMovedUp:YES];
        }
    }
}

//method to move the view up/down whenever the keyboard is shown/dismissed
-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGRect rect = self.view.frame;
    if (movedUp)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        rect.origin.y -= kOFFSET_FOR_KEYBOARD;
        rect.size.height += kOFFSET_FOR_KEYBOARD;
    }
    else
    {
        // revert back to the normal state.
        rect.origin.y += kOFFSET_FOR_KEYBOARD;
        rect.size.height -= kOFFSET_FOR_KEYBOARD;
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
}


- (void)viewWillAppear:(BOOL)animated
{
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    //Create error variable to use for saving to core data
    NSError * error;
    //Save duration, comments and penalty points to core data
    self.currentStudentSpeech.duration = [NSNumber numberWithInt:[self.penaltyPoints.text intValue]];
    self.currentStudentSpeech.comments = self.additionalComments.text;
    self.currentStudentSpeech.penaltyPoints = [NSNumber numberWithInt:[self.penaltyPoints.text intValue]];
    
    //if switch is selected for late presentation, store true in core data for speech being late
    if(self.latePresentation.isOn){
        self.currentStudentSpeech.isLate = @"true";
    }else{
        self.currentStudentSpeech.isLate = @"false";
    }
    
    //if switch is selected for over time, store true in core data for speech not meeting time constraints
    if(self.overTime.isOn){
        self.currentStudentSpeech.overTime = @"true";
    }else{
        self.currentStudentSpeech.overTime = @"false";
    }
    
    //Takes addtional comments professor types in and stores in core data with speech
    self.currentStudentSpeech.comments = self.additionalComments.text;
    
    //save managagedObjectContext
    if(![self.managedObjectContext save:&error])
    {
        NSLog(@"Can't Save duration %@",[error localizedDescription]);
    }
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

@end
