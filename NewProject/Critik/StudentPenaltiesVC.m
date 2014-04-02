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
    self.navigationItem.title = @"Penalties";
    AppDelegate * appDelegate = [UIApplication sharedApplication].delegate;
    self.managedObjectContext = [appDelegate managedObjectContext];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)Finalize:(id)sender
{
    
    [self.currentStudentSpeech.comments setValue: self.additionalComments.text forKeyPath:@"comments"];
    
    SpeechFinalizeVC * finalize = [self.storyboard instantiateViewControllerWithIdentifier:@"Finalize"];
    finalize.currentStudent = self.currentStudent;
    finalize.currentStudentSpeech = self.currentStudentSpeech;
    [self.navigationController pushViewController:finalize animated:YES];
}

@end
