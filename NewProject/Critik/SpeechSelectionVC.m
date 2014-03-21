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
    if(sender.tag == 0)
    {
        studentSelection.currSpeech = @"Informative";
        
    }
    if(sender.tag == 1){
        studentSelection.currSpeech = @"Persuasive";
    }
    if(sender.tag == 2){
        studentSelection.currSpeech = @"Interpersonal";
    }
    
    [self.navigationController pushViewController:studentSelection animated:YES];
}
@end
