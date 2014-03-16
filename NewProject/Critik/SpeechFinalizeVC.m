//
//  SpeechFinalizeVC.m
//  Critik
//
//  Created by Dalton Decker on 3/3/14.
//  Copyright (c) 2014 RedVelvet. All rights reserved.
//

#import "SpeechFinalizeVC.h"

@interface SpeechFinalizeVC ()

@end

@implementation SpeechFinalizeVC

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)homepageButton:(id)sender
{
    NSString *unwindSegueIdentifier = @"unwindSegueToStudentSelection";
    UIViewController * selectStudents = [self.storyboard instantiateViewControllerWithIdentifier:@"Homepage"];
    UIStoryboardSegue *unwindSegue = [self.navigationController segueForUnwindingToViewController: selectStudents fromViewController: self identifier: unwindSegueIdentifier];
    
    [selectStudents prepareForSegue: unwindSegue sender: self];
    
    [unwindSegue perform];
}
-(IBAction)evaluateStudents:(id)sender
{
    NSString *unwindSegueIdentifier = @"unwindSegueToStudentSelection";
    UIViewController * selectStudents = [self.storyboard instantiateViewControllerWithIdentifier:@"Student Selection"];
    UIStoryboardSegue *unwindSegue = [self.navigationController segueForUnwindingToViewController: selectStudents fromViewController: self identifier: unwindSegueIdentifier];
    
    [selectStudents prepareForSegue: unwindSegue sender: self];
    
    [unwindSegue perform];
}


- (IBAction)unwindToStudentSelection:(UIStoryboardSegue *)unwindSegue
{
    UIViewController* sourceViewController = unwindSegue.sourceViewController;
    
    [sourceViewController isKindOfClass:[StudentSelectionVC class]];
    
}
@end
