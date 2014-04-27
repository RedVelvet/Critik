//
//  StudentPenaltiesVC.m
//  Critik
//
//  Created by Dalton Decker on 3/2/14.
//  Copyright (c) 2014 RedVelvet. All rights reserved.
//

#import "StudentPenaltiesVC.h"

#define kOFFSET_FOR_KEYBOARD 80.0

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

-(void)viewWillAppear:(BOOL)animated{
    int minutes = ([self.currentStudentSpeech.duration intValue] / 60.0);
    
    // We calculate the seconds.
    int seconds = ([self.currentStudentSpeech.duration intValue] - (minutes * 60));
    
    // We update our Label with the current time.
    self.duration.text = [NSString stringWithFormat:@"%u:%02u", minutes, seconds];
    
    // register for keyboard notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //set title of page
    self.navigationItem.title = @"Penalties";
    
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
    Speech * currentSpeech = self.currentStudentSpeech.speech;
    NSArray * modules = [currentSpeech.modules allObjects];
    int pointsPossible = 0;
    for(int i = 0; i < [modules count]; i ++){
        Module * currentModule = [modules objectAtIndex:i];
        pointsPossible += [currentModule.pointsPossible intValue];
    }
    
    //This is the string that is going to be compared to the input string
    NSString *testString = [NSString string];
    NSScanner *scanner = [NSScanner scannerWithString:self.penaltyPoints.text];
    //This is the character set containing all digits. It is used to filter the input string
    NSCharacterSet *skips = [NSCharacterSet characterSetWithCharactersInString:@"1234567890"];
    //This goes through the input string and puts all the characters that are digits into the new string
    [scanner scanCharactersFromSet:skips intoString:&testString];
    
    //If the string containing all the numbers has the same length as the input...
    if([self.penaltyPoints.text length] != [testString length] || ([self.currentStudentSpeech.pointsEarned intValue] - [self.penaltyPoints.text intValue])  < 0) {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle: @"Penalties Error" message: @"Penalties must be a number greater than or equal to 0 and can not bring total points to a negative." delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        
        [alert show];
        
    }else{
        self.currentStudentSpeech.penaltyPoints = [NSNumber numberWithInt: [self.penaltyPoints.text intValue]];
        self.currentStudentSpeech.totalPoints = [NSNumber numberWithInt:([self.currentStudentSpeech.pointsEarned intValue]-[self.currentStudentSpeech.penaltyPoints intValue]) ];

        
        //Create new Finalize view controller and push to view with currentStudent and currentStudentSpeech
        SpeechFinalizeVC * finalize = [self.storyboard instantiateViewControllerWithIdentifier:@"Finalize"];
        finalize.currentStudent = self.currentStudent;
        finalize.currentStudentSpeech = self.currentStudentSpeech;
        finalize.pointsPossible = pointsPossible;
        [self.navigationController pushViewController:finalize animated:YES];
    }

}

#pragma mark Keyboard

- (void)viewWillDisappear:(BOOL)animated
{
    //Save duration, comments and penalty points to core data
    self.currentStudentSpeech.duration = [NSNumber numberWithInt:[self.penaltyPoints.text intValue]];
    self.currentStudentSpeech.comments = self.additionalComments.text;
    self.currentStudentSpeech.penaltyPoints = [NSNumber numberWithInt: [self.penaltyPoints.text intValue]];
    
    self.currentStudentSpeech.penaltyPoints = [NSNumber numberWithInt:[self.penaltyPoints.text intValue]];
    
    //Generate points earned, and total points based on penalty points
    NSArray * allModules = [self.currentStudentSpeech.speech.modules allObjects];
    int pointsEarned = 0;
    int pointsPossible = 0;
    for(int i = 0; i < [allModules count]; i++){
        Module * currentModule = [allModules objectAtIndex:i];
        
        pointsEarned += [currentModule.points intValue];
        pointsPossible += [currentModule.pointsPossible intValue];
    }
    
    self.currentStudentSpeech.pointsEarned = [NSNumber numberWithInt:pointsEarned];
    
    self.currentStudentSpeech.totalPoints = [NSNumber numberWithInt:(pointsEarned-[self.penaltyPoints.text intValue])];
    
    
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

    
    //Create error variable to use for saving to core data
    NSError * error;
    //save managagedObjectContext
    if(![self.managedObjectContext save:&error])
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle: @"Warning!" message: @"Presentation could not be saved."delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
    
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

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
    if ([sender isEqual:self.additionalComments])
    {
        //move the main view, so that the keyboard does not hide it.
        if  (self.view.frame.origin.y >= 0)
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

@end
