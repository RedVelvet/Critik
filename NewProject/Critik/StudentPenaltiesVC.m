//
//  StudentPenaltiesVC.m
//  Critik
//
//  Created by Dalton Decker on 3/2/14.
//  Copyright (c) 2014 RedVelvet. All rights reserved.
//

#import "StudentPenaltiesVC.h"

@interface StudentPenaltiesVC ()

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
    self.navigationItem.title = @"Penalties";
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)Finalize:(id)sender
{
    SpeechFinalizeVC* finalize = [self.storyboard instantiateViewControllerWithIdentifier:@"Finalize"];
    finalize.currentStudent = self.currentStudent;
    finalize.currentStudentSpeech = self.currentStudentSpeech;
    [self.navigationController pushViewController:finalize animated:YES];
}

@end
