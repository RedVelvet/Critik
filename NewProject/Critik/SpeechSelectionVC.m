//
//  SpeechSelectionVC.m
//  Critik
//
//  Created by Dalton Decker on 3/1/14.
//  Copyright (c) 2014 RedVelvet. All rights reserved.
//

#import "SpeechSelectionVC.h"

@interface SpeechSelectionVC ()

@end

@implementation SpeechSelectionVC
@synthesize managedObjectContext;
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


- (IBAction)chooseSpeech:(UIButton *)sender
{
    StudentSelectionVC * studentSelection = [self.storyboard instantiateViewControllerWithIdentifier:@"Student Selection"];
    
    // test if speech exists
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    self.managedObjectContext = [appDelegate managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Speech" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];

    if(sender.tag == 0)
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(speechType like %@)", @"Informative"];
        [fetchRequest setPredicate:predicate];
        
        NSError *error;
        NSUInteger count = [managedObjectContext countForFetchRequest:fetchRequest error:&error];
        
        if (count != 0) {
            studentSelection.currSpeech = @"Informative";
            [self.navigationController pushViewController:studentSelection animated:YES];
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Error" message: @"Please add an Informative Speech." delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }
    
    if(sender.tag == 1){
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(speechType like %@)", @"Persuasive"];
        [fetchRequest setPredicate:predicate];
        
        NSError *error;
        NSUInteger count = [managedObjectContext countForFetchRequest:fetchRequest error:&error];
        
        if (count != 0) {
            studentSelection.currSpeech = @"Persuasive";
            [self.navigationController pushViewController:studentSelection animated:YES];
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Error" message: @"Please add a Persuasive Speech." delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }
    
    if(sender.tag == 2){
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(speechType like %@)", @"Persuasive"];
        [fetchRequest setPredicate:predicate];
        
        NSError *error;
        NSUInteger count = [managedObjectContext countForFetchRequest:fetchRequest error:&error];
        
        if (count != 0) {
            studentSelection.currSpeech = @"Interpersonal";
            [self.navigationController pushViewController:studentSelection animated:YES];
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Error" message: @"Please add an Interpersonal Speech." delegate: nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }
}
@end
