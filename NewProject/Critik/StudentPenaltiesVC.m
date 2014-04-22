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

-(void)viewWillAppear:(BOOL)animated{
    int minutes = ([self.currentStudentSpeech.duration intValue] / 60.0);
    
    // We calculate the seconds.
    int seconds = ([self.currentStudentSpeech.duration intValue] - (minutes * 60));
    
    // We update our Label with the current time.
    self.duration.text = [NSString stringWithFormat:@"%u:%02u", minutes, seconds];
    
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //set title of page
    self.navigationItem.title = @"Penalties";
    
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
    
    //Create error variable to use for saving to core data
    NSError * error;
    //This is the string that is going to be compared to the input string
    NSString *testString = [NSString string];
    NSScanner *scanner = [NSScanner scannerWithString:self.penaltyPoints.text];
    //This is the character set containing all digits. It is used to filter the input string
    NSCharacterSet *skips = [NSCharacterSet characterSetWithCharactersInString:@"1234567890"];
    
    //This goes through the input string and puts all the
    //characters that are digits into the new string
    [scanner scanCharactersFromSet:skips intoString:&testString];
    //If the string containing all the numbers has the same length as the input...
    if([self.penaltyPoints.text length] != [testString length]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Penalties Error" message: @"Penalties must be a number greater than or equal to 0" delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        
    }else{
        
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

}

#pragma mark Keyboard

- (void)viewWillDisappear:(BOOL)animated
{

    // unregister for keyboard notifications while not visible.
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
//    
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

@end
